//
//  UserManager.swift
//  Rumpel
//
//  Created by Harel Avikasis on 29/06/2017.
//  Copyright © 2017 HarelAvikasis. All rights reserved.
//

import Firebase
import Foundation

enum UserFields : String
{
    case name = "name"
    case userToken = "userToken"
    case facebookId = "facebookId"
    case userId = "userId"
}
class UserManager
{
    static let manager = UserManager()
    var groupExist = false
    var name : String?
    var userToken : String?
    {
        didSet{
            UserDefaults.standard.set(self.userToken, forKey: UserFields.userToken.rawValue)

        }
    }
    var facebookId : String?
    var userId: String?
    var userPhotoUrl : String = ""
    var chatsIdMap = [String:String]()
    var chats = [Chat]()
    func setChatIdMap(snapshot : DataSnapshot)
    {
        if let value = snapshot.value as? String {
            chatsIdMap[snapshot.key] = value
        }
    }
    func setChatsArray()
    {
        var dispatchGroup = DispatchGroup()
        chatsIdMap.forEach { (key,value) in
            dispatchGroup.enter()
            groupExist = true
            FirebaseManager.manager.fetchConverstion(withchatId: value, endPoint: key, completion: { (bool,chat) in
                if bool
                {
                    self.chats.append(chat!)
                    if chat!.isThereOpenQuestion && (chat!.fetchOpenQuestoin()?.senderId ?? "") != self.userId
                    {
                        ContactsManager.manager.updateContactNewMessageById(id: key, withBadge: true ,didChange: false)
                        if !self.groupExist
                        {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newPushMessageArrive"), object: nil)
                        }
                    }
                    else
                    {
                        ContactsManager.manager.updateContactNewMessageById(id: key,hasNewQuestion: false ,withBadge: true ,didChange: false)
                    }
                }
                if self.groupExist
                {
                    dispatchGroup.leave()
                }
            })
        }
        dispatchGroup.notify(queue: DispatchQueue.main, execute: {
            self.groupExist = false
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newPushMessageArrive"), object: nil)
        })
        
    }
    
    func setUser(withName name: String,userToken:String,facebookId:String,userId:String)
    {
        self.name = name
        self.facebookId = facebookId
        self.userId = userId
        self.saveUserToDefaults()
        self.userToken = userToken
    }
    
    func getDictionaryRepresentation()->[String:Any]
    {
        return  ["name": self.name ?? "",
                  "userToken":self.userToken ?? "",
                  "facebookId":self.facebookId ?? "",
                  "userId":self.userId ?? "",
                  "chatsIdMap":self.chatsIdMap]
    }
    
    func saveUserToDefaults()
    {
        let userdef = UserDefaults.standard
        userdef.set(self.name, forKey: UserFields.name.rawValue)
        userdef.set(self.userToken, forKey: UserFields.userToken.rawValue)
        userdef.set(self.facebookId, forKey: UserFields.facebookId.rawValue)
        userdef.set(self.userId, forKey: UserFields.userId.rawValue)
    }
    
    func fetchUserFromDefaults()
    {
        let userdef = UserDefaults.standard
        self.name = userdef.object(forKey:  UserFields.name.rawValue) as? String ?? ""
        self.facebookId = userdef.object(forKey:  UserFields.facebookId.rawValue) as? String ?? ""
        self.userId = userdef.object(forKey:  UserFields.userId.rawValue) as? String ?? ""
        self.userToken = userdef.object(forKey:  UserFields.userToken.rawValue) as? String ?? ""
    }
}
