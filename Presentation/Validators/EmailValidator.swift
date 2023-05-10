//
//  EmailValidator.swift
//  Presentation
//
//  Created by Rafael Douglas Sousa Barreto Dos Santos on 09/05/23.
//

import Foundation

public protocol EmailValidator {
    func isValid(email: String) -> Bool
}
