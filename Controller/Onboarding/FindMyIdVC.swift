//
//  FindMyIdVC.swift
//  synex
//
//  Created by Ritesh chopra on 05/09/23.
//

import UIKit

class FindMyIdVC: BaseVC {
    
    //MARK: - outlets
    
    @IBOutlet weak var phoneNumberTitle: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var emailTitle: UILabel!
    @IBOutlet weak var forgotPasswordTitle: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dialCodeLabel: UILabel!
    @IBOutlet weak var phoneNumberTextfield: UITextField!
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
        forgotPasswordTitle.text = languageStrings[Keys.findId] as? String
        descriptionLabel.text = languageStrings[Keys.findIdDesc] as? String
        phoneNumberTitle.text = (languageStrings[Keys.phoneNumber] as? String ?? "") + "*"
        phoneNumberTextfield.placeholder = languageStrings[Keys.phoneNumber] as? String
        confirmButton.setTitle(languageStrings[Keys.confirm] as? String, for: .normal)
}
    
    
    //MARK: - Actions
    @IBAction func countryPickerButtonAction(_ sender: Any) {
        showCountryPicker()
    }
    
    override func pickedCountry(name: String, code: String, dialCode: String) {
        dialCodeLabel.text = dialCode
    }
    
    
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if phoneNumberTextfield.text.optionalValue().isEmpty {
            self.showAlert(title: languageStrings[Keys.phoneNumberRequired] as? String, message: nil,buttonTitles: [languageStrings[Keys.ok]] as? [String])
            return
        }

        //API call
        callApi ()
    }
    
    func callApi () {
        if !phoneNumberTextfield.text.optionalValue().isEmpty {
            let diction = ["countryCode": dialCodeLabel.text!, "phoneNumber": phoneNumberTextfield.text!] as [String : AnyObject]
        
        self.showProgressBar(message: "")
        
        viewModel.findMyId(parameters: diction) { [self] status, message in
            
            self.hideProgressBar()
            
            if status {
                var emailId = viewModel.userDict["email"] as? String ?? ""
                let indexValue = emailId.index(emailId.startIndex, offsetBy: 0)
                emailId.replaceSubrange(indexValue...indexValue, with: "*")
                let indexValue2 = emailId.index(emailId.startIndex, offsetBy: 1)
                emailId.replaceSubrange(indexValue2...indexValue2, with: "*")
                self.alert(view: self, title: "", message: "\(languageStrings[Keys.popUpTitle] as? String ?? "")\n\(emailId)", buttonText: self.languageStrings[Keys.ok] as? String ) {
                    self.backButtonAction()
                }
            } else {
                self.showAlert(title: (languageStrings[message] as? String), message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
            }
          }
       }
    }
}

//MARK: - Textfield Delegate
extension FindMyIdVC : UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
      
        if string == AppConfig.empty2 {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == phoneNumberTextfield {
            phoneNumberTextfield.resignFirstResponder()
        }
        return true
    }
}

