import Flutter
import UIKit
import GoogleMaps
import FirebaseCore
import FirebaseMessaging
import UserNotifications

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate, MessagingDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()

    UNUserNotificationCenter.current().delegate = self
    Messaging.messaging().delegate = self

    UNUserNotificationCenter.current().requestAuthorization(
      options: [.alert, .badge, .sound]
    ) { granted, _ in
      DispatchQueue.main.async {
        application.registerForRemoteNotifications()
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    // Google Maps SDK must be initialized BEFORE any plugin that uses it is registered.
    // This method is called before application(_:didFinishLaunchingWithOptions:), so
    // we must set the API key here to avoid the GMSServicesException crash.
    guard let apiKey = dartDefineValue("GOOGLE_MAPS_API_KEY"), !apiKey.isEmpty else {
      #if DEBUG
      fatalError("GOOGLE_MAPS_API_KEY is missing. Run Flutter with --dart-define-from-file=env/local.json")
      #else
      NSLog("GOOGLE_MAPS_API_KEY is missing. Google Maps will not render correctly.")
      GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
      return
      #endif
    }
    GMSServices.provideAPIKey(apiKey)
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  private func dartDefineValue(_ name: String) -> String? {
    if let encodedDefines = Bundle.main.object(forInfoDictionaryKey: "DART_DEFINES") as? String,
       !encodedDefines.isEmpty {
      for encodedDefine in encodedDefines.split(separator: ",") {
        guard
          let data = Data(base64Encoded: String(encodedDefine)),
          let define = String(data: data, encoding: .utf8)
        else {
          continue
        }

        let parts = define.split(separator: "=", maxSplits: 1).map(String.init)
        if parts.count == 2 && parts[0] == name {
          return parts[1]
        }
      }
    }

    // Fallback: read direct Info.plist key (set via xcconfig for Xcode runs)
    return Bundle.main.object(forInfoDictionaryKey: name) as? String
  }
}
