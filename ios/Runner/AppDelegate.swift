import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if let apiKey = dartDefineValue("GOOGLE_MAPS_API_KEY"), !apiKey.isEmpty {
      GMSServices.provideAPIKey(apiKey)
    } else {
      #if DEBUG
      fatalError("GOOGLE_MAPS_API_KEY is required for iOS Google Maps. Run Flutter with --dart-define-from-file=env/local.json or pass --dart-define=GOOGLE_MAPS_API_KEY=...")
      #else
      NSLog("GOOGLE_MAPS_API_KEY is missing. Google Maps will not render correctly.")
      #endif
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
  }

  private func dartDefineValue(_ name: String) -> String? {
    guard let encodedDefines = Bundle.main.object(forInfoDictionaryKey: "DART_DEFINES") as? String else {
      return nil
    }

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

    return nil
  }
}
