import UIKit
import Flutter
import orb

class LaunchViewController: UIViewController {
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
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
        let orb = (UIApplication.shared.delegate as! AppDelegate).orb
        let platformVersion = "iOS " + UIDevice.current.systemVersion
        
        orb.connect(
            options: OrbConnectionOptions(
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
            ),
            result: { result in
                print("Connect result: \(String(describing: result))")
            })
        let orbViewController = orb.viewController()
        orbViewController.modalPresentationStyle = .fullScreen
        orbViewController.modalTransitionStyle = .crossDissolve
        present(orbViewController, animated: true, completion: nil)
    }
}

extension LaunchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
