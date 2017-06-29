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
            if let name = contactJson["name"] as? String , let id = contactJson["id"] as? String
            {
                contact.id = id
                contact.name = name
                contacts.append(contact)
            }
        }
    }
}
