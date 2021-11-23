//
//  WalletStreamHandler.swift
//  Runner
//
//

import WalletConnectSwift


class WalletStreamHandler: NSObject, FlutterStreamHandler {
    var delegate: WalletConnectDelegate

    private var eventSink: FlutterEventSink? = nil

    init() {
        WalletConnect.shared.session.
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        NotificationCenter.default.addObserver(self, selector: #selector(connectionChanged(notification:)), name: Notification.Name.reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
           return FlutterError(code: "1", message: "Could not start notififer", details: nil)
        }
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
        eventSink = nil
        return nil
    }
    
    @objc func connectionChanged(notification: NSNotification) {
        let reachability = notification.object as! Reachability
        switch reachability.connection {
        case .wifi:
            eventSink?(Constants.wifi)
        case .cellular:
            eventSink?(Constants.cellular)
        case .unavailable:
            eventSink?(Constants.disconnected)
        case .none:
            eventSink?(Constants.unknown)
        }
    }

    
}

extension WalletStreamHandler: ClientDelegate {
    func client(_ client: Client, didFailToConnect url: WCURL) {
        delegate.failedToConnect()
    }

    func client(_ client: Client, didConnect url: WCURL) {
        // do nothing
    }

    func client(_ client: Client, didConnect session: Session) {
        self.session = session
        let sessionData = try! JSONEncoder().encode(session)
        UserDefaults.standard.set(sessionData, forKey: sessionKey)
        delegate.didConnect()
    }

    func client(_ client: Client, didDisconnect session: Session) {
        UserDefaults.standard.removeObject(forKey: sessionKey)
        delegate.didDisconnect()
    }

    func client(_ client: Client, didUpdate session: Session) {
        // do nothing
    }
}
