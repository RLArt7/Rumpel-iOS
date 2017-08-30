//
//  ContactsManager.swift
//  Rumpel
//
//  Created by Harel Avikasis on 29/06/2017.
//  Copyright © 2017 HarelAvikasis. All rights reserved.
//

import Foundation

class ContactsManager
{
    static let manager = ContactsManager()
    
    var contacts = [Contact]()
    
    func fetchContacts(withDict data: [[String :Any]])
    {
            data.forEach { (contactJson) in
            let contact = Contact()
            if let url = ((contactJson["picture"] as? [String:Any])?["data"] as? [String:Any])?["url"] as? String
            {
                contact.imageUrl = url
            }
            if let name = contactJson["name"] as? String , let id = contactJson["id"] as? String
            {
                contact.id = id
                contact.name = name
                contact.hasNewQuestion = UserDefaults.standard.bool(forKey: id)
                contact.lastChange = UserDefaults.standard.object(forKey: "lastChange_\(id)") as? Date ?? Date(timeIntervalSinceReferenceDate: -123456789.0)
                contacts.append(contact)
            }
        }
        contacts.sort{$0.lastChange! > $1.lastChange!}
        UserManager.manager.setChatsArray()
    }
    
    func updateContactNewMessageById(id:String ,hasNewQuestion : Bool = true , withBadge : Bool ,didChange : Bool = true)
    {
        contacts.forEach { (contact) in
            if contact.id == id
            {
                if withBadge
                {
                    contact.hasNewQuestion = hasNewQuestion
                }
                if didChange
                {
                    let date = Date()
                    contact.lastChange = date
                    UserDefaults.standard.set(date, forKey: "lastChange_\(id)")
                }
            }
        }
        contacts.sort{$0.lastChange! > $1.lastChange!}
//        contacts.sort{$0.hasNewQuestion && !$1.hasNewQuestion}

        if didChange
        {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newPushMessageArrive"), object: nil)
        }
    }
}
