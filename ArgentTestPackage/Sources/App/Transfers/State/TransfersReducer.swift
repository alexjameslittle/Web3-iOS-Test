//
//  File.swift
//  
//
//  Created by Alex Little on 30/10/2021.
//

import Foundation
import ComposableArchitecture
import Environment

public let transfersReducer = Reducer<TransfersState, TransfersAction, AppEnvironment> { state, action, environment in
    switch action {
    case .fetchTransfers:
        return environment.blockchainClient.fetchERC20Transfers(.init(), on: environment.backgroundQueue)
            .catchToEffect()
            .map(TransfersAction.fetchTransfersResult)
            .receive(on: environment.mainQueue)
            .eraseToEffect()
    case .fetchTransfersResult(.success(let response)):
        state.erc20Transfers = response.reversed()
    case .fetchTransfersResult(.failure(let error)):
        print(error)
    }
    return .none
}
