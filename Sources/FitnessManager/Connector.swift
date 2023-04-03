//
// Connector.swift
// NewFitness
// 
// Created by Maxim Abakumov on 2020. 12. 19.
//
// Copyright © 2020, Maxim Abakumov. MIT License.
//

import Foundation
import CoreBluetooth

protocol ConnectorDelegate: AnyObject {
    func connector(didDiscover peripheral: CBPeripheral)
    func connector(didConnect to: CBPeripheral, error: FitnessError?)
    func connector(didDisconnect from: CBPeripheral, error: FitnessError?)
    func connector(didDiscover services: [CBService], error: FitnessError?)
    func connector(didDiscover characteristics: [CBCharacteristic], for service: CBService, error: FitnessError?)
    func connector(didReadValueFor characteristic: CBCharacteristic, error: FitnessError?)
    func connector(didWriteValueFor characteristic: CBCharacteristic, error: FitnessError?)
}

class Connector: NSObject {
    
    var peripheralDevice: CBPeripheral! {
        didSet {
            peripheralDevice.delegate = self
        }
    }
    
    weak var delegate: ConnectorDelegate?
    var centralManager: CBCentralManager!
    
    override init() {
        super.init()
        centralManager = CBCentralManager(
            delegate: self,
            queue: nil
        )
    }
}

extension Connector: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            centralManager.scanForPeripherals(
                withServices:
                    [
                        //ServiceIdentifiers.deviceUuid.cbuuid
                    ]
            )
        default:
            break
        }
    }
    
    func centralManager(
        _ central: CBCentralManager,
        didDiscover peripheral: CBPeripheral,
        advertisementData: [String : Any],
        rssi RSSI: NSNumber
    ) {
        peripheralDevice = peripheral
        delegate?.connector(didDiscover: peripheralDevice)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        delegate?.connector(didConnect: peripheralDevice, error: nil)
        peripheralDevice.discoverServices(ServiceIdentifiers.allCases.map { $0.cbuuid })
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        delegate?.connector(didDisconnect: peripheralDevice, error: error as? FitnessError)
    }
}

extension Connector: CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else {
            delegate?.connector(didDiscover: [], error: .noServicesDiscovered)
            return
        }
        
        delegate?.connector(didDiscover: services, error: error as? FitnessError)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            delegate?.connector(didDiscover: characteristics, for: service, error: error as? FitnessError)
        } else {
            delegate?.connector(didDiscover: [], for: service, error: .noCharacteristicsDiscovered)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        delegate?.connector(didReadValueFor: characteristic, error: error as? FitnessError)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        delegate?.connector(didWriteValueFor: characteristic, error: error as? FitnessError)
    }
}
