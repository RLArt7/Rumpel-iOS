//
//  ChatViewController.swift
//  Rumpel
//
//  Created by Harel Avikasis on 29/06/2017.
//  Copyright © 2017 HarelAvikasis. All rights reserved.
//

import UIKit
import JSQMessagesViewController

public enum Setting: String{
    case removeBubbleTails = "Remove message bubble tails"
    case removeSenderDisplayName = "Remove sender Display Name"
    case removeAvatar = "Remove Avatars"
}

class ChatViewController: JSQMessagesViewController {

    var answersView: UIView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 134, width: UIScreen.main.bounds.width, height: 134))
    var answerOneButton: UIButton = UIButton(frame: CGRect(x: 0, y: 0, width:  UIScreen.main.bounds.width / 2, height: 67))
    var answerTwoButton: UIButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width / 2, y: 0, width:  UIScreen.main.bounds.width / 2, height: 67))
    var answerThreeButton: UIButton = UIButton(frame: CGRect(x: 0, y: 67, width:  UIScreen.main.bounds.width / 2, height: 67))
    var answerFourButton: UIButton = UIButton(frame: CGRect(x: UIScreen.main.bounds.width / 2, y: 67, width:  UIScreen.main.bounds.width / 2, height: 67))
    
    var chat : Chat?
    var endPointUserDisplayName: String!
    var messages = [JSQMessage]()
    let defaults = UserDefaults.standard
    var incomingBubble: JSQMessagesBubbleImage!
    var outgoingBubble: JSQMessagesBubbleImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(endPointUserDisplayName!)"
        self.inputToolbar.isHidden = true
        self.senderId = UserManager.manager.userId
        self.senderDisplayName = UserManager.manager.name
        
        chat?.questions.forEach({ (question) in
            messages.append(JSQMessage(senderId: question.senderId, displayName: question.senderId == self.senderId ? self.senderDisplayName : endPointUserDisplayName, text: question.getMessageTextForQuestion()))
        })
        
        incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
        outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImage(with: UIColor.lightGray)
        
        if defaults.bool(forKey: Setting.removeAvatar.rawValue) {
            collectionView?.collectionViewLayout.incomingAvatarViewSize = .zero
            collectionView?.collectionViewLayout.outgoingAvatarViewSize = .zero
        } else {
            collectionView?.collectionViewLayout.incomingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault )
            collectionView?.collectionViewLayout.outgoingAvatarViewSize = CGSize(width: kJSQMessagesCollectionViewAvatarSizeDefault, height:kJSQMessagesCollectionViewAvatarSizeDefault )
        }

        collectionView?.collectionViewLayout.springinessEnabled = false
        
        automaticallyScrollsToMostRecentMessage = true
        self.collectionView?.reloadData()
        self.collectionView?.layoutIfNeeded()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setOutlets()
    }
    
    func setOutlets()
    {
        if (chat?.isThereOpenQuestion)!
        {
            let frame = CGRect(x:  self.collectionView.frame.origin.x, y: UIScreen.main.bounds.width, width: self.collectionView.frame.width, height: self.collectionView.frame.height - 134)
            self.collectionView.frame = frame
            self.view.addSubview(answersView)
            self.view.bringSubview(toFront: answersView)
            
            if (chat?.isThereOpenQuestion)!
            {
                self.setButtons(withQuestion: (chat?.fetchOpenQuestoin())!)
            }
        }
        else
        {
            let frame = CGRect(x:  self.collectionView.frame.origin.x, y: UIScreen.main.bounds.width, width: self.collectionView.frame.width, height: UIScreen.main.bounds.height)
            self.collectionView.frame = frame
            answersView.removeFromSuperview()
            // TODO : need to add here the '+' button to add answers
        }
    }
    
    func setButtons(withQuestion question:Question)
    {
        answerOneButton.removeFromSuperview()
        answerTwoButton.removeFromSuperview()
        answerThreeButton.removeFromSuperview()
        answerFourButton.removeFromSuperview()
        
        answerOneButton.titleLabel?.textColor = .white
        answerTwoButton.titleLabel?.textColor = .white
        answerThreeButton.titleLabel?.textColor = .white
        answerFourButton.titleLabel?.textColor = .white
        
        answerOneButton.backgroundColor = UIColor.lightGray
        answerTwoButton.backgroundColor = UIColor.lightGray
        answerThreeButton.backgroundColor = UIColor.lightGray
        answerFourButton.backgroundColor = UIColor.lightGray
        
        answerOneButton.addTarget(self, action: #selector(ChatViewController.answerSelected(sender:)), for: .touchUpInside)
        answerTwoButton.addTarget(self, action: #selector(ChatViewController.answerSelected(sender:)), for: .touchUpInside)
        answerThreeButton.addTarget(self, action: #selector(ChatViewController.answerSelected(sender:)), for: .touchUpInside)
        answerFourButton.addTarget(self, action: #selector(ChatViewController.answerSelected(sender:)), for: .touchUpInside)
        
        answerOneButton.tag = 0
        answerTwoButton.tag = 1
        answerThreeButton.tag = 2
        answerFourButton.tag = 3
        
        if question.isQuestionOpen
        {
            answerOneButton.setTitle("1: \(question.answers[0].answerText)", for: .normal)
            answerTwoButton.setTitle("2: \(question.answers[1].answerText)", for: .normal)
            answerThreeButton.setTitle("3: \(question.answers[2].answerText)", for: .normal)
            answerFourButton.setTitle("4: \(question.answers[3].answerText)", for: .normal)
            answersView.addSubview(answerOneButton)
            answersView.addSubview(answerTwoButton)
            answersView.addSubview(answerThreeButton)
            answersView.addSubview(answerFourButton)
            if question.senderId == senderId
            {
                answerOneButton.isEnabled = false
                answerTwoButton.isEnabled = false
                answerThreeButton.isEnabled = false
                answerFourButton.isEnabled = false
            }
            else
            {
                answerOneButton.isEnabled = true
                answerTwoButton.isEnabled = true
                answerThreeButton.isEnabled = true
                answerFourButton.isEnabled = true
            }
        }
    }
    
    func answerSelected(sender: UIButton!)
    {
        chat?.fetchOpenQuestoin()?.checkAnswer(withAnswerIndex: sender.tag)
        messages.removeAll()
        chat?.questions.forEach({ (question) in
            messages.append(JSQMessage(senderId: question.senderId, displayName: question.senderId == self.senderId ? self.senderDisplayName : endPointUserDisplayName, text: question.getMessageTextForQuestion()))
        })
        chat?.isThereOpenQuestion = false
        self.updatChatInFirebase()
        setOutlets()
        self.collectionView?.reloadData()
        self.collectionView?.layoutIfNeeded()
    }
    
    func updatChatInFirebase()
    {
        FirebaseManager.manager.updateChat(withChat: chat!)
    }
    //MARK: JSQMessages CollectionView DataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageDataForItemAt indexPath: IndexPath) -> JSQMessageData {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, messageBubbleImageDataForItemAt indexPath: IndexPath) -> JSQMessageBubbleImageDataSource {
            return  messages[indexPath.item].senderId == self.senderId ? self.outgoingBubble : self.incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, avatarImageDataForItemAt indexPath: IndexPath) -> JSQMessageAvatarImageDataSource? {
        let message = messages[indexPath.item]
        let avatar = JSQMessagesAvatarImageFactory.avatarImage(withUserInitials: message.senderId == senderId ? self.getUserInitials(withUserName: self.senderDisplayName) : self.getUserInitials(withUserName: self.endPointUserDisplayName), backgroundColor: UIColor.jsq_messageBubbleGreen(), textColor:  UIColor.white, font:  UIFont.systemFont(ofSize: 12), diameter: 25)
        return avatar
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForCellTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        /**
         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
         *  The other label text delegate methods should follow a similar pattern.
         *
         *  Show a timestamp for every 3rd message
         */
        if (indexPath.item % 3 == 0) {
            let message = self.messages[indexPath.item]
            
            return JSQMessagesTimestampFormatter.shared().attributedTimestamp(for: message.date)
        }
        
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath) -> NSAttributedString? {
        let message = messages[indexPath.item]
        
        // Displaying names above messages
        //Mark: Removing Sender Display Name
        /**
         *  Example on showing or removing senderDisplayName based on user settings.
         *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
         */
        if defaults.bool(forKey: Setting.removeSenderDisplayName.rawValue) {
            return nil
        }
        
        if message.senderId == self.senderId {
            return nil
        }
        
        return NSAttributedString(string: message.senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForCellTopLabelAt indexPath: IndexPath) -> CGFloat {
        /**
         *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
         */
        
        /**
         *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
         *  The other label height delegate methods should follow similarly
         *
         *  Show a timestamp for every 3rd message
         */
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        
        return 0.0
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout, heightForMessageBubbleTopLabelAt indexPath: IndexPath) -> CGFloat {
        
        /**
         *  Example on showing or removing senderDisplayName based on user settings.
         *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
         */
        if defaults.bool(forKey: Setting.removeSenderDisplayName.rawValue) {
            return 0.0
        }
        
        /**
         *  iOS7-style sender name labels
         */
        let currentMessage = self.messages[indexPath.item]
        
        if currentMessage.senderId == self.senderId {
            return 0.0
        }
        
        if indexPath.item - 1 > 0 {
            let previousMessage = self.messages[indexPath.item - 1]
            if previousMessage.senderId == currentMessage.senderId {
                return 0.0
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    func getUserInitials(withUserName name:String)->String
    {
        var nameArray = name.components(separatedBy: " ")
        if nameArray.count >= 2
        {
            let firstFromName = nameArray[0].substring(to:nameArray[0].index(nameArray[0].startIndex, offsetBy: 1)).uppercased()
            let firstFromLastName = nameArray[1].substring(to:nameArray[1].index(nameArray[1].startIndex, offsetBy: 1)).uppercased()
            return "\(firstFromName)\(firstFromLastName)"
        }
        else if nameArray.count != 0
        {
            return nameArray[0].substring(to:nameArray[0].index(nameArray[0].startIndex, offsetBy: 1)).uppercased()
        }
        return "NA"
    }
   
}
