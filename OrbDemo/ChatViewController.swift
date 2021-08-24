import UIKit
import orb

class ChatViewController: UIViewController {
    
    var gridUrl: String?
    var appId: String?
    var integrationId: String?
    var pageContext: [String: Any?]? = [:]
    
    @IBOutlet weak var chatView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Orb"
        
        if
            let gridUrl = gridUrl,
            let appId = appId,
            let integrationId = integrationId,
            let pageContext = pageContext
        {
            createOrbViewController(
                gridUrl: gridUrl, appId: appId, integrationId: integrationId, pageContext: pageContext
            )
        } else {
            let alert = UIAlertController(
                title: "Could not load Orb",
                message: "The Orb connection parameters were not initialized properly.",
                preferredStyle: UIAlertController.Style.alert
            )
            alert.addAction(
                UIAlertAction(title: "Ok", style: UIAlertAction.Style.default) {[unowned self] alertAction in
                    self.navigationController?.popViewController(animated: true)
                }
            )
            self.present(alert, animated: true, completion: nil)
        }
    }

    func createOrbViewController(gridUrl: String, appId: String, integrationId: String, pageContext: [String: Any?]) {
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let orb = appDelegate.orb
        
        let connectionOptions = OrbConnectionOptions(
            gridUrl: gridUrl,
            appId: appId,
            integrationId: integrationId,
            pageContext: pageContext,
            enableCloseButton: false
        )
//        let config = OrbConfig(
//            theme: OrbTheme(
//                brandColor: "#00d9d9"
//            ),
//            composer: OrbComposer(
//                placeholderText: "Type your message",
//                collapsePlaceholderText: "Message",
//                fileButtonText: "File",
//                fileSendText: "Send ",
//                imageButtonText: "Photo",
//                cameraButtonText: "Camera",
//                galleryButtonText: "Gallery"
//            ),
//            splash: OrbSplash(
//                readyText: "Orb is now ready"
//            )
//        )
        if !orb.ready {
            orb.onReady { [unowned orb] in
//                orb.configure(config: config)
                orb.connect(options: connectionOptions)
            }
        } else {
//            orb.configure(config: config)
            orb.connect(options: connectionOptions)
        }
        orb.onConnnected {
            print("Orb connected")
        }
        orb.onDisconnected {
            print("Orb disconnected")
        }
        let orbViewController = orb.viewController()
        
        addChild(orbViewController)
        orbViewController.didMove(toParent: self)
        orbViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        let views: [String: Any] = ["orbView": orbViewController.view!]
        
        view.addSubview(orbViewController.view)
        view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-0-[orbView]-0-|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                metrics: nil,
                views: views
            )
        )
        view.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[orbView]-0-|",
                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                metrics: nil,
                views: views
            )
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let orb = (UIApplication.shared.delegate as! AppDelegate).orb
        orb.disconnect()
    }
}
