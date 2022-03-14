import Flutter
import UIKit
import SocketIO


public class SwiftAdharaSocketIoPlugin: NSObject, FlutterPlugin {
    
    var instances: [AdharaSocket];
    let registrar: FlutterPluginRegistrar;
    
    init(_ _registrar: FlutterPluginRegistrar){
        registrar = _registrar
        instances = [AdharaSocket]()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "adhara_socket_io", binaryMessenger: registrar.messenger())
        let instance = SwiftAdharaSocketIoPlugin(registrar)
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        var adharaSocket:AdharaSocket
        let arguments = call.arguments as! [String: AnyObject]
        
        switch (call.method) {
            case "newInstance":
                let newIndex: Int = instances.count
                let config:AdharaSocketIOClientConfig
                    = AdharaSocketIOClientConfig(newIndex, uri: arguments["uri"] as! String)
                if let query: [String:String] = arguments["query"] as? [String:String]{
                    config.query = query
                }
                if let enableLogging: Bool = arguments["enableLogging"] as? Bool {
                    config.enableLogging = enableLogging
                }
                instances.append(AdharaSocket.getInstance(registrar, config))
                result(newIndex)
            case "clearInstance":
                if(arguments["id"] == nil){
                    result(FlutterError(code: "400", message: "Invalid instance identifier provided", details: nil))
                }else{
                    let socketIndex = arguments["id"] as! Int
                    if (instances.count > socketIndex) {
                        adharaSocket = instances[socketIndex];
                        instances = instances.filter({ (_ socket: AdharaSocket) -> Bool in
                            socket != adharaSocket;
                        })
                        adharaSocket.socket.disconnect()
                    }
                    result(nil)
                }
            default:
                result(FlutterError(code: "404", message: "No such method", details: nil))
        }
    }
    
}
