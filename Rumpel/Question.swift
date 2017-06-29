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
    var questionsText = ""
    var senderId = ""
    var answer = [Answer]()
    var initialTime : Int?
    var timeToAnswer : Int?
    
    var isRightAnswer = false
    var isQuestionOpen = true
    
    
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
}
