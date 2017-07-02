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
    var ref: DatabaseReference!
    func fetchUserChatHistoryMap(completion:@escaping ((_ success:Bool)->Void))
    {
        guard let fbId = UserManager.manager.facebookId else {
            return
        }
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
    
    func fetchUserConversation(withchatId chatId:String? , endPoint: String ,completion:@escaping ((_ success:Bool, _ chat:Chat?)->Void))
    {
        
        if let chatId = chatId
        {
            ref = Database.database().reference().child("chats").child(chatId)
            
            ref.observe(.value, with: { (snapshot) in
                if !snapshot.exists() {
                    completion(false,nil)
                    return
                }
                let chat = Chat(snapshot: snapshot)
                completion(true,chat)
            })
        }
        else
        {
            let key = Database.database().reference().child("chats").childByAutoId().key
            self.ref = Database.database().reference().child("chats").child(key)
            let chat = Chat(withChatId: key, endPoint: endPoint)
            let chatDict = chat.getObjectAsDictionary()
            
            self.ref.updateChildValues(chatDict, withCompletionBlock: { (error, reference) in
                if error != nil {
                    print ("error \(String(describing: error))")
                }
                else
                {
                    self.ref = Database.database().reference().child("users").child(UserManager.manager.facebookId!)
                    
                    self.ref.child("chatIdMap").updateChildValues([endPoint:chat.id])
                    
                    self.ref = Database.database().reference().child("users").child(endPoint)
                    
                    self.ref.child("chatIdMap").updateChildValues([UserManager.manager.facebookId!:chat.id])
                }
            })
            completion(true,chat)
        }
    }
    
    func addNewQuestion(withQuestion question:Question,completion:@escaping (( _ questionId:String?)->Void))
    {
        let key = Database.database().reference().child("questions").childByAutoId().key
        self.ref = Database.database().reference().child("questions").child(key)
        
        self.ref.updateChildValues(question.getObjectAsDictionary(), withCompletionBlock: { (error, reference) in
            if error != nil {
                print ("error \(String(describing: error))")
            }
            else
            {
               completion(key)
            }
        })
    }
    
    func updateChat(withChat chat:Chat)
    {
        self.ref = Database.database().reference().child("chats").child(chat.id)
    
        self.ref.updateChildValues(chat.getObjectAsDictionary())
    }
    
    func createUser(completion:@escaping (_ userSnapshot:DataSnapshot?,_ error: Error?)->Void)
    {
        guard let fbId = UserManager.manager.facebookId else {
            return
        }
        ref = Database.database().reference().child("users").child(fbId)

        if LoginManager.manager.currnetUser() != nil
        {
            ref.observeSingleEvent(of: .value, with: {(snapshot) in
                var userDict = [String: Any]()
                if let dict = snapshot.value as? [String: Any] {//Exisiting user just update local image if needed
                    userDict = dict
                }else{//Is new user
                    userDict["userId"] = UserManager.manager.userId ?? ""
                    userDict["userName"] = UserManager.manager.name ?? ""
                    userDict["facebookId"] = UserManager.manager.facebookId ?? ""
                    userDict["userToken"] = UserManager.manager.userToken ?? ""
                }
                
                self.ref.updateChildValues(userDict, withCompletionBlock: { (error, reference) in
                    if error != nil {
                        print ("error \(String(describing: error))")
                        completion(nil,error)
                    }
                    
                    self.ref.observeSingleEvent(of: .value, with: {(snapshot) in
                        completion(snapshot,nil)
                    })
                })
            })
            {(error) in
                completion(nil,error)
            }
        }
    }

}
