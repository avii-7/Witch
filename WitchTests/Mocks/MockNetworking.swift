//
//  MockNetworking.swift
//  WitchTests
//
//  Created by Glny Gl on 20/10/2024.
//

import XCTest
@testable import Witch
@testable import Network

final class MockNetworking: NetworkingProtocol, @unchecked Sendable {
    
    var resultToReturn: GameList?
    
    func request<T>(requestable: URLRequestable, responseType: T.Type) async throws(NetworkError) -> T where T : Decodable {
        if let resultToReturn = resultToReturn as? T {
            return resultToReturn
        }
        throw NetworkError.unknown
    }
}
