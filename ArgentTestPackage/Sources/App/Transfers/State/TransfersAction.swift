//
//  File.swift
//  
//
//  Created by Alex Little on 30/10/2021.
//

import Foundation
import BlockchainClient

public enum TransfersAction: Equatable {
    case fetchTransfers
    case fetchTransfersResult(BlockchainClient.FetchERC20TransfersRequest.Result)
}
