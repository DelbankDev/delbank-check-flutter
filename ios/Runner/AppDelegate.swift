import Flutter
import SwiftUI
import UIKit
import delcheck_framework

enum ChannelName {
  static let capture = "delbank.sdk/antiCheat"
}

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private var eventSink: FlutterEventSink?
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      GeneratedPluginRegistrant.register(with: self)
      guard let controller = window?.rootViewController as? FlutterViewController else {

        fatalError("rootViewController is not type FlutterViewController")

      }
      let navigationController = UINavigationController(rootViewController: controller)

      navigationController.isNavigationBarHidden = true

      window?.rootViewController = navigationController

      window?.makeKeyAndVisible()
      
      let captureChannel = FlutterMethodChannel(name: ChannelName.capture,
                                                binaryMessenger: controller.binaryMessenger)

      captureChannel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          print(call.method)
               guard call.method == "startCheck" else {
                  result(FlutterMethodNotImplemented)
                 return
                }
          
        if call.method == "startCheck" {
          let arguments = call.arguments as! [String: Any]

           
            let captureViewController = DelcheckViewController(flutterResult: result)
            
            controller.navigationController?.pushViewController(captureViewController, animated: true)
                 

        }


      })
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
