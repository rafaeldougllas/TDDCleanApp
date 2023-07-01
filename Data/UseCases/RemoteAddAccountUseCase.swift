//
//  RemoteAddAccountUseCase.swift
//  Data
//
//  Created by Rafael Douglas Sousa Barreto Dos Santos on 24/04/23.
//

import Foundation
import Domain

public final class RemoteAddAccountUseCase: AddAccount {
    private let url: URL
    private let httpClient: HttpPostClient
    
    public init(url: URL, httpClient: HttpPostClient) {
        self.url = url
        self.httpClient = httpClient
    }
    
    public func add(addAccountModel: AddAccountModel, completion: @escaping (AddAccount.Result) -> Void) {
        httpClient.post(to: url,
                        with: addAccountModel.toData()) { [weak self] result in
            guard self != nil else { return } // Prevents the completion from being called after losing the instance
            
            switch result {
            case .success(let data):
                if let model: AccountModel = data?.toModel() {
                    completion(.success(model))
                } else {
                    completion(.failure(.unexpected))
                }
            case .failure:
                completion(.failure(.unexpected))
            }
        }
    }
}
