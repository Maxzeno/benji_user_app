import UIKit
import Flutter
import shared_preferences_foundation
import GoogleMaps
import FirebaseCore
import flutter_local_notifications

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseApp.configure()
      GeneratedPluginRegistrant.register(with: self)

      // Google Maps API Key
      GMSServices.provideAPIKey("AIzaSyABRQIbm3Dl4x8TKq_6Ht3PaNllH_8yuwo")

      // This function registers the desired plugins to be used within a notification background action
      SwiftAwesomeNotificationsPlugin.setPluginRegistrantCallback { registry in
          SharedPreferencesPlugin.register(
            with: registry.registrar(forPlugin: "io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin")!)
      }

      // push notification stuff
      FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in
          GeneratedPluginRegistrant.register(with: registry)
      }

      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
      }

      // GeneratedPluginRegistrant.register(with: self)

      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
