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
        let orb = (UIApplication.shared.delegate as! AppDelegate).orb
        orb.onReady {
            orb.connect(
                options: OrbConnectionOptions(
                    gridUrl: self.gridUrl,
                    appId: self.appId,
                    integrationId: self.integrationId,
                    pageContext: self.pageContext
                ),
                result: { result in
                    print("Connect result: \(String(describing: result))")
                })
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
