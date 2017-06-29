//
//  ContactCell.swift
//  Rumpel
//
//  Created by Harel Avikasis on 29/06/2017.
//  Copyright © 2017 HarelAvikasis. All rights reserved.
//

import UIKit

class ContactCell: UITableViewCell {

    @IBOutlet var contactNameLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    var contact : Contact?
    
    func configureCell(withContact contact: Contact)
    {
        self.contact = contact
        self.contactNameLabel.text = contact.name
    }

}
