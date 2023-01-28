//
//  AddAccountUseCase.swift
//  Domain
//
//  Created by Rafael Douglas Sousa Barreto Dos Santos on 27/01/23.
//

import Foundation

protocol AddAccountUseCase {
    func add(account: AddAccount,
             completion: @escaping (Result<AccountModel, Error>) -> Void)
}

struct AddAccount {
    var name: String
    var email: String
    var password: String
    var passwordConfirm: String
}
