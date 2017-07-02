//
//  NewQuestionViewController.swift
//  Rumpel
//
//  Created by Harel Avikasis on 02/07/2017.
//  Copyright © 2017 HarelAvikasis. All rights reserved.
//

import UIKit
import BEMCheckBox

class NewQuestionViewController: UIViewController ,UITextFieldDelegate{

    @IBOutlet var answer1CheckBox: BEMCheckBox!
    @IBOutlet var answer2CheckBox: BEMCheckBox!
    @IBOutlet var answer3CheckBox: BEMCheckBox!
    @IBOutlet var answer4CheckBox: BEMCheckBox!
    var group : BEMCheckBoxGroup! = nil
    
    @IBOutlet var questionTextField: UITextField!
    @IBOutlet var ans1TextField: UITextField!
    @IBOutlet var ans2TextField: UITextField!
    @IBOutlet var ans3TextField: UITextField!
    @IBOutlet var ans4TextField: UITextField!
    @IBOutlet var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.questionTextField.delegate = self
        self.ans1TextField.delegate = self
        self.ans2TextField.delegate = self
        self.ans3TextField.delegate = self
        self.ans4TextField.delegate = self

        registerForKeyboardNotifications()
        self.hideKeyboardWhenTappedAround()
        
        self.group = BEMCheckBoxGroup(checkBoxes: [self.answer1CheckBox,self.answer2CheckBox,self.answer3CheckBox,self.answer4CheckBox])
        self.group.selectedCheckBox = self.answer1CheckBox
        self.group.mustHaveSelection = true
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backGroundTouched(_ sender: Any)
    {
        self.dismiss(animated: true, completion:{
            self.deregisterFromKeyboardNotifications()
        })
    }
    
    @IBAction func poolTapped(_ sender: Any)
    {
        
    }
    
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
    
    func textFieldDidBeginEditing(_ textField: UITextField){
//        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField){
//        activeField = nil
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
