//
//  File.swift
//  
//
//  Created by Alex Little on 29/10/2021.
//

import Foundation
import BlockchainClient
import web3

extension BlockchainClient {
    public static let live = BlockchainClient(
        fetchBalance: BlockchainClientLive.shared.fetchBalance
    )
}

class BlockchainClientLive {
    static let shared = try! BlockchainClientLive()
    
    let argentWalletAddress = "0x70ABd7F0c9Bdc109b579180B272525880Fb7E0cB"
    let argentWalletPrivateKey = "0xec983791a21bea916170ee0aead71ab95c13280656e93ea4124c447bbd9a24a2"
    let transferManagerModuleAddress = "0xcdAd167a8A9EAd2DECEdA7c8cC908108b0Cc06D1"
    let account: EthereumAccount
    let client: EthereumClient
    
    init() throws {
        let keyStorage = EthereumKeyLocalStorage()
        try keyStorage.storePrivateKey(key: argentWalletPrivateKey.data(using: .utf8)!)
        let account = try EthereumAccount.create(keyStorage: keyStorage, keystorePassword: "MY_PASSWORD")
        self.account = account
        
        let clientUrl = URL(string: "https://ropsten.infura.io/v3/735489d9f846491faae7a31e1862d24b")!
        let client = EthereumClient(url: clientUrl)
        self.client = client
    }
    
    private static let etherInWei = pow(Decimal(10), 18)
    
    func fetchBalance(_ request: BlockchainClient.FetchBalanceRequest) -> RequestEffect<BlockchainClient.FetchBalanceRequest> {
        return .future { promise in
            self.client.eth_getBalance(address: .init("0x70ABd7F0c9Bdc109b579180B272525880Fb7E0cB"), block: .Latest) { error, balance in
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
}
