import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        window.rootViewController = storyboard.instantiateViewController(withIdentifier: "NavigationController")
        
        // Handle Meya remote notification
        if let response = connectionOptions.notificationResponse {
            let userInfo = response.notification.request.content.userInfo
            
            // Handle Meya local notification action
            if let _ = userInfo["meya_integration_id"] {
                let navigationController = window.rootViewController as! UINavigationController
                let viewController = navigationController.topViewController
                if viewController is LaunchViewController {
                    // Note, the app will crash if the app is installed in debug mode and
                    // the host computer is not connected. This is due to a current
                    // limitation between Flutter and new OS 14 debug API changes.
                    // https://flutter.dev/docs/development/ios-14#launching-debug-flutter-without-a-host-computer
                    let launchViewController = viewController as! LaunchViewController
                    launchViewController.presentOrbFullscreen()
                }
            }
        }
        
        self.window = window
        window.makeKeyAndVisible()
    }
}

