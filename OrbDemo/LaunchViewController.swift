import UIKit
import Flutter
import orb

class LaunchViewController: UIViewController, UNUserNotificationCenterDelegate {
    var orb: Orb?
    
    @IBOutlet weak var gridUrlField: UITextField!
    @IBOutlet weak var appIdField: UITextField!
    @IBOutlet weak var integrationIdField: UITextField!
    @IBOutlet weak var logoView: UIImageView!
    @IBOutlet weak var launchOrbButton: UIButton!
    @IBOutlet weak var launchModalButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Orb Demo"
        
        gridUrlField.delegate = self
        appIdField.delegate = self
        integrationIdField.delegate = self
        
        logoView.image = UIImage(named: "Logo")
        
        launchOrbButton.layer.cornerRadius = 8
        launchOrbButton.layer.masksToBounds = true
        
        launchModalButton.layer.cornerRadius = 8
        launchModalButton.layer.masksToBounds = true
        
        UNUserNotificationCenter.current().delegate = self
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        completionHandler([.badge, .sound, .alert])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo
        
        // Handle Meya local notification action
        if let _ = userInfo["meya_integration_id"] {
            presentOrbFullscreen()
        }
        
        completionHandler()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ChatViewController {
            let chatViewController = segue.destination as? ChatViewController
            let platformVersion = "iOS " + UIDevice.current.systemVersion
            if
                let gridUrlField = gridUrlField,
                let appIdField = appIdField,
                let integrationIdField = integrationIdField
            {
                if
                    let gridUrl = gridUrlField.text,
                    let appId = appIdField.text,
                    let integrationId = integrationIdField.text
                {
                    chatViewController?.gridUrl = gridUrl
                    chatViewController?.appId = appId
                    chatViewController?.integrationId = integrationId
                }
            }
            chatViewController?.pageContext = [
                "platform_version": platformVersion,
                "a": 1234,
                "data": [
                    "key1": "value1",
                    "key2": 123123.3,
                    "bool": true
                ]
            ] as [String: Any?]
        }
    }
    
    @IBAction func launchOrbModal(_ sender: Any) {
        presentOrbFullscreen()
    }
    
    public func presentOrbFullscreen() {
        guard orb == nil else { return }

        orb = Orb()
        if let orb = orb {
            orb.initialize()
            orb.deviceToken = (UIApplication.shared.delegate as! AppDelegate).deviceToken
            print("Device token: \(String(describing: orb.deviceToken))")
            let platformVersion = "iOS " + UIDevice.current.systemVersion
            let connectionOptions = OrbConnectionOptions(
                gridUrl: gridUrlField.text!,
                appId: appIdField.text!,
                integrationId: integrationIdField.text!,
                pageContext: [
                    "platform_version": platformVersion,
                    "a": 1234,
                    "data": [
                        "key1": "value1",
                        "key2": 123123.3,
                        "bool": true
                    ]
                ] as [String: Any?]
            )
            let config = OrbConfig(
                theme: OrbTheme(
                    brandColor: "#00d9d9"
                ),
                composer: OrbComposer(
                    placeholderText: "Type your message",
                    collapsePlaceholderText: "Message",
                    fileButtonText: "File",
                    fileSendText: "Send ",
                    imageButtonText: "Photo",
                    cameraButtonText: "Camera",
                    galleryButtonText: "Gallery"
                ),
                splash: OrbSplash(
                    readyText: "Orb is now ready"
                ),
                mediaUpload: OrbMediaUpload(
                    all: nil,
                    image: nil,
                    file: nil
                )
            )
            if !orb.ready {
                orb.onReady { [unowned orb] in
                    orb.configure(config: config)
                    orb.connect(options: connectionOptions)
                }
            } else {
                orb.configure(config: config)
                orb.connect(options: connectionOptions)
            }
            
            let orbViewController = orb.viewController()
            orbViewController.modalPresentationStyle = .fullScreen
            orbViewController.modalTransitionStyle = .crossDissolve
            orb.onCloseUi {[unowned self, unowned orbViewController] in
                orbViewController.dismiss(animated: true, completion: nil)
                // Set to nil so that Orb get's deinitialized immediately
                self.orb = nil
            }
            present(orbViewController, animated: true, completion: nil)
        }
    }
}

extension LaunchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
