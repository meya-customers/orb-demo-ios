import UIKit
import Flutter
import orb

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.addTarget(self, action: #selector(showOrb), for: .touchUpInside)
        button.setTitle("Show Orb", for: UIControl.State.normal)
        button.frame = CGRect(x: 80.0, y: 210.0, width: 160.0, height: 40.0)
        button.backgroundColor = UIColor.blue
        self.view.addSubview(button)
        
    }
    
    @IBAction func showOrb(sender: UIButton) {
        let orb = (UIApplication.shared.delegate as! AppDelegate).orb
        let platformVersion = "iOS " + UIDevice.current.systemVersion
        orb.connect(
            options: OrbConnectionOptions(
                gridUrl: "https://grid.meya.ai",
                appId: "app-73c6d31d4f544a72941e21fb518b5737",
                integrationId: "integration.orb",
                pageContext: [
                    "platform_version": platformVersion,
                    "a": 1234,
                    "data": [
                        "key1": "value1",
                        "key2": 123123.3,
                        "bool": true
                    ]
                ] as [String: Any?]
            ),
            result: { result in
                print("Connect result: \(String(describing: result))")
            })
        let viewController = orb.viewController()
        present(viewController, animated: true, completion: nil)
    }
}

