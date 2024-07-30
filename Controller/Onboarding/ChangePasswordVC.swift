//
//  ChangePasswordVC.swift
//  synex
//
//  Created by Ritesh chopra on 05/09/23.
//

import UIKit

class ChangePasswordVC: BaseVC {
    
    //MARK: - outlets
    
    @IBOutlet weak var screenTitle: UILabel!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var oldPasswordTextfield: UITextField!
    @IBOutlet weak var newPasswordTextfield: UITextField!
    @IBOutlet weak var confirmNewPasswordTextfield: UITextField!
    @IBOutlet weak var oldPasswordLabel: UILabel!
    @IBOutlet weak var newPasswordLabel: UILabel!
    @IBOutlet weak var confirmNewPasswordLabel: UILabel!
    @IBOutlet weak var oldPasswordViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var oldPasswordTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var oldPasswordBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var oldPasswordView: UIView!
    
    @IBOutlet weak var oldPasswordIcon: UIButton!
   
    @IBOutlet weak var newPasswordIcon: UIButton!
    
    @IBOutlet weak var confirmPasswordIcon: UIButton!
    
    //MARK: - Variable
    let viewModel = LoginViewModel()
    var languageStrings = [String:AnyObject]()
    var comeFromSideMenu = false
    var isReset = false
    var termsStatus = false
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customizeUI()
    }
    
    //MARK: - private function
    
  private func customizeUI() {
      setNavigation(title: AppConfig.empty,showBack: comeFromSideMenu ? false : true,showMenuButton: comeFromSideMenu ? true : false)
      oldPasswordIcon.tintColor = UIColor(hexString: "#CCD1D3")
      newPasswordIcon.tintColor = UIColor(hexString: "#CCD1D3")
      confirmPasswordIcon.tintColor = UIColor(hexString: "#CCD1D3")
      languageStringConvert()

}
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - languageConvert
    func languageStringConvert() {
        languageStrings = Global.readStrings()
       
        oldPasswordLabel.text = languageStrings[Keys.oldPassword] as? String
        oldPasswordTextfield.placeholder = languageStrings[Keys.oldPassword] as? String
       
        newPasswordLabel.text = languageStrings[Keys.newPassword] as? String
        newPasswordTextfield.placeholder = languageStrings[Keys.newPassword] as? String
      
        confirmNewPasswordLabel.text = languageStrings[Keys.confirmNewPassword] as? String
        confirmNewPasswordTextfield.placeholder = languageStrings[Keys.confirmNewPassword] as? String

        confirmButton.setTitle(languageStrings[Keys.confirm] as? String, for: .normal)
        
        if isReset {
            screenTitle.text = languageStrings[Keys.resetPassword] as? String
            oldPasswordView.isHidden = true
            oldPasswordTopConstraint.constant = 0
            oldPasswordViewHeightConstraint.constant = 0
            oldPasswordBottomConstraint.constant = 0
            oldPasswordLabel.text = ""
        } else {
            screenTitle.text = languageStrings[Keys.changePassword] as? String
        }
  }

    //MARK: - Actions
    @IBAction func hideShowButtonAction(_ sender: UIButton) {
        if sender.tag == 0{
            sender.isSelected = !sender.isSelected
            if sender.isSelected {
                oldPasswordTextfield.isSecureTextEntry = false
                oldPasswordIcon.tintColor = UIColor(hexString: "#FF9160")
            }else{
                oldPasswordTextfield.isSecureTextEntry = true
                oldPasswordIcon.tintColor = UIColor(hexString: "#CCD1D3")
            }
        }
        else if sender.tag == 1{
            sender.isSelected = !sender.isSelected
            if sender.isSelected {
                newPasswordTextfield.isSecureTextEntry = false
                newPasswordIcon.tintColor = UIColor(hexString: "#FF9160")
            }else{
                newPasswordTextfield.isSecureTextEntry = true
                newPasswordIcon.tintColor = UIColor(hexString: "#CCD1D3")
            }
        }
        else if sender.tag == 2{
            sender.isSelected = !sender.isSelected
            if sender.isSelected {
                confirmNewPasswordTextfield.isSecureTextEntry = false
                confirmPasswordIcon.tintColor = UIColor(hexString: "#FF9160")
            }else{
                confirmNewPasswordTextfield.isSecureTextEntry = true
                confirmPasswordIcon.tintColor = UIColor(hexString: "#CCD1D3")
                
            }
        }
        
    }
    
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if !isReset {
            if oldPasswordTextfield.text.optionalValue().isEmpty {
                self.showAlert(title: languageStrings[Keys.oldPasswordRequired] as? String, message: nil,buttonTitles: [languageStrings[Keys.ok]] as? [String])
                return
            }
        }
       
        if newPasswordTextfield.text.optionalValue().isEmpty {
            self.showAlert(title: languageStrings[Keys.newPasswordRequired] as? String, message: nil,buttonTitles: [languageStrings[Keys.ok]] as? [String])
            return
        }
        else if !newPasswordTextfield.text!.checkPassword() {
            self.showAlert(title: languageStrings[Keys.passwordError] as? String, message: nil,buttonTitles: [languageStrings[Keys.ok]] as? [String])
            return
        }
        else if confirmNewPasswordTextfield.text.optionalValue().isEmpty {
            self.showAlert(title: languageStrings[Keys.confirmNewPasswordRequired] as? String, message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
            return
        }
        else if newPasswordTextfield.text != confirmNewPasswordTextfield.text {
            self.showAlert(title: languageStrings[Keys.validateConfirmPassword] as? String, message: nil,buttonTitles: [languageStrings[Keys.ok]] as? [String])
            return
        }
        self.callApi()
    }
    
    func callApi() {
        if  !newPasswordTextfield.text.optionalValue().isEmpty && !confirmNewPasswordTextfield.text.optionalValue().isEmpty {
            
        let diction = ["oldPassword": oldPasswordTextfield.text!, "newPassword": newPasswordTextfield.text!] as [String : AnyObject]
        
        self.showProgressBar(message: "")
        
        viewModel.changePassword(parameters: diction) { [self] status, message in
            
            self.hideProgressBar()
            
            if status {
                self.alert(view: self, title: (languageStrings[Keys.passwordSuccess] as? String ?? ""), buttonText: self.languageStrings[Keys.ok] as? String ) {
                    if self.isReset {
                        if AppInstance.shared.isTermsAccepted == true {
                            Global.saveDataInUserDefaults(bool: self.termsStatus as AnyObject, key: .terms)
                                    self.redirectToHome()
                        }
                        else {
                            if AppInstance.shared.step == ProfileCompletionSteps.step0 {
                                if let controller = UserInformationVC.getObject() {
                                    self.navigationController?.pushViewController(controller, animated: true)
                                }
                            } else if AppInstance.shared.step == ProfileCompletionSteps.step1 {
                                if let controller = HealthDetailsVC.getObject() {
                                    self.navigationController?.pushViewController(controller, animated: true)
                                }
                            } else if AppInstance.shared.step == ProfileCompletionSteps.step2 && AppInstance.shared.isTermsAccepted == false {
                                self.showTerm(navController: self.navigationController ?? UINavigationController())
                            }
                            else {
                                self.redirectToHome()
                            }
                        }
//                        Global.saveDataInUserDefaults(bool: self.termsStatus as AnyObject, key: .terms)
//                        let isTerms = self.termsStatus
//                        if (self.termsStatus == false){
//                            self.navigateToTerms()
//                            return
//                        }
                    }
                   // self.redirectToHome()
                }
              
            } else {
                self.showAlert(title: (languageStrings[message] as? String)!, message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
            }
          }
       }
    }
}
