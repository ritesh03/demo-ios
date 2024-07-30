//
//  SignUpVC.swift
//  synex
//
//  Created by Ritesh chopra on 01/09/23.
//

import UIKit

class SignUpVC: BaseVC {
    
    //MARK: - Outlets
    @IBOutlet weak var signUpTopContraint: NSLayoutConstraint!
    @IBOutlet weak var titleViewHeight: NSLayoutConstraint!
    @IBOutlet weak var viewForEmail: UIView!
    @IBOutlet weak var btnForPaasEye: UIButton!
    
    @IBOutlet weak var btnForConfirmPassEye: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var referralCodeTitle: UILabel!
    @IBOutlet weak var passwordTitle: UILabel!
    @IBOutlet weak var confirmPasswordTitle: UILabel!
    @IBOutlet weak var confirmEmailTitle: UILabel!
    @IBOutlet weak var emailAddressTitle: UILabel!
    @IBOutlet weak var signUpTitle: UILabel!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var confirmEmailTextfield: UITextField!
    @IBOutlet weak var referralCodeTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    @IBOutlet weak var dialCodeLabel: UILabel!
    
    //MARK: - Variable
    let viewModel = LoginViewModel()
    var languageStrings = [String:AnyObject]()
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.backgroundColor = UIColor(hexString: "#DCDFE3")
        signUpButton.isEnabled = false
        [emailTextfield, confirmEmailTextfield,passwordTextfield,confirmPasswordTextfield].forEach {
               $0?.addTarget(self,
                             action: #selector(editingChanged(_:)),
                             for: .editingChanged)
           }
     }
    
    override func viewWillAppear(_ animated: Bool) {
           customizeUI()
    }
    
    //MARK: - private function
    private func customizeUI() {
        setNavigation(title: AppConfig.empty)
        languageStringConvert()
//        if UIDevice.current.hasNotch {
//            titleViewHeight.constant = 85
//           // signUpTopContraint.constant = 50
//        }else{
//            //signUpTopContraint.constant = 10
//            titleViewHeight.constant = 70
//
//        }
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        
        // Trim whitespace and newlines
        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
//        signUpButton.isEnabled = ![emailTextfield, confirmEmailTextfield,passwordTextfield,confirmPasswordTextfield].compactMap {
//            $0.text?.isEmpty
//        }.contains(true)

            guard
              let email = emailTextfield.text, !email.isEmpty,
              let confirmEmail = confirmEmailTextfield.text, !confirmEmail.isEmpty,
              let password = passwordTextfield.text, !password.isEmpty,
              let confirmPassword = confirmPasswordTextfield.text, !confirmPassword.isEmpty
              else
                {
              return
              }
            // enable okButton if all conditions are met
              self.signUpButton.isEnabled = true
              self.signUpButton.backgroundColor = UIColor.greenColor()
    }
    
    //MARK: - languageConvert
    func languageStringConvert() {
        btnForPaasEye.tintColor = UIColor(hexString: "#CCD1D3")
        btnForConfirmPassEye.tintColor = UIColor(hexString: "#CCD1D3")
        languageStrings = Global.readStrings()
        signUpTitle.text = languageStrings[Keys.signUp] as? String
        emailAddressTitle.text = (languageStrings[Keys.email] as? String ?? "")
       // emailTextfield.placeholder = languageStrings[Keys.emailAddress] as? String
        confirmEmailTitle.text = (languageStrings[Keys.confirmEmailAddress] as? String ?? "")
       // confirmEmailTextfield.placeholder = languageStrings[Keys.confirmEmailAddress] as? String
        passwordTitle.text = (languageStrings[Keys.passwordTitle] as? String ?? "")
        passwordTextfield.placeholder = languageStrings[Keys.enterPassword] as? String
        confirmPasswordTitle.text = (languageStrings[Keys.confirmPassword] as? String ?? "")
        confirmPasswordTextfield.placeholder = languageStrings[Keys.passwordPlaceholder] as? String
        signUpButton.setTitle(languageStrings[Keys.next] as? String, for: .normal)
       // referralCodeTitle.text = languageStrings[Keys.referralCode] as? String
       // referralCodeTextfield.placeholder = languageStrings[Keys.referralCode] as? String
  }
    
    //MARK: - Actions
    fileprivate func extractedFunc() {
        //API call
        callSignUpApi ()
    }
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if emailTextfield.text.optionalValue().isEmpty {
            self.showAlert(title: languageStrings[Keys.emailRequired] as? String, message: nil,buttonTitles: [languageStrings[Keys.ok]] as? [String])
            return
        }
        else if !emailTextfield.text!.isValidEmail() {
            self.showAlert(title: languageStrings[Keys.invalidEmail] as? String, message: nil,buttonTitles: [languageStrings[Keys.ok]] as? [String])
            return
        }
        else if confirmEmailTextfield.text.optionalValue().isEmpty {
            self.showAlert(title: languageStrings[Keys.confirmEmailRequired] as? String, message: nil,buttonTitles: [languageStrings[Keys.ok]] as? [String])
            return
        }
        else if emailTextfield.text != confirmEmailTextfield.text {
            self.showAlert(title: languageStrings[Keys.validateConfirmEmail] as? String, message: nil,buttonTitles: [languageStrings[Keys.ok]] as? [String])
            return
        }
        else if passwordTextfield.text.optionalValue().isEmpty {
            self.showAlert(title: languageStrings[Keys.passwordRequired] as? String, message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
            return
        }
        else if !passwordTextfield.text!.checkPassword() {
            self.showAlert(title: languageStrings[Keys.passwordError] as? String, message: nil,buttonTitles: [languageStrings[Keys.ok]] as? [String])
            return
        }
        else if confirmPasswordTextfield.text.optionalValue().isEmpty {
            self.showAlert(title: languageStrings[Keys.confirmPasswordRequired] as? String, message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
            return
        }
        else if passwordTextfield.text != confirmPasswordTextfield.text {
            self.showAlert(title: languageStrings[Keys.confirmPasswordMatch] as? String, message: nil,buttonTitles: [languageStrings[Keys.ok]] as? [String])
            return
        }
        extractedFunc()
    }
    
    @IBAction func passwordHideAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            passwordTextfield.isSecureTextEntry = false
            btnForPaasEye.tintColor = UIColor(hexString: "#FF9160")
           
        }else{
            passwordTextfield.isSecureTextEntry = true
            btnForPaasEye.tintColor = UIColor(hexString: "#CCD1D3")
        }
    }
    
    @IBAction func confirmPasswordHideAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            confirmPasswordTextfield.isSecureTextEntry = false
            btnForConfirmPassEye.tintColor = UIColor(hexString: "#FF9160")
        }else{
            confirmPasswordTextfield.isSecureTextEntry = true
            btnForConfirmPassEye.tintColor = UIColor(hexString: "#CCD1D3")

        }
    }
    
    @IBAction func countryPickerButtonAction(_ sender: Any) {
        showCountryPicker()
    }
    
    override func pickedCountry(name: String, code: String, dialCode: String) {
    }
    
    
    func callSignUpApi () {
        let appLanguage = Languages.english
        if !emailTextfield.text.optionalValue().isEmpty && !passwordTextfield.text.optionalValue().isEmpty {
            
            let diction = ["language":appLanguage.getLanguage(), "email": emailTextfield.text!, "password": passwordTextfield.text!,"deviceId":UserDefaults.standard.value(forKey: "DeviceToken") ?? "","deviceType":AppConfig.deviceType,"uniqueCode": referralCodeTextfield.text ?? ""] as [String : AnyObject]
        
        self.showProgressBar(message: "")
        
        viewModel.userSignUp(parameters: diction) { [self] status, message in
            
            self.hideProgressBar()
            
            if status {
                Global.saveDataInUserDefaults(value: viewModel.userDict as AnyObject, key: .userData)
                Global.saveDataInUserDefaults(value: viewModel.userDict as AnyObject, key: .accessToken)
                if let controller = UserInformationVC.getObject() {
                    self.navigationController?.pushViewController(controller, animated: true)
                }
              
            } else {
                self.showAlert(title: (languageStrings[message] as? String), message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
            }
          }
       }
    }
}

//MARK: - Textfield Delegate
extension SignUpVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == emailTextfield {
            viewForEmail.backgroundColor = UIColor(hexString: "#FFFAF7")
        }
        return true
    }
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField == emailTextfield {
            viewForEmail.backgroundColor = UIColor(hexString: "#F6F6F6")
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
       if string == AppConfig.empty2 {
            return false
        }
        
      if textField == passwordTextfield {
            let maxLength = 20
            let currentString : NSString = textField.text as NSString? ?? ""
            let newString = currentString.replacingCharacters(in: range, with: string)
            return newString.count <= maxLength
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextfield {
            emailTextfield.resignFirstResponder()
            confirmEmailTextfield.becomeFirstResponder()
        }else if textField == confirmEmailTextfield{
            confirmEmailTextfield.resignFirstResponder()
            passwordTextfield.becomeFirstResponder()

        }else if textField == passwordTextfield {
            passwordTextfield.resignFirstResponder()
        }
        return true
    }
}

