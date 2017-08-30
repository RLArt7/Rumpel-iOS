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
    @IBOutlet var newQuestionImage: UIImageView!
    var contact : Contact?
    
    func configureCell(withContact contact: Contact)
    {
        self.contact = contact
        self.contactNameLabel.text = contact.name
        if let url = URL(string: contact.imageUrl) {
            UIImageView.setImage(imageView: profileImageView, url: url, placeholder: #imageLiteral(resourceName: "profile_icon"))
        }
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.layer.masksToBounds = true
        newQuestionImage.isHidden = !(self.contact?.hasNewQuestion ?? false)
    }

}
