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
        answerBackgorund1.removeFromSuperview()
        answerBackgorund2.removeFromSuperview()
        answerBackgorund3.removeFromSuperview()
        answerBackgorund4.removeFromSuperview()
        
        answerBackgorund1 = UIView(frame: answerOneButton.frame)
        answerBackgorund2 = UIView(frame: answerTwoButton.frame)
        answerBackgorund3 = UIView(frame: answerThreeButton.frame)
        answerBackgorund4 = UIView(frame: answerFourButton.frame)
        
        answerBackgorund1.backgroundColor = UIColor.black
        answerBackgorund1.alpha = 0.4
        answerBackgorund2.backgroundColor = UIColor.black
        answerBackgorund2.alpha = 0.4
        answerBackgorund3.backgroundColor = UIColor.black
        answerBackgorund3.alpha = 0.4
        answerBackgorund4.backgroundColor = UIColor.black
        answerBackgorund4.alpha = 0.4
        
        let cornerRaduis : CGFloat = 16.0
        answerBackgorund1.layer.cornerRadius = cornerRaduis
        answerBackgorund2.layer.cornerRadius = cornerRaduis
        answerBackgorund3.layer.cornerRadius = cornerRaduis
        answerBackgorund4.layer.cornerRadius = cornerRaduis
        answerOneButton.layer.cornerRadius = cornerRaduis
        answerTwoButton.layer.cornerRadius = cornerRaduis
        answerThreeButton.layer.cornerRadius = cornerRaduis
        answerFourButton.layer.cornerRadius = cornerRaduis

        
        answerOneButton.titleLabel?.textColor = .white
        answerTwoButton.titleLabel?.textColor = .white
        answerThreeButton.titleLabel?.textColor = .white
        answerFourButton.titleLabel?.textColor = .white
        
        answerOneButton.backgroundColor = UIColor.clear
        answerTwoButton.backgroundColor = UIColor.clear
        answerThreeButton.backgroundColor = UIColor.clear
        answerFourButton.backgroundColor = UIColor.clear
        
        answerOneButton.layer.borderColor = UIColor.black.cgColor
        answerOneButton.layer.borderWidth = 2.0
        answerTwoButton.layer.borderColor = UIColor.black.cgColor
        answerTwoButton.layer.borderWidth = 2.0
        answerThreeButton.layer.borderColor = UIColor.black.cgColor
        answerThreeButton.layer.borderWidth = 2.0
        answerFourButton.layer.borderColor = UIColor.black.cgColor
        answerFourButton.layer.borderWidth = 2.0
        
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
            answersView.addSubview(answerBackgorund1)
            answersView.addSubview(answerBackgorund2)
            answersView.addSubview(answerBackgorund3)
            answersView.addSubview(answerBackgorund4)
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
