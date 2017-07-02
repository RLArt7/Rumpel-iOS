//
//  Answer.swift
//  Rumpel
//
//  Created by Harel Avikasis on 25/06/2017.
//  Copyright © 2017 HarelAvikasis. All rights reserved.
//

import Foundation

class Answer
{
    var answerText : String = ""
    var isRight = false;
    
    init(answer : [String: Any]) {
        self.answerText = answer["answerText"] as? String ?? ""
        self.isRight = answer["isRight"] as? Bool ?? false
    }
    init(answerText: String, isRight:Bool)
    {
        self.answerText = answerText
        self.isRight = isRight
    }
    func getObjectAsDictionary()->[String: Any]
    {
        return ["answerText": self.answerText,"isRight":self.isRight]
    }
}
