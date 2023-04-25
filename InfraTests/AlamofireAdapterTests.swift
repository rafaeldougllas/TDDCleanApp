//
//  AlamofireAdapterTests.swift
//  InfraTests
//
//  Created by Rafael Douglas Sousa Barreto Dos Santos on 25/04/23.
//

import XCTest
import Alamofire

class AlamofireAdapter {
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func post(to url: URL, with data: Data?) {
        let json = data == nil ? nil : try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
        session.request(url, method: .post, parameters: json, encoding: JSONEncoding.default).resume()
    }
}

final class AlamofireAdapterTests: XCTestCase {
    func test_post_should_make_request_with_valid_url_and_method() {
        let url = makeUrl()
        let sut = makeSut()
        sut.post(to: url, with: makeValidData())
        let expectation = expectation(description: "Waiting Async Method")
        UrlProtocolStub.observerRequest(completion: { request in
            XCTAssertEqual(url, request.url)
            XCTAssertEqual("POST", request.httpMethod)
            XCTAssertNotNil(request.httpBodyStream)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)
    }
    
    func test_post_should_make_request_with_no_data() {
        let sut = makeSut()
        sut.post(to: makeUrl(), with: nil)
        let expectation = expectation(description: "Waiting Async Method")
        UrlProtocolStub.observerRequest(completion: { request in
            XCTAssertNil(request.httpBodyStream)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)
    }
}

extension AlamofireAdapterTests {
    func makeSut() -> AlamofireAdapter {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [UrlProtocolStub.self]
        let session = Session(configuration: configuration)
        return AlamofireAdapter(session: session)
    }
}

class UrlProtocolStub: URLProtocol {
    static var emit: ((URLRequest) -> Void)?
    static func observerRequest(completion: @escaping (URLRequest) -> Void) {
        UrlProtocolStub.emit = completion
    }
    
    override open class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override open func startLoading() {
        UrlProtocolStub.emit?(request)
    }
    
    override open func stopLoading() {
        
    }
}
