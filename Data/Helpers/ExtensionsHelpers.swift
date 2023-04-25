//
//  ExtensionsHelpers.swift
//  Data
//
//  Created by Rafael Douglas Sousa Barreto Dos Santos on 24/04/23.
//

import Foundation

public extension Data {
    func toModel<T: Decodable>() -> T? {
        return try? JSONDecoder().decode(T.self, from: self)
    }
}
