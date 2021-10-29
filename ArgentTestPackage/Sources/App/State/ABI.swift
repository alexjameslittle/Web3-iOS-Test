//
//  File.swift
//  
//
//  Created by Alex Little on 29/10/2021.
//

import Foundation

let abi = """
"abi": [
{
"constant": false,
"inputs": [
{
"name": "_wallet",
"type": "address"
},
{
"name": "_token",
"type": "address"
},
{
"name": "_to",
"type": "address"
},
{
"name": "_amount",
"type": "uint256"
},
{
"name": "_data",
"type": "bytes"
}
],
"name": "transferToken",
"outputs": [],
"payable": false,
"stateMutability": "nonpayable",
"type": "function"
}
]
"""
