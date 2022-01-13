//
//  Copyright © 2019 Gnosis Ltd. All rights reserved.
//

import Foundation
import WalletConnectSwift

protocol WalletConnectDelegate {
    func failedToConnect()
    func didConnect()
    func didDisconnect()
}

class WalletConnect: ClientDelegate {
    func client(_ client: Client, didFailToConnect url: WCURL) {
        <#code#>
    }
    
    func client(_ client: Client, didConnect url: WCURL) {
        <#code#>
    }
    
    func client(_ client: Client, didConnect session: Session) {
        <#code#>
    }
    
    func client(_ client: Client, didDisconnect session: Session) {
        <#code#>
    }
    
    func client(_ client: Client, didUpdate session: Session) {
        <#code#>
    }
    
    var client: Client!
    var session: Session!

    let sessionKey = "sessionKey"

    /// The static field that controls the access to the singleton instance.
    ///
    /// This implementation let you extend the Singleton class while keeping
    /// just one instance of each subclass around.
    static var shared: WalletConnect = {
        let instance = WalletConnect()
        // ... configure the instance
        // ...
        return instance
    }()
    
    private init() {
    
    }

    func connect() -> String {
        // gnosis wc bridge: https://safe-walletconnect.gnosis.io/
        // test bridge with latest protocol version: https://bridge.walletconnect.org
        let wcUrl =  WCURL(topic: UUID().uuidString,
                           bridgeURL: URL(string: "http://localhost")!,
                           key: try! randomKey())
        let clientMeta = Session.ClientMeta(name: "ACC: NFT Viewer",
                                            description: "Login with wallet connect. Permission required: Public Address",
                                            icons: [],
                                            url: URL(string: "www.faktura.art")!)
        let dAppInfo = Session.DAppInfo(peerId: UUID().uuidString, peerMeta: clientMeta)
        client = Client(delegate: self, dAppInfo: dAppInfo)

        print("WalletConnect URL: \(wcUrl.absoluteString)")

        try! client.connect(to: wcUrl)
        return wcUrl.absoluteString
    }

    func reconnectIfNeeded() {
        if let oldSessionObject = UserDefaults.standard.object(forKey: sessionKey) as? Data,
            let session = try? JSONDecoder().decode(Session.self, from: oldSessionObject) {
            client = Client(delegate: self, dAppInfo: session.dAppInfo)
            try? client.reconnect(to: session)
        }
    }

    // https://developer.apple.com/documentation/security/1399291-secrandomcopybytes
    private func randomKey() throws -> String {
        var bytes = [Int8](repeating: 0, count: 32)
        let status = SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes)
        if status == errSecSuccess {
            return Data(bytes: bytes, count: 32).toHexString()
        } else {
            // we don't care in the example app
            enum TestError: Error {
                case unknown
            }
            throw TestError.unknown
        }
    }
}


