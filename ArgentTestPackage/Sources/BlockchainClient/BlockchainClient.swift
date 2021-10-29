//
//  File.swift
//  
//
//  Created by Alex Little on 29/10/2021.
//

import Foundation
import ComposableArchitecture

extension RequestEffect {
    func listenForUnauthenticatedError(handler: @escaping (Self.Failure) -> Bool) -> Self {
        return self.catch { error -> Self in
            let isUnauthenticated = handler(error)
            return isUnauthenticated ? .none : .init(error: error)
        }.eraseToEffect()
    }
}

public protocol BlockchainErrorType: Equatable, Swift.Error {
    static func message(_ message: String) -> Self
}

public protocol Requestable: Equatable {
    associatedtype Error: BlockchainErrorType
    associatedtype Response: Equatable
    associatedtype ReturnEffect = Effect<Response, Error>
    associatedtype Result = Swift.Result<Response, Error>
}

public typealias RequestEffect<Request: Requestable> = Effect<Request.Response, Request.Error>
public typealias RequestFunction<Request: Requestable> = (Request) -> RequestEffect<Request>

public struct BlockchainClient {
    public var fetchBalance: RequestFunction<FetchBalanceRequest>
    public init(
        fetchBalance: @escaping RequestFunction<FetchBalanceRequest>
    ) {
        self.fetchBalance = fetchBalance
    }
        
    public func fetchBalance(
        _ request: FetchBalanceRequest,
        on queue: AnySchedulerOf<DispatchQueue>
    ) -> RequestEffect<FetchBalanceRequest> {
        Effect(value: request)
            .subscribe(on: queue)
            .flatMap { request in self.fetchBalance(request) }
            .eraseToEffect()
    }
    
    public struct FetchBalanceRequest: Requestable {
        public init() {
        }
        
        public typealias Response = Decimal
        
        public enum Error: BlockchainErrorType {
            case message(_ message: String)
        }
    }
}
