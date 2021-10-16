import UIKit
import Flutter
import Vapor

private let CHANNEL = "com.bimsina.re_walls/MainActivity"
private let WALLET_CONNECTION = "initWalletConnection"
private let WALLET_DISCONNECTION = "initWalletDisconnection"

var walletConnect: WalletConnect!
//var handshakeController: HandshakeViewController!

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: CHANNEL,
                                                  binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler({
          (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          // Note: this method is invoked on the UI thread.
            if(call.method == WALLET_CONNECTION) {
                self.initWalletConnection()
            } else {
              result(FlutterMethodNotImplemented)
              return
            }
        })

        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func initWalletConnection() {
        let thread = Thread.init(target: self, selector: #selector(longRunningProcess), object: nil)
        thread.start()
        
        walletConnect = WalletConnect(delegate: self)
        let connectionUrl = walletConnect.connect()

        /// https://docs.walletconnect.org/mobile-linking#for-ios
        /// **NOTE**: Majority of wallets support universal links that you should normally use in production application
        /// Here deep link provided for integration with server test app only
        let deepLinkUrl = "wc://wc?uri=\(connectionUrl)"

        if let url = URL(string: deepLinkUrl), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    //    else {
    //        handshakeController = HandshakeViewController.create(code: connectionUrl)
    //        //present(handshakeController, animated: true)
    //    }
    }


    @objc func longRunningProcess()
    {
        var env = try! Environment.detect()
        try! LoggingSystem.bootstrap(from: &env)
        let app = Application(env)
        defer { app.shutdown() }
        try! configure(app)
        try! app.run()
    }
    
    func onMainThread(_ closure: @escaping () -> Void) {
        if Thread.isMainThread {
            closure()
        } else {
            DispatchQueue.main.async {
                closure()
            }
        }
    }
}

extension AppDelegate: WalletConnectDelegate {
    func failedToConnect() {
        onMainThread { [unowned self] in
            
        }
    }

    func didConnect() {
        onMainThread { [unowned self] in
            
        }
    }

    func didDisconnect() {
        onMainThread { [unowned self] in
            
        }
    }
}
