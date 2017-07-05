//
//  SettingsViewController.swift
//  Rumpel
//
//  Created by Harel Avikasis on 04/07/2017.
//  Copyright © 2017 HarelAvikasis. All rights reserved.
//

import UIKit
import Firebase
import Photos

enum PickerPermissionStatus{
    case notDetermined
    case authorized
    case needPermission
    init(phStatus: PHAuthorizationStatus) {
        switch phStatus {
        case .authorized:
            self = .authorized
        case .denied, .notDetermined, .restricted:
            self = .notDetermined
        }
    }
    
    init(avStatus: AVAuthorizationStatus){
        switch avStatus {
        case .authorized:
            self = .authorized
        case .denied, .notDetermined, .restricted:
            self = .notDetermined
        }
    }
}

let cameraPermissionAlreadyAsked = "cameraPermissionAlreadyAsked"
let albumPermissionAlreadyAsked = "albumPermissionAlreadyAsked"

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet var notificationSwitch: UISwitch!
    @IBOutlet var imageView: UIImageView!
    let imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.layer.masksToBounds = true
        imagePicker.delegate = self
        
        imageView.image = RumpelFileManager.manager.loadImgae() ?? #imageLiteral(resourceName: "defaultBackground")
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
    @IBAction func changeImageTpped(_ sender: Any)
    {
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
// MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFill
            imageView.image = pickedImage
            RumpelFileManager.manager.saveFile(file: pickedImage)
        } else{
            print("Something went wrong")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
}
