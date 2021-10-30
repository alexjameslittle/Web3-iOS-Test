//
//  File.swift
//  
//
//  Created by Alex Little on 29/10/2021.
//

import ComposableArchitecture
import Environment

public let appReducer = Reducer<AppState, AppAction, AppEnvironment>.combine(
    transfersReducer
        .pullback(
            state: \.transfers,
            action: /AppAction.transfers,
            environment: { $0 }
        ),
    appCoreReducer
)

public let appCoreReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
    switch action {
    case .fetchBalance:
        guard !state.isFetchingBalance else { break }
        
        state.isFetchingBalance = true
        return environment.blockchainClient.fetchBalance(.init(), on: environment.backgroundQueue)
            .catchToEffect()
            .map(AppAction.fetchBalanceResult)
            .receive(on: environment.mainQueue)
            .eraseToEffect()
    case .fetchBalanceResult(.success(let response)):
        state.isFetchingBalance = false
        state.balance = response
    case .fetchBalanceResult(.failure(let error)):
        state.isFetchingBalance = false
        print(error)
        
    case .sendTestEther:
        return environment.blockchainClient.sendTestEther(.init(recipient: "0xD2D77Df1E2E6D1C0ebbBD16e49b4408A43778f56"), on: environment.backgroundQueue)
            .catchToEffect()
            .map(AppAction.sendTestEtherResult)
            .receive(on: environment.mainQueue)
            .eraseToEffect()
    case .sendTestEtherResult(.success):
        return .init(value: .fetchBalance)
    case .sendTestEtherResult(.failure(let error)):
        print(error)
        
    case .showERC20Transfers:
        state.push = .ercTransfers
    case .hidePush:
        state.push = nil
        
    case .transfers:
        break
    }
    return .none
}
