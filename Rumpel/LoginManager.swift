//
//  LoginManager.swift
//  Rumpel
//
//  Created by Harel Avikasis on 25/06/2017.
//  Copyright © 2017 HarelAvikasis. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FBSDKCoreKit
import FBSDKLoginKit

import Foundation

class LoginManager: NSObject {

    static let manager = LoginManager()

    func currnetUser()->User?{
        return Auth.auth().currentUser
    }

    func loginWithFacebook(viewController:UIViewController,needShowLoaderBlock:@escaping (()->Void), completionBlock:@escaping ((_ success:Bool, _ canceled:Bool)->Void)){
        let login = FBSDKLoginManager()
        login.logIn(withReadPermissions: ["public_profile", "email","user_friends"], from: viewController) { (result, error) in
            if error != nil{
                completionBlock(false, false)
                print("Error while login FB")
            }
            if result != nil{
                if result!.isCancelled{
                    completionBlock(false, true)
                }else{
                    needShowLoaderBlock()
                    let cerdential =   FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                    FBSDKGraphRequest(graphPath: "me/friends", parameters: ["fields" : "name,email"/*,picture.width(512).height(512)"*/]).start(completionHandler: { (connection, resultObj, error) in
                        Auth.auth().signIn(with: cerdential, completion: { (user, error) in
                            if error != nil{
                                completionBlock(false, false)
                            }else{
                                
                                //let name = (resultObj as? [String: Any])?["name"] as? String
                                if let data = (((resultObj as? [String: Any])?["data"])) as? [[String:Any]]
                                {
                                    ContactsManager.manager.fetchContacts(withDict: data)
                                }
                                UserManager.manager.setUser(withName: user?.displayName ?? "", userToken: user?.refreshToken ?? "", facebookId: FBSDKAccessToken.current().userID ?? "", userId: user?.uid ?? "")
                                completionBlock(true, false)
                            }
                        })
                    })
                }
            }
        }
    }

    func isUserLoggedIn(completioBlock:@escaping (_ loggedin:Bool)->Void){
        if let _ = Auth.auth().currentUser{
            completioBlock(true)
        }else{
            completioBlock(false)
        }
    }

    func logOut(successBlock:(_ success:Bool)->Void){
        do{
            try Auth.auth().signOut()
            successBlock(true)
            print("Loggedf out")
            FBSDKLoginManager().logOut()
            
        }catch{
            successBlock(false)
            print("error while logged out")
        }
    }
}
