//
// ServiceIdentifiers.swift
// NewFitness
// 
// Created by Maxim Abakumov on 2020. 12. 19.
//
// Copyright © 2020, Maxim Abakumov. MIT License.
//

import Foundation
import CoreBluetooth

public enum ServiceIdentifiers: String, CaseIterable {
    
    public static let serviceKey = "serviceKey"
    
    case deviceUuid = "180A"
    case batteryStatus = "180f"
    case manufacturer = "9000"
    case deviceConfiguration = "3A130000-55F3-421E-A928-3C7D7C395C8C"
    case channelService = "3A131000-55F3-421E-A928-3C7D7C395C8C"
    
    public var cbuuid: CBUUID {
        return CBUUID(string: rawValue)
    }
    
    public var name: String {
        switch self {
        case .channelService:
            return "ChannelService"
        case .deviceUuid:
            return "Device Info"
        case .batteryStatus:
            return "Battery Status"
        case .manufacturer:
            return "Manufacturer"
        case .deviceConfiguration:
            return "Device Configuration"
        }
    }
}
