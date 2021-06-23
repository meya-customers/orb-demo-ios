import UIKit
import orb

class ChatViewController: UIViewController {
    
    var gridUrl: String = "https://grid.meya.ai"
    var appId: String = "app-73c6d31d4f544a72941e21fb518b5737"
    var integrationId: String = "integration.orb"
    var pageContext: [String: Any?] = [:]
    
    @IBOutlet weak var chatView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Orb"
        createOrbViewController()
    }

    func createOrbViewController() {
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        let orb = appDelegate.orb
        
        let connectionOptions = OrbConnectionOptions(
            gridUrl: self.gridUrl,
            appId: self.appId,
            integrationId: self.integrationId,
            pageContext: self.pageContext
        )
        if !orb.ready {
            orb.onReady { [unowned orb] in
                orb.connect(options: connectionOptions)
            }
        } else {
            orb.connect(options: connectionOptions)
        }
        orb.onConnnected {
            print("Orb connected")
        }
        orb.onDisconnected {
            print("Orb disconnected")
        }
        orb.onClose { [unowned self] in
            self.navigationController?.popViewController(animated: true)
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
