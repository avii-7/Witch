//
//  RequestExecutorTests.swift
//  Network
//
//  Created by Glny Gl on 27/10/2024.
//

import XCTest
@testable import Network

final class RequestExecutorTests: XCTestCase {

    var requestExecutor: MockRequestExecutor!
    var urlRequestHelper: URLRequestHelper!
    var mockRequest: MockRequest!

    override func setUp() {
        super.setUp()
        requestExecutor = MockRequestExecutor()
        urlRequestHelper = URLRequestHelper()
        mockRequest = MockRequest()
    }

    override func tearDown() {
        requestExecutor = nil
        urlRequestHelper = nil
        mockRequest = nil
        super.tearDown()
    }
    
    func test_execute_success() async {
        
        do {
            let urlRequest = try urlRequestHelper.makeURLRequest(requestable: mockRequest)
            requestExecutor.isExecuteSuccess = true
            let result = try await requestExecutor.execute(urlRequest)
            XCTAssertNotNil(result.data)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func test_execute_fail() async {
        
        do {
            let urlRequest = try urlRequestHelper.makeURLRequest(requestable: mockRequest)
            requestExecutor.isExecuteSuccess = false
            let result = try await requestExecutor.execute(urlRequest)
            XCTAssertNil(result.data)
        } catch {
            XCTAssertNotNil(error)
        }
    }
}
