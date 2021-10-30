//
//  File.swift
//  
//
//  Created by Alex Little on 30/10/2021.
//

import Foundation
import IdentifiedCollections
import Models

public struct TransfersState: Equatable {
    public var erc20Transfers = [ERC20Transfer]()
}
