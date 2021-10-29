//
//  File.swift
//  
//
//  Created by Alex Little on 29/10/2021.
//

import BlockchainClient
import ComposableArchitecture

public struct AppEnvironment {
    public let blockchainClient: BlockchainClient
    public let mainQueue: AnySchedulerOf<DispatchQueue>
    public let backgroundQueue: AnySchedulerOf<DispatchQueue>
    
    public init(
        blockchainClient: BlockchainClient,
        mainQueue: AnySchedulerOf<DispatchQueue>,
        backgroundQueue: AnySchedulerOf<DispatchQueue>
    ) {
        self.blockchainClient = blockchainClient
        self.mainQueue = mainQueue
        self.backgroundQueue = backgroundQueue
    }
}
