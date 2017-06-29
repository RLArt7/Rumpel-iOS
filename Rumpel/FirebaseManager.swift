//
//  FirebaseManager.swift
//  Rumpel
//
//  Created by Harel Avikasis on 29/06/2017.
//  Copyright © 2017 HarelAvikasis. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebaseManager
{
    static let manager = FirebaseManager()
    
    func fetchUserChatHistoryMap(completion:@escaping ((_ success:Bool)->Void))
    {
        guard let fbId = UserManager.manager.facebookId else {
            return
        }
        var ref: DatabaseReference!
        ref = Database.database().reference().child("users").child(fbId).child("chatIdMap")
        
        ref.observe(.value, with: { (snapshot) in
            if !snapshot.exists() { return }
            
            
            if snapshot.children.allObjects.count > 0{
                for snapObject in snapshot.children.allObjects{
                    print (snapObject)
                    UserManager.manager.setChatIdMap(snapshot: snapObject as! DataSnapshot)
                }
            }else{
                completion(false)
            }
            completion(true)
        })
    }
    
    func fetchUserConversation(withchatId chatId:String , endPoint: String ,completion:@escaping ((_ success:Bool)->Void))
    {
        guard let fbId = UserManager.manager.facebookId else {
            return
        }
        var ref: DatabaseReference!
//        ref = Database.database().reference().child("users").child(fbId).child("chatIdMap")
//        
//        ref.observe(.value, with: { (snapshot) in
//            if !snapshot.exists() { return }
//            
//            
//            if snapshot.children.allObjects.count > 0{
//                for snapObject in snapshot.children.allObjects{
//                    print (snapObject)
//                    UserManager.manager.setChatIdMap(snapshot: snapObject as! DataSnapshot)
//                }
//            }else{
//                completion(false)
//            }
//            completion(true)
//        })
    }

}
