//
//  NewQuestionViewController.swift
//  Rumpel
//
//  Created by Harel Avikasis on 02/07/2017.
//  Copyright © 2017 HarelAvikasis. All rights reserved.
//

import UIKit
import BEMCheckBox

protocol AddNewQuestionProtocol:class
{
    func addQuestionToConversation(question: Question)
}
class NewQuestionViewController: UIViewController ,UITextFieldDelegate ,SelectQuestionFromPoolProtocol{

    @IBOutlet var answer1CheckBox: BEMCheckBox!
    @IBOutlet var answer2CheckBox: BEMCheckBox!
    @IBOutlet var answer3CheckBox: BEMCheckBox!
    @IBOutlet var answer4CheckBox: BEMCheckBox!
    var group : BEMCheckBoxGroup! = nil
    
    @IBOutlet var addQuestion: UIButton!
    
    @IBOutlet var questionTextField: UITextField!
    @IBOutlet var ans1TextField: UITextField!
    @IBOutlet var ans2TextField: UITextField!
    @IBOutlet var ans3TextField: UITextField!
    @IBOutlet var ans4TextField: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    
    weak var delegate : AddNewQuestionProtocol?
    
    var questionFromPool : Question?
    
//  MARK: Override Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.questionTextField.delegate = self
        self.ans1TextField.delegate = self
        self.ans2TextField.delegate = self
        self.ans3TextField.delegate = self
        self.ans4TextField.delegate = self
        addQuestion.isHidden = true
        registerForKeyboardNotifications()
        self.hideKeyboardWhenTappedAround()
        self.group = BEMCheckBoxGroup(checkBoxes: [self.answer1CheckBox,self.answer2CheckBox,self.answer3CheckBox,self.answer4CheckBox])
        self.group.selectedCheckBox = self.answer1CheckBox
        self.group.mustHaveSelection = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerForKeyboardNotifications()
    }
//  MARK: Action Functions
    @IBAction func backGroundTouched(_ sender: Any)
    {
        self.close(cleanFileds: false)
    }
    
    @IBAction func poolTapped(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier :"QuestionsPoolViewController") as! QuestionsPoolViewController
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func resetButton(_ sender: Any)
    {
        clearFields()
    }
    
    @IBAction func addQuestionTapped(_ sender: Any)
    {
        if questionFromPool == nil
        {
            let question = Question()
            question.questionText = questionTextField.text!
            question.initialTime = 0
            question.timeToAnswer = 0
            question.isRightAnswer = false
            question.isQuestionOpen = true
            let ans1 = Answer(answerText: ans1TextField.text!, isRight: answer1CheckBox.on)
            let ans2 = Answer(answerText: ans2TextField.text!, isRight: answer2CheckBox.on)
            let ans3 = Answer(answerText: ans3TextField.text!, isRight: answer3CheckBox.on)
            let ans4 = Answer(answerText: ans4TextField.text!, isRight: answer4CheckBox.on)
            question.answers = [ans1,ans2,ans3,ans4]
            FirebaseManager.manager.addNewQuestion(withQuestion: question) { (questionId) in
                question.senderId = UserManager.manager.userId!
                question.id = questionId!
                question.initialTime = Int(Date().timeIntervalSince1970)
                self.delegate?.addQuestionToConversation(question: question)
                self.close(cleanFileds: true)
            }
        }
        else
        {
            questionFromPool?.questionText = questionTextField.text!
            let ans1 = Answer(answerText: ans1TextField.text!, isRight: answer1CheckBox.on)
            let ans2 = Answer(answerText: ans2TextField.text!, isRight: answer2CheckBox.on)
            let ans3 = Answer(answerText: ans3TextField.text!, isRight: answer3CheckBox.on)
            let ans4 = Answer(answerText: ans4TextField.text!, isRight: answer4CheckBox.on)
            questionFromPool?.answers = [ans1,ans2,ans3,ans4]
            questionFromPool?.initialTime = Int(Date().timeIntervalSince1970)
            questionFromPool?.senderId = UserManager.manager.userId!
            questionFromPool?.isQuestionOpen = true
            self.delegate?.addQuestionToConversation(question: questionFromPool!)
            self.close(cleanFileds: true)
        }
    }
    
    func close(cleanFileds flag:Bool)
    {
        self.dismiss(animated: true, completion:{
            self.deregisterFromKeyboardNotifications()
        })
        if (flag)
        {
           clearFields()
        }
    }
    
    func clearFields()
    {
        questionFromPool = nil
        self.group.selectedCheckBox = self.answer1CheckBox
        questionTextField.text = ""
        ans1TextField.text = ""
        ans2TextField.text = ""
        ans3TextField.text = ""
        ans4TextField.text = ""
        addQuestion.isHidden = true
    }
    
    func questionWasSelected(withQuestion question:Question)
    {
        self.questionFromPool = question
        questionTextField.text = question.questionText
        ans1TextField.text = question.answers[0].answerText
        ans2TextField.text = question.answers[1].answerText
        ans3TextField.text = question.answers[2].answerText
        ans4TextField.text = question.answers[3].answerText
        answer1CheckBox.on = question.answers[0].isRight
        answer2CheckBox.on = question.answers[1].isRight
        answer3CheckBox.on = question.answers[2].isRight
        answer4CheckBox.on = question.answers[3].isRight

        addQuestion.isHidden = false
    }
    
//  MARK: Text Field Delegate
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.questionTextField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }else if let activeField = self.ans1TextField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }else if let activeField = self.ans2TextField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }else if let activeField = self.ans3TextField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }else if let activeField = self.ans4TextField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        addQuestion.isHidden = !checkIfAllFieldAreLegit()
    }
    
    func checkIfAllFieldAreLegit() -> Bool
    {
        var legit = true
        if (self.questionTextField.text?.isEmpty)! {
           legit = false
        }else if (self.ans1TextField.text?.isEmpty)! {
             legit = false
        }else if (self.ans2TextField.text?.isEmpty)! {
             legit = false
        }else if (self.ans3TextField.text?.isEmpty)! {
             legit = false
        }else if (self.ans4TextField.text?.isEmpty)! {
             legit = false
        }
        return legit
    }
    
}
