import UIKit
import Flutter
import flutter_local_notifications
import flutter_downloader

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FlutterLocalNotificationsPlugin.setPluginRegistrantCallback { (registry) in

                    GeneratedPluginRegistrant.register(with: registry)

                }

       

                if #available(iOS 10.0, *) {

                  UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate

                }
    GeneratedPluginRegistrant.register(with: self)
      FlutterDownloaderPlugin.setPluginRegistrantCallback({ registry in
          FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "vn.hunghd.flutter_downloader")!)
          GeneratedPluginRegistrant.register(with: registry)
      })
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    

}
