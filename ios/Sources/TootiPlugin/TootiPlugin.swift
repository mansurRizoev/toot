import Foundation
import Capacitor
import UIKit
import SwiftUI
import SwiftQRScanner
/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(TootiPlugin)
public class TootiPlugin: CAPPlugin, CAPBridgedPlugin,QRScannerCodeDelegate {
    public let identifier = "TootiPlugin"
    public let jsName = "Tooti"
    public let pluginMethods: [CAPPluginMethod] = [
        CAPPluginMethod(name: "echo", returnType: CAPPluginReturnPromise)
    ]
    private let implementation = Tooti()

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }

    var window: UIWindow?
  
    var commId: CDVInvokedUrlCommand?;
   
    @objc(qrRun:) func qrRun(command: CDVInvokedUrlCommand){
    
    commId = command

    let scanner = QRCodeScannerController()
    let msg  = command.arguments[0] as? String ?? ""
    scanner.delegate = self
    scanner.loc = msg
    self.viewController?.present(
          scanner,
          animated: true,
          completion: nil
        )
    }
    
    
    func qrScanner(_ controller: UIViewController, scanDidComplete result: String) {
        var pluginResult = CDVPluginResult(status: CDVCommandStatus_OK,messageAs: result);
        self.commandDelegate!.send(pluginResult, callbackId: commId?.callbackId);
    }
    
    func qrScannerDidFail(_ controller: UIViewController, error: String) {
        var pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: error);
        self.commandDelegate!.send(pluginResult, callbackId: commId?.callbackId);
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        var pluginResult = CDVPluginResult (status: CDVCommandStatus_ERROR, messageAs: "cancel scanner");
        self.commandDelegate!.send(pluginResult, callbackId: commId?.callbackId);
    }
    
}



