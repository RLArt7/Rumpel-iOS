//
//  Chat.swift
//  Rumpel
//
//  Created by Harel Avikasis on 25/06/2017.
//  Copyright © 2017 HarelAvikasis. All rights reserved.
//

import Foundation
import Firebase

class Chat
{
    var id = ""
    var endPoint = ""
    var questions = [Question]()
    var isThereOpenQuestion = false
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
    
    func getObjectAsDictionary()->[String: Any]
    {
        var chatDict = [String: Any]()
        chatDict["id"] = self.id
        chatDict["endPoint"] = self.endPoint
        chatDict["thereOpenQuestion"] = self.isThereOpenQuestion
        var questionsDict =  [String: Any]()
        for (index,qusetion) in self.questions.enumerated()
        {
            questionsDict["\(index)"] = qusetion.getObjectAsDictionary()
        }
        chatDict["questions"] = questionsDict
        
        return chatDict
    }
    
    init(snapshot : DataSnapshot) {
        self.id = snapshot.key as? String ?? ""
        
        if let dict = snapshot.value as? [String : Any] {
            self.endPoint = dict["endPoint"] as? String ?? ""
            
            self.isThereOpenQuestion = dict["thereOpenQuestion"] as? Bool ?? false
            
            if let questions = dict["questions"] as? [[String:Any]]
            {
                questions.forEach({ (question) in
                   self.questions.append(Question(question: question))
                })
            }
            
        }
    }
    init(withChatId id:String,endPoint:String)
    {
        self.id = id
        self.endPoint = endPoint
        self.isThereOpenQuestion = false
    }
}
