//
//  HttpError.swift
//  Data
//
//  Created by Rafael Douglas Sousa Barreto Dos Santos on 24/04/23.
//

import Foundation

public enum HttpError: Error {
    case noConnectivity
    case badRequest
    case serverError
    case unauthorized
    case forbidden
}
