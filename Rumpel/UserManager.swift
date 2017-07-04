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
    
    var name : String?
    var userToken : String?
    {
        didSet{
            UserDefaults.standard.set(self.userToken, forKey: UserFields.userToken.rawValue)

        }
    }
    var facebookId : String?
    var userId: String?
    var userPhotoUrl : URL?
    var chatsIdMap = [String:String]()
    
    func setChatIdMap(snapshot : DataSnapshot)
    {
        if let value = snapshot.value as? String {
            chatsIdMap[snapshot.key] = value
        }
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
