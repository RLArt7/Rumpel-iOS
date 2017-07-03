//
//  QuestionsPoolViewModel.swift
//  Rumpel
//
//  Created by Harel Avikasis on 03/07/2017.
//  Copyright © 2017 HarelAvikasis. All rights reserved.
//

import Foundation

protocol QuestionPoolDataProtocol:class {
    func finishLoadData()
}
class QuestionsPoolViewModel
{
    var questions = [Question]()
    weak var delegate : QuestionPoolDataProtocol?
    
    init(withDelegate delegate: QuestionPoolDataProtocol)
    {
        self.delegate = delegate
        FirebaseManager.manager.fetchAllQuestions { (questions) in
            self.questions = questions
            self.delegate?.finishLoadData()
        }
    }
}
