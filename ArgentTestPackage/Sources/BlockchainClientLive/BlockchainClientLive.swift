//
//  File.swift
//  
//
//  Created by Alex Little on 29/10/2021.
//

import Foundation
import BlockchainClient
import web3
import BigInt
import Models

extension BlockchainClient {
    public static let live = BlockchainClient(
        fetchBalance: BlockchainClientLive.shared.fetchBalance,
        sendTestEther: BlockchainClientLive.shared.sendTestEther,
        fetchERC20Transfers: BlockchainClientLive.shared.fetchERC20Transactions
    )
}

class KeyStorage: EthereumKeyStorageProtocol {
    private var privateKey: String
    
    init(privateKey: String) {
        self.privateKey = privateKey
    }
    
    func storePrivateKey(key: Data) throws -> Void {
    }
    
    func loadPrivateKey() throws -> Data {
        return privateKey.web3.hexData!
    }
}

class BlockchainClientLive {
    static let shared = try! BlockchainClientLive()
    
    let argentWalletAddress = "0x70ABd7F0c9Bdc109b579180B272525880Fb7E0cB"
    let argentWalletPrivateKey = "0xec983791a21bea916170ee0aead71ab95c13280656e93ea4124c447bbd9a24a2"
    let transferManagerModuleAddress = "0xcdAd167a8A9EAd2DECEdA7c8cC908108b0Cc06D1"
    let account: EthereumAccount
    let client: EthereumClient
    
    init() throws {
        let keyStorage = KeyStorage(privateKey: argentWalletPrivateKey)
        let account = try EthereumAccount(keyStorage: keyStorage)
        self.account = account
        
        print("Public address: \(self.account.address.value)")
        
        let clientUrl = URL(string: "https://ropsten.infura.io/v3/735489d9f846491faae7a31e1862d24b")!
        let client = EthereumClient(url: clientUrl)
        self.client = client
    }
    
    private static let etherInWei = pow(Decimal(10), 18)
    
    func fetchBalance(_ request: BlockchainClient.FetchBalanceRequest) -> RequestEffect<BlockchainClient.FetchBalanceRequest> {
        return .future { promise in
            self.client.eth_getBalance(address: .init(self.argentWalletAddress), block: .Latest) { error, balance in
                if let balance = balance, let decimal = Decimal(string: String(balance)) {
                    promise(.success(decimal / BlockchainClientLive.etherInWei))
                } else if let error = error {
                    promise(.failure(.message(error.localizedDescription)))
                } else {
                    promise(.failure(.message("Unknown error")))
                }
            }
        }
    }
    
    func sendTestEther(_ request: BlockchainClient.SendTestEtherRequest) -> RequestEffect<BlockchainClient.SendTestEtherRequest> {
        return .future { promise in
            do {
                let function = TransferToken(
                    wallet: EthereumAddress(self.argentWalletAddress),
                    token: EthereumAddress("0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE"),
                    to: EthereumAddress("0xD2D77Df1E2E6D1C0ebbBD16e49b4408A43778f56"),
                    amount: 10000000000000000,
                    data: Data(),
                    gasPrice: 12000000000,
                    gasLimit: 250000
                )
                
                let transaction = try function.transaction()
                self.client.eth_sendRawTransaction(transaction, withAccount: self.account) { error, txhash in
                    if let txhash = txhash {
                        print("transactionHash: \(txhash)")
                        promise(.success(true))
                    } else if let error = error {
                        promise(.failure(.message(error.localizedDescription)))
                    } else {
                        promise(.failure(.message("Unknown error")))
                    }
                }
            } catch {
                promise(.failure(.message(error.localizedDescription)))
            }
        }
    }
    
    func fetchERC20Transactions(_ request: BlockchainClient.FetchERC20TransfersRequest) -> RequestEffect<BlockchainClient.FetchERC20TransfersRequest> {
        return .future { promise in
            let erc20Client = ERC20(client: self.client)
            let wallet = EthereumAddress(self.argentWalletAddress)
            
            erc20Client.transferEventsTo(recipient: wallet, fromBlock: .Earliest, toBlock: .Latest) { error, transfers in
                if let transfers = transfers {
                    let transfers = transfers.compactMap { transfer -> ERC20Transfer? in
                        guard let decimal = Decimal(string: String(transfer.value)) else {
                            return nil
                        }
                        return .init(from: transfer.from.value, token: transfer.log.address.value, value: decimal / BlockchainClientLive.etherInWei)
                    }
                    
                    promise(.success(transfers))
                } else if let error = error {
                    promise(.failure(.message(error.localizedDescription)))
                } else {
                    promise(.failure(.message("Unknown error")))
                }
            }
            
        }
    }
}


struct TransferToken: ABIFunction {
    static let name = "transferToken"
    let contract = EthereumAddress("0xcdAd167a8A9EAd2DECEdA7c8cC908108b0Cc06D1")
    var from: EthereumAddress? {
        return wallet
    }

    let wallet: EthereumAddress
    let token: EthereumAddress
    let to: EthereumAddress
    let amount: BigUInt
    let data: Data
    
    let gasPrice: BigUInt?
    let gasLimit: BigUInt?
    
    func encode(to encoder: ABIFunctionEncoder) throws {
        try encoder.encode(wallet)
        try encoder.encode(token)
        try encoder.encode(to)
        try encoder.encode(amount)
        try encoder.encode(data)
    }
}
