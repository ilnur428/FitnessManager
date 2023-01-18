//
// FitnessError.swift
// NewFitness
// 
// Created by Maxim Abakumov on 2020. 12. 19.
//
// Copyright © 2020, Maxim Abakumov. MIT License.
//

import Foundation
import CoreBluetooth

public enum FitnessError: String, Error {
    case deviceIsSwitchedOff = "Устройство выключено"
    case tryAgain = "Попробуйте еще раз"
    case noServicesDiscovered = "Не найдены сервисы"
    case noCharacteristicsDiscovered = "Не найдены характеристики"
    case errorReadingValue = "Ошибка чтения значения"
    case errorWritingValue = "Ошибка записи значения"
}

