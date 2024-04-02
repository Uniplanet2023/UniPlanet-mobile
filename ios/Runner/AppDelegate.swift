import UIKit
import Flutter
import FirebaseCore

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
      // Set this AppDelegate as the delegate for UNUserNotificationCenter
       UNUserNotificationCenter.current().delegate = self

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    // This method will be called when a notification is about to be presented while the app is in the foreground.
    override func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      // If you don't want to show any notification banner, alert, sound or badge when the app is open, call the completionHandler with an empty array as argument.
      completionHandler([])
    }
}
