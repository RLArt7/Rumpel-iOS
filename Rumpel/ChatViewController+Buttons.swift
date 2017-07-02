//
//  ChatViewController+Buttons.swift
//  Rumpel
//
//  Created by Harel Avikasis on 02/07/2017.
//  Copyright © 2017 HarelAvikasis. All rights reserved.
//

import Foundation
import UIKit

extension ChatViewController
{
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
    
  
    func setAddQuestionButton()
    {
        self.addAnswerButton.setImage(#imageLiteral(resourceName: "plus"), for: .normal)
        self.addAnswerButton.addTarget(self, action: #selector(ChatViewController.addQuestion(sender:)), for: .touchUpInside)
        self.view.addSubview(addAnswerButton)
    }
}
