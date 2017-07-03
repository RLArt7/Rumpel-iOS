//
//  QuestionsPoolViewController.swift
//  Rumpel
//
//  Created by Harel Avikasis on 03/07/2017.
//  Copyright © 2017 HarelAvikasis. All rights reserved.
//

import UIKit

protocol SelectQuestionFromPoolProtocol: class
{
    func questionWasSelected(withQuestion question:Question)
}

class QuestionsPoolViewController: UIViewController ,QuestionPoolDataProtocol {

    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var viewModel : QuestionsPoolViewModel?
    weak var delegate : SelectQuestionFromPoolProtocol?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.activityIndicator.startAnimating()
        self.viewModel = QuestionsPoolViewModel(withDelegate: self)
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
    }
    
    func finishLoadData()
    {
        self.activityIndicator.stopAnimating()
        pickerView.reloadAllComponents()
    }
    @IBAction func cancel(_ sender: Any)
    {
        close()
    }
    func close()
    {
        self.dismiss(animated: true, completion: nil)
    }
}
extension QuestionsPoolViewController : UIPickerViewDelegate,UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return viewModel!.questions.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        self.delegate?.questionWasSelected(withQuestion: viewModel!.questions[row])
        close()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return viewModel!.questions[row].questionText
    }
}
