import Foundation
import Capacitor
import AVFoundation
import UIKit

@objc(TootiPlugin)
public class TootiPlugin: CAPPlugin {
    private var call: CAPPluginCall?
    private var qrViewController: QRViewController?

    @objc func scanQR(_ call: CAPPluginCall) {
        self.call = call
        DispatchQueue.main.async {
            self.qrViewController = QRViewController()
            self.qrViewController?.delegate = self
            self.bridge?.viewController?.present(self.qrViewController!, animated: true)
        }
    }
}

// MARK: - QRViewControllerDelegate

extension TootiPlugin: QRViewControllerDelegate {
    func didScanQRCode(value: String) {
        call?.resolve([
            "value": value
        ])
        qrViewController?.dismiss(animated: true)
        qrViewController = nil
    }

    func didCancelQRCode() {
        call?.reject("cancelled")
        qrViewController?.dismiss(animated: true)
        qrViewController = nil
    }
}

// MARK: - QRViewController

protocol QRViewControllerDelegate: AnyObject {
    func didScanQRCode(value: String)
    func didCancelQRCode()
}

class QRViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    weak var delegate: QRViewControllerDelegate?
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupCaptureSession()

        // Кнопка "Закрыть"
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("Закрыть", for: .normal)
        closeButton.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        closeButton.frame = CGRect(x: 20, y: 40, width: 100, height: 40)
        view.addSubview(closeButton)
    }

    func setupCaptureSession() {
        captureSession = AVCaptureSession()
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let videoInput = try? AVCaptureDeviceInput(device: videoCaptureDevice) else { return }
        if (captureSession?.canAddInput(videoInput) == true) {
            captureSession?.addInput(videoInput)
        } else {
            delegate?.didCancelQRCode()
            return
        }

        let metadataOutput = AVCaptureMetadataOutput()
        if (captureSession?.canAddOutput(metadataOutput) == true) {
            captureSession?.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            delegate?.didCancelQRCode()
            return
        }

        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        previewLayer?.frame = view.layer.bounds
        previewLayer?.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer!)
        captureSession?.startRunning()
    }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        captureSession?.stopRunning()
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue {
            delegate?.didScanQRCode(value: stringValue)
        } else {
            delegate?.didCancelQRCode()
        }
    }

    @objc func didTapClose() {
        captureSession?.stopRunning()
        delegate?.didCancelQRCode()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        captureSession?.stopRunning()
    }
}



/**
import Foundation
import Capacitor
import UIKit
import SwiftUI
import SwiftQRScanner
*/
/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
/**
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

*/

