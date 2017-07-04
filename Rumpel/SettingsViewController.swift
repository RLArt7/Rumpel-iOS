//
//  SettingsViewController.swift
//  Rumpel
//
//  Created by Harel Avikasis on 04/07/2017.
//  Copyright © 2017 HarelAvikasis. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    @IBOutlet var notificationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
    }
    
    @IBAction func setNotificationsOnOff(_ sender: UISwitch)
    {
        UserDefaults.standard.set(sender.isOn , forKey: kPushNotificationsIsOn)
        
        if sender.isOn == false
        {
            //unregister from firebase messaging
            InstanceID.instanceID().deleteID(handler: { (error) in
                
            })
        }
        else
        {
            //register to firebase messaging
            InstanceID.instanceID().token()
        }
    }
    @IBAction func logOut(_ sender: UIButton)
    {
        LoginManager.manager.logOut { (bool) in
            ContactsManager.manager.contacts.removeAll()
            self.parent?.dismiss(animated: false, completion: {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.returnToLoginPage()
            })
        }
    }

}
