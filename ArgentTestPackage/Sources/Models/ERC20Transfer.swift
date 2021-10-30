//
//  File.swift
//  
//
//  Created by Alex Little on 30/10/2021.
//

import Foundation

public struct ERC20Transfer: Identifiable, Equatable {
    public let id: String
    
    public let from: String
    public let token: String
    public let value: Decimal
    
    public init(from: String, token: String, value: Decimal) {
        self.id = from + token + value.description
        self.from = from
        self.token = token
        self.value = value
    }
}
