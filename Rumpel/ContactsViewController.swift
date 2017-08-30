//
//  ContactsViewController.swift
//  Rumpel
//
//  Created by Harel Avikasis on 29/06/2017.
//  Copyright © 2017 HarelAvikasis. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController
{
    @IBOutlet var tableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    var viewModel = ContactsViewModel()
       var isAlraedyShow = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        self.title = "Contacts"
        if (viewModel.numberOfContacts() == 0)
        {
            activityIndicator.startAnimating()
            viewModel.fetchContacts(completionBlock: { (success) in
                if success
                {
                    self.tableView.reloadData()
                }
                self.activityIndicator.stopAnimating()
            })
        }
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTable), name: NSNotification.Name(rawValue: "newPushMessageArrive"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        self.isAlraedyShow = false
    }
    
    func refreshTable()
    {
        self.tableView.reloadSections([0], with: .top)
    }
}

extension ContactsViewController : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel.numberOfContacts()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        if let contact = viewModel.getContactForIndex(index: indexPath.row)
        {
            cell.configureCell(withContact: contact)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let theStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let chatVC = theStoryboard.instantiateViewController(withIdentifier :"ChatViewController") as! ChatViewController
        if let contact = viewModel.getContactForIndex(index: indexPath.row)
        {
            let chatId = UserManager.manager.chatsIdMap[contact.id]
            UserDefaults.standard.removeObject(forKey: contact.id)
            contact.hasNewQuestion = false
            FirebaseManager.manager.fetchUserConversation(withchatId: chatId, endPoint: contact.id) { (Bool,chat) in
                chatVC.chat = chat
                chatVC.contact = self.viewModel.getContactForIndex(index: indexPath.row)
                if !self.isAlraedyShow
                {
                    self.navigationController?.pushViewController(chatVC, animated: true)
                    self.isAlraedyShow = true
                    tableView.reloadRows(at: [indexPath], with: .none)
                }
                
            }
        }
        
    }
    
}
