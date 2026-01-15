import Flutter
import UIKit
import Sentry


@main
@objc class AppDelegate: FlutterAppDelegate
{
  override func application(_ application: UIApplication,
                            didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
  {
      
    StartSentry();

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let dataChannel = FlutterMethodChannel(name: "nativeBridging/Swift", binaryMessenger: controller.binaryMessenger)
     dataChannel.setMethodCallHandler(
     {[weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in

         print("Received request from Flutter: call.method: \(call.method)")
          // Check for the specific method name defined in Dart
          if (call.method == "passValue")
          {
            if let args = call.arguments as? [String: Any]
            {
                guard self != nil else
                {
                    print("InitSentryAttachment(): the self instance is null thus skipping")
                    return
                }
                
                if let myValue = args["otherMessages"] as? String
                {
                    //you can add some other required setup
                    result("Successfully executed native operation")
                }
                else if let shouldThrowError = args["throwError"] as? Bool
                {
//                    let x: String? = nil;
//                    let y = x!;//crash app
                    result("Successfully executed native operation")
                }
                else
                {
                    result(FlutterError(code: "UNAVAILABLE", message: "can not find required argument in passValue method call", details: nil))
                }
            }
            else
            {
                result(FlutterError(code: "UNAVAILABLE", message: "passValue method call should contain arguments", details: nil))
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

    func StartSentry()
    {
        SentrySDK.start
        { options in
            options.dsn = "https://6f765635535a1c1d81ecd9b6c288b836@o4507288977080320.ingest.de.sentry.io/4510697340338256"
            options.beforeSend = { event in
                // Check if any exception in the event was unhandled
                let isUnhandled = event.exceptions?.contains { exception in
                    exception.mechanism?.handled?.boolValue == false
                } ?? false

                if isUnhandled
                {
                    //since Sentry somehow doesn't send the attachment(Applog) for native crash
                    //we can send app log to our server
                    // Logic to send appLog to server
                    print("Sentry going to send the unhandled error.")
                }

                return event
            }
        }
    }

   
}
