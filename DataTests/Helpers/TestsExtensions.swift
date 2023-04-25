//
//  TestsExtensions.swift
//  DataTests
//
//  Created by Rafael Douglas Sousa Barreto Dos Santos on 25/04/23.
//

import Foundation
import XCTest

extension XCTestCase {
    func checkMemoryLeak(for instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, file: file, line: line)
        }
    }
}
