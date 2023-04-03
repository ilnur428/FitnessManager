//
// FitnessManager.swift
// NewFitness
// 
// Created by Maxim Abakumov on 2020. 12. 18.
//
// Copyright © 2020, Maxim Abakumov. MIT License.
//

import Foundation
import CoreBluetooth

public final class FitnessManager: NSObject {
    
    public typealias ResultHandler = ((Bool, FitnessError?) -> Void)?
    public typealias ServiceResultHandler = (([CBService], FitnessError?) -> Void)?
    public typealias CharacteristicsHandler = (([CBCharacteristic], FitnessError?) -> Void)?
    public typealias ValueHandler = ((Int, FitnessError?) -> Void)?
    
    public static let shared = FitnessManager()
    public var device: CBPeripheral?
    public var devices: [CBPeripheral] = []
    // MARK: - Private properties
    
    private let connector = Connector()
    private var completionHandler: ResultHandler
    private var serviceCompletionHandler: ServiceResultHandler
    private var characteristicsHandler: CharacteristicsHandler
    private var valueHandler: ValueHandler
    private var isDeviceOn = false
    
    private override init() {
        completionHandler = nil
        serviceCompletionHandler = nil
        characteristicsHandler = nil
        valueHandler = nil
        super.init()
        connector.delegate = self
    }
    
    deinit {
        connector.delegate = nil
    }
    
    // MARK: - Interface: Connect / Disconnect
    
    public func connectEmsFitness(completion: ResultHandler) {
        if isDeviceOn {
            connector.centralManager.connect(connector.peripheralDevice, options: nil)
            completion?(true, nil)
        } else {
            completion?(false, .tryAgain)
        }
    }
    
    public func connectEmsFitnessGetServiceList(completion: ServiceResultHandler) {
        serviceCompletionHandler = completion
        if isDeviceOn {
            connector.centralManager.connect(connector.peripheralDevice, options: nil)
        } else {
            print("надо реализовать ResultHandler")
        }
    }
    
    public func disconnectEmsFitness(completion: ResultHandler) {
        guard let device = connector.peripheralDevice else {
            completion?(false, .tryAgain)
            return
        }
        connector.centralManager.cancelPeripheralConnection(device)
        completionHandler = completion
    }
    
    public func getCharacteristicsList(
        for service: CBService,
        with cbuuid: [CBUUID]?,
        completion: CharacteristicsHandler
    ) {
        characteristicsHandler = completion
        connector.peripheralDevice.discoverCharacteristics(cbuuid, for: service)
    }
    
    // MARK: - Interface: characteristic read/write value
    
    public func readValue(for characteristic: CBCharacteristic, completion: ValueHandler) {
        valueHandler = completion
        connector.peripheralDevice.readValue(for: characteristic)
    }
    
    public func writeValue(
        value: Int,
        length: Int,
        for characteristic: CBCharacteristic,
        completion: ValueHandler
    ) {
        valueHandler = completion
        let data = convertIntToData(value, length: length)
        connector.peripheralDevice.writeValue(
            data,
            for: characteristic,
            type: .withResponse
        )
    }
    
    private func convertIntToData(_ value: Int, length: Int) -> Data {
        var data = Data()
        switch length {
        case 1:
            let bytes: [UInt8] = [UInt8(value)]
            data = Data(bytes: bytes, count: length)
        case 2:
            let bytes: [UInt16] = [UInt16(value)]
            data = Data(bytes: bytes, count: length)
        default:
            break
        }
        
        return data
    }
    
    private func convertDataToInt(_ data: Data) -> Int {
        var value = -1
        switch data.count {
        case 1:
            value = Int(data.withUnsafeBytes { $0.load(as: UInt8.self) })
        case 2:
            value = Int(data.withUnsafeBytes { $0.load(as: UInt16.self) })
        default:
            break
        }
        
        return value
    }
    
}

extension FitnessManager: ConnectorDelegate {
    
    func connector(didDiscover peripheral: CBPeripheral) {
        isDeviceOn = true
        devices = peripheral
    }
    
    func connector(didConnect to: CBPeripheral, error: FitnessError?) {
        completionHandler?(true, error)
        completionHandler = nil
    }
    
    func connector(didDisconnect from: CBPeripheral, error: FitnessError?) {
        completionHandler?(true, error)
        completionHandler = nil
    }
    
    func connector(didDiscover services: [CBService], error: FitnessError?) {
        serviceCompletionHandler?(services, error)
        serviceCompletionHandler = nil
    }
    
    func connector(didDiscover characteristics: [CBCharacteristic], for service: CBService, error: FitnessError?) {
        characteristicsHandler?(characteristics, error)
        characteristicsHandler = nil
    }
    
    func connector(didReadValueFor characteristic: CBCharacteristic, error: FitnessError?) {
        guard let cValue = characteristic.value else {
            valueHandler?(-1, .errorReadingValue)
            valueHandler = nil
            return
        }
        let converted = convertDataToInt(cValue)
        valueHandler?(converted, error)
        valueHandler = nil
    }
    
    func connector(didWriteValueFor characteristic: CBCharacteristic, error: FitnessError?) {

        connector.peripheralDevice.readValue(for: characteristic)
    }
}

