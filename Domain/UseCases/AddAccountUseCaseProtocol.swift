//
//  AddAccountUseCase.swift
//  Domain
//
//  Created by Rafael Douglas Sousa Barreto Dos Santos on 27/01/23.
//

import Foundation

public protocol AddAccountUseCaseProtocol {
    typealias Result = Swift.Result<AccountModel, DomainError>
    func add(account: Account,
             completion: @escaping (AddAccountUseCaseProtocol.Result) -> Void)
}

public struct Account: Model {
    var name: String
    var email: String
    var password: String
    var passwordConfirm: String
    
    public init(name: String, email: String, password: String, passwordConfirm: String) {
        self.name = name
        self.email = email
        self.password = password
        self.passwordConfirm = passwordConfirm
    }
}
