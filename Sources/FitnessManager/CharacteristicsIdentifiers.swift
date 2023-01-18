//
// CharacteristicsIdentifiers.swift
// NewFitness
// 
// Created by Maxim Abakumov on 2020. 12. 19.
//
// Copyright © 2020, Maxim Abakumov. MIT License.
//

import Foundation
import CoreBluetooth

public enum CharacteristicsIdentifiers: String, CaseIterable {
    case batteryStatus = "2a19"
    case firmwareRevision = "2A26"
    case hardwareRevision = "2A27"
    case softwareVersion = "2A28"
    case operationalMode = "3A130001-55F3-421E-A928-3C7D7C395C8C" // 0 or 1
    case innerPulseFrequency = "3A130002-55F3-421E-A928-3C7D7C395C8C" // Частота 1-60 kHz
    case pulsePeriod = "3A130003-55F3-421E-A928-3C7D7C395C8C" // Пауза 10-100ms
    case burstTime = "3A130004-55F3-421E-A928-3C7D7C395C8C" // Длительность воздействия 0-60s
    case burstPeriod = "3A130005-55F3-421E-A928-3C7D7C395C8C" // ВМР 0-60s
    case pulseTime = "3a130006-55f3-421e-a928-3c7d7c395c8c" // Длительность Pulse time 0-500uS
    case voltage = "3A130006-55F3-421E-A928-3C7D7C395C8C" // reserved
    case current = "3A130007-55F3-421E-A928-3C7D7C395C8C" // current
    case channel1 = "3A131001-55F3-421E-A928-3C7D7C395C8C" // Ch1 Power 0-100
    case channel2 = "3A131002-55F3-421E-A928-3C7D7C395C8C" // Ch2 Power 0-100
    case channel3 = "3A131003-55F3-421E-A928-3C7D7C395C8C" // Ch3 Power 0-100
    case channel4 = "3A131004-55F3-421E-A928-3C7D7C395C8C" // Ch4 Power 0-100
    case channel5 = "3A131005-55F3-421E-A928-3C7D7C395C8C" // Ch5 Power 0-100
    case channel6 = "3A131006-55F3-421E-A928-3C7D7C395C8C" // Ch6 Power 0-100
    case channel7 = "3A131007-55F3-421E-A928-3C7D7C395C8C" // Ch7 Power 0-100
    case channel8 = "3A131008-55F3-421E-A928-3C7D7C395C8C" // Ch8 Power 0-100
    case channel9 = "3A131009-55F3-421E-A928-3C7D7C395C8C" // Ch9 Power 0-100
    
    public var cbuuid: CBUUID {
        return CBUUID(string: rawValue)
    }
    
    public var name: String {
        switch self {
        case .operationalMode:
            return "Operational Mode"
        case .innerPulseFrequency:
            return "Inner Pulse Frequency"
        case .pulsePeriod:
            return "Pulse Period"
        case .burstTime:
            return "Burst Time"
        case .burstPeriod:
            return "Burst Period"
        case .pulseTime:
            return "Pulse Time"
        case .voltage:
            return "Voltage[reserved]"
        case .current:
            return "Current[reserved]"
        case .channel1:
            return "Channel 1"
        case .channel2:
            return "Channel 2"
        case .channel3:
            return "Channel 3"
        case .channel4:
            return "Channel 4"
        case .channel5:
            return "Channel 5"
        case .channel6:
            return "Channel 6"
        case .channel7:
            return "Channel 7"
        case .channel8:
            return "Channel 8"
        case .channel9:
            return "Channel 9"
        default:
            return "None"
        }
    }
}
