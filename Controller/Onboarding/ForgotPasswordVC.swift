//
//  ForgotPasswordVC.swift
//  synex
//
//  Created by Ritesh chopra on 05/09/23.
//

import UIKit

class ForgotPasswordVC: BaseVC {
    
    //MARK: - outlets
    
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var emailTitle: UILabel!
    @IBOutlet weak var forgotPasswordTitle: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: - Variable
    let viewModel = LoginViewModel()
    var languageStrings = [String:AnyObject]()
    
   //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customizeUI()
    }
    
    //MARK: - private Function
    private func customizeUI() {
        self.setNavigation(title: AppConfig.empty)
        languageStringConvert()

    }
    
    
    //MARK: - languageConvert
    func languageStringConvert() {
        languageStrings = Global.readStrings()
         forgotPasswordTitle.text = languageStrings[Keys.forgotPassword] as? String
        descriptionLabel.text = languageStrings[Keys.forgotDescription] as? String
        emailTitle.text = languageStrings[Keys.emailAddress] as? String
        emailTextfield.placeholder = languageStrings[Keys.emailAddress] as? String
       confirmButton.setTitle(languageStrings[Keys.confirm] as? String, for: .normal)
}
    
    
    //MARK: - Actions
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if emailTextfield.text.optionalValue().isEmpty {
            self.showAlert(title: languageStrings[Keys.emailRequired] as? String, message: nil,buttonTitles: [languageStrings[Keys.ok]] as? [String])
            return
        }
        else if !emailTextfield.text!.isValidEmail() {
            self.showAlert(title: languageStrings[Keys.invalidEmail] as? String, message: nil,buttonTitles: [languageStrings[Keys.ok]] as? [String])
            return
        }

        //API call
        callApi ()
    }
    
    func callApi () {
        var appLanguage = Languages.english
        if !emailTextfield.text.optionalValue().isEmpty {
            let diction = ["email": emailTextfield.text!,"language":appLanguage.getLanguage()] as [String : AnyObject]
        
        self.showProgressBar(message: "")
        
        viewModel.forgotPassword(parameters: diction) { [self] status, message in
            
            self.hideProgressBar()
            
            if status {
                self.alert(view: self, title: (languageStrings[Keys.emailSuccess] as? String)!, buttonText: self.languageStrings[Keys.ok] as? String ) {
                    self.backButtonAction()
                }
               // self.navigationController?.popViewController(animated: true)
            } else {
                self.showAlert(title: (languageStrings[message] as? String), message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
            }
          }
       }
    }
}

//MARK: - Textfield Delegate
extension ForgotPasswordVC : UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
      
        if string == AppConfig.empty2 {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextfield {
            emailTextfield.resignFirstResponder()
        }
        return true
    }
}

