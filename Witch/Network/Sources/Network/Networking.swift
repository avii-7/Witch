//
//  Networking.swift
//  Network
//
//  Created by Glny Gl on 15/10/2024.
//
import Foundation

public protocol NetworkingProtocol: Sendable {
    func request<T:Decodable>(requestable: URLRequestable, responseType: T.Type) async throws (NetworkError) -> T
}

public final class Networking {
    private let session: URLSession
    private let helper: URLRequestHelperProtocol
    private let parser: ResponseParserProtocol
    private let executor: RequestExecutorProtocol
    
    public init() {
        self.session = URLSession(configuration: .default)
        self.helper = URLRequestHelper()
        self.parser = ResponseParser()
        self.executor = RequestExecutor(session: .shared)
    }
    
    deinit {
        session.finishTasksAndInvalidate()
    }
}

extension Networking: NetworkingProtocol {
    public func request<T:Decodable>(requestable: URLRequestable, responseType: T.Type) async throws (NetworkError) -> T {
        do {
            let urlRequest = try helper.makeURLRequest(requestable: requestable)
            let result = try await executor.execute(urlRequest)
            return try successRequest(with: result, responseType: responseType)
        } catch let error {
            if let networkError = error as? NetworkError {
                throw networkError
            } else {
                throw failRequest(error: error)
            }
        }
    }
}

extension Networking {
    private func successRequest<T: Decodable>(with successModel: RequestSuccess, responseType: T.Type) throws (NetworkError) -> T {
        do {
            return try parseResponse(with: successModel, responseType: responseType)
        } catch {
            throw failRequest(error: error)
        }
    }
    
    
    private func parseResponse<T: Decodable>(with successModel: RequestSuccess, responseType: T.Type) throws (NetworkError) -> T {
        let parsingResult = try parser.parseResponse(data: successModel.data, responseType: responseType)
        return parsingResult
    }
    
    private func failRequest(error: Error) -> NetworkError {
        let nsError = error as NSError
        if nsError.code == NSURLErrorTimedOut {
            return .requestTimeOut
        } else if nsError.code == NSURLErrorNotConnectedToInternet {
            return .noInternetConnection
        } else if nsError.code == NSURLErrorCancelled {
            return .requestCancelled
        } else {
            return .executionError
        }
    }
}
