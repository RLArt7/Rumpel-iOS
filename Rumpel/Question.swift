//
//  Question.swift
//  Rumpel
//
//  Created by Harel Avikasis on 25/06/2017.
//  Copyright © 2017 HarelAvikasis. All rights reserved.
//

import Foundation

class Question
{
    var id : String = ""
    var questionText = ""
    var senderId = ""
    var answers = [Answer]()
    var initialTime : Int?
    var timeToAnswer : Int?
    
    var isRightAnswer = false
    var isQuestionOpen = true
    
    init(question:[String:Any])
    {
        self.id = question["id"] as? String ?? ""
        self.questionText = question["questionText"] as? String ?? ""
        self.senderId = question["senderId"] as? String ?? ""
        self.timeToAnswer = question["timeToAnswer"] as? Int ?? 0
        self.initialTime = question["initialTime"] as? Int ?? 0
        self.isQuestionOpen = question["questionOpen"] as? Bool ?? false
        self.isRightAnswer = question["isRightAnswer"] as? Bool ?? false
        
        if let answers = question["answers"] as? [[String:Any]]
        {
            answers.forEach({ (answer) in
                self.answers.append(Answer(answer: answer))
            })
        }
    }
    
    func closeQuestion()
    {
        let now = Date().timeIntervalSince1970
        self.timeToAnswer = Int(now - TimeInterval(initialTime!))
        isQuestionOpen = false
    }
    
    func checkAnswer(withAnswer ans: Answer)->Bool
    {
        closeQuestion()
        if(ans.isRight)
        {
            isRightAnswer = true
            return true
        }
        else
        {
            return false
        }
    }
    
    func getMessageTextForQuestion()->String
    {
        var returnStr = "\(self.questionText)"
        if self.isQuestionOpen
        {
            returnStr += "\n"
            returnStr += "1.\(answers[0].answerText)\n"
            returnStr += "2.\(answers[1].answerText)\n"
            returnStr += "3.\(answers[2].answerText)\n"
            returnStr += "4.\(answers[3].answerText)\n"
            return returnStr
        }
        else
        {
            returnStr += self.isRightAnswer ? "✅" : "❌"
            return returnStr
        }
    }
}
