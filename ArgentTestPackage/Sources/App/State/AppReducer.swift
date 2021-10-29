//
//  File.swift
//  
//
//  Created by Alex Little on 29/10/2021.
//

import ComposableArchitecture
import Environment

public let appReducer = Reducer<AppState, AppAction, AppEnvironment> { state, action, environment in
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
        state.balance = response
    case .fetchBalanceResult(.failure(let error)):
        print(error)
    }
    return .none
}
