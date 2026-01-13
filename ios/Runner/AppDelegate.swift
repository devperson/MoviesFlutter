import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate
{
  override func application(_ application: UIApplication,
                            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
  {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let dataChannel = FlutterMethodChannel(name: "nativeBridging/Swift", binaryMessenger: controller.binaryMessenger)
     dataChannel.setMethodCallHandler(
     { (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

          // Check for the specific method name defined in Dart
          if (call.method == "passValue")
          {
            if let args = call.arguments as? [String: Any],
               let myValue = args["logPath"] as? String
            {
                // Use your value here (e.g., store in a variable or use for Sentry init)
                print("Received value from Flutter: \(myValue)")
                result("Successfully handled method call from swift side") // Return result to Flutter
            }
            else
            {
                result(FlutterError(code: "UNAVAILABLE", message: "logPath Value not found", details: nil))
            }
          }
          else
          {
            result(FlutterMethodNotImplemented)
          }
        })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
