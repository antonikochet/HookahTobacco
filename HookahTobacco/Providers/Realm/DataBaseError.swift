//
//  DataBaseError.swift
//  HookahTobacco
//
//  Created by антон кочетков on 20.11.2022.
//

import Foundation

enum DataBaseError: Error {
    case fileDBNotFound
    case schemaMismatchError
    case notAccessDBError
    case wrongTypeError
}

extension DataBaseError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .fileDBNotFound:
            return "Файл базы данных не найден"
        case .schemaMismatchError:
            return "Ошибка миграции базы данных"
        case .notAccessDBError:
            return "Нет доступа к базе данных"
        case .wrongTypeError:
            return "Передан неподходящий тип для работы с базой данных"
        }
    }
}
