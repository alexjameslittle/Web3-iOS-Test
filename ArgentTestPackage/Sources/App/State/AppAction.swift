//
//  File.swift
//  
//
//  Created by Alex Little on 29/10/2021.
//

import Foundation
import BlockchainClient

public enum AppAction: Equatable {
    case fetchBalance
    case fetchBalanceResult(BlockchainClient.FetchBalanceRequest.Result)
    
    case sendTestEther
    case sendTestEtherResult(BlockchainClient.SendTestEtherRequest.Result)
    
    case showERC20Transfers
    
    case hidePush
    
    case transfers(TransfersAction)
}
