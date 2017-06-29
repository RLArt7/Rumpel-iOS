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
    
    init(dict : [String: Any]) {
        self.updateValues(dict: dict)
    }
    
    func updateValues(dict: [String: Any]){
        self.answerText = dict["answerText"] as? String ?? ""
        self.isRight = dict["isRight"] as? Bool ?? false
    }
}
