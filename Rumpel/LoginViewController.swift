//
//  LoginViewController.swift
//  Rumpel
//
//  Created by Harel Avikasis on 25/06/2017.
//  Copyright © 2017 HarelAvikasis. All rights reserved.
//

import UIKit

enum LoginStatus {
    case loggedOut
    case loading
    case loggedIn
}

class LoginViewController: UIViewController {

    var loginStatus : LoginStatus = .loading
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return true
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
    }
    private func moveToContacts(){
        if UserManager.manager.name != ""
        {
            FirebaseManager.manager.fetchUserChatHistoryMap(completion: { (Bool) in
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let navController = storyboard.instantiateViewController(withIdentifier :"navigationController") as! UINavigationController
                self.present(navController, animated: true)
            })
        }
    }
    
    @IBAction func loginAction(){
        LoginManager.manager.loginWithFacebook(viewController: self, needShowLoaderBlock: {
            self.loginStatus = .loading
            self.activityIndicator.startAnimating()
        }) { (success, canceled) in
            if canceled{
                self.activityIndicator.stopAnimating()
            }
            if success{
                self.activityIndicator.stopAnimating()
                self.loginStatus = .loggedIn
                self.moveToContacts()
            }
        }
    }

}

