import UIKit
import orb
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    lazy var orb = Orb()
    var deviceToken: String?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        orb.initialize()
        registerForPushNotifications()
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable: Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        // Meya notifications always contain the "meya_integration_id" key to identify which Orb Mobile integration
        // in you app sent the notification.
        if
            let aps = userInfo["aps"] as? [String: AnyObject],
            let meyaIntegrationId = userInfo["meya_integration_id"] as? String
        {
            // Handle Meya notifications
            print(meyaIntegrationId)
            print(aps)
            // Uncomment the following to open the ChatViewController when a Meya notification arrives
    //        let navigationController = UIApplication.shared.windows.first!.rootViewController as! UINavigationController
    //        if !(navigationController.topViewController is ChatViewController) {
    //            let chatViewController = ChatViewController()
    //            chatViewController.gridUrl = "https://grid.meya.ai"
    //            chatViewController.appId = "YOUR MEYA APP ID"
    //            chatViewController.integrationId = "integration.orb.mobile"
    //            navigationController.pushViewController(chatViewController, animated: true)
    //        }
        } else {
            completionHandler(.failed)
            return
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data)}
        let token = tokenParts.joined()
        self.deviceToken = token
        orb.deviceToken = token
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            print("Permission granted: \(granted)")
            guard granted else { return }
            self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

