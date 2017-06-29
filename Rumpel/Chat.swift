//
//  Chat.swift
//  Rumpel
//
//  Created by Harel Avikasis on 25/06/2017.
//  Copyright © 2017 HarelAvikasis. All rights reserved.
//

import Foundation

class Chat
{
    var id = ""
    var endPoint = ""
    var questions = [Question]()
    
    func isThereOpenQuestions()->Bool
    {
        var returnValue = false
        questions.forEach({ (question) in
            if question.isQuestionOpen
            {
                returnValue =  true
            }
        })
        return returnValue
    }
    
    func fetchOpenQuestoin()-> Question?
    {
        var returnQuestion : Question? = nil
        questions.forEach({ (question) in
            if question.isQuestionOpen
            {
                returnQuestion = question
            }
        })
        return returnQuestion
    }
}
