//
//  ContactsViewModel.swift
//  Rumpel
//
//  Created by Harel Avikasis on 29/06/2017.
//  Copyright © 2017 HarelAvikasis. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import Firebase

class ContactsViewModel
{
    func numberOfContacts()->Int
    {
        return ContactsManager.manager.contacts.count
    }
    func getContactForIndex(index: Int)->Contact?
    {
        if index >= 0 || index < numberOfContacts()
        {
            return ContactsManager.manager.contacts[index]
        }
        return nil
    }
    func fetchContacts(completionBlock:@escaping ((_ success:Bool)->Void))
    {
        let cerdential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        FBSDKGraphRequest(graphPath: "me/friends", parameters: ["fields" : "name,email"/*,picture.width(512).height(512)"*/]).start(completionHandler: { (connection, resultObj, error) in
            Auth.auth().signIn(with: cerdential, completion: { (user, error) in
                if error != nil{
                    completionBlock(false)
                }else{
                    
                    //let name = (resultObj as? [String: Any])?["name"] as? String
                    if let data = (((resultObj as? [String: Any])?["data"])) as? [[String:Any]]
                    {
                        ContactsManager.manager.fetchContacts(withDict: data)
                    }
                    FirebaseManager.manager.createUser(completion: { (data, error) in
                        if error != nil
                        {
                            print("error saving the user")
                        }
                    })
                    completionBlock(true)
                }
            })
        })

    }
    
}
