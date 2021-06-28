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
            if
                let alert = aps["alert"],
                let title = alert["title"],
                let body = alert["body"]
            {
                sendNotification(title: title as! String, body: body as! String)
            }
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
    
    func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.categoryIdentifier = "MEYA_ORB"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)
        let request = UNNotificationRequest(
            identifier: "MEYA_ORB",
            content: content,
            trigger: trigger
        )

        let center =  UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if error != nil {
                print("Notification error: \(String(describing: error))")
            }
        }
    }
}
