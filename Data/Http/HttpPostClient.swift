//
//  HttpPostClient.swift
//  Data
//
//  Created by Rafael Douglas Sousa Barreto Dos Santos on 24/04/23.
//

import Foundation

public protocol HttpPostClient {
    func post(to url: URL,
              with data: Data?,
              completion: @escaping (Result<Data?, HttpError>) -> (Void))
}
