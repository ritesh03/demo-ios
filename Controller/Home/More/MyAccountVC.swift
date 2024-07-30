//
//  UserInformationVC.swift
//  synex
//
//  Created by Ritesh chopra on 04/09/23.
//

import UIKit

class MyAccountVC: BaseVC {
    
    //MARK: - outlets
    //MARK: - getObject method
    class func getObject() -> MyAccountVC?{
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: MyAccountVC.className) as? MyAccountVC{
            return controller
        }
        return nil
    }
    
    @IBOutlet weak var confirmButtomTopContraint: NSLayoutConstraint!
    @IBOutlet weak var fullNameTopContraint: NSLayoutConstraint!
    @IBOutlet weak var titleHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var dialCodeLabel: UILabel!
    @IBOutlet weak var phoneNumberTextfield: UITextField!
    @IBOutlet weak var fullNameTextfield: UITextField!
    @IBOutlet weak var phoneNumberTitle: UILabel!
    @IBOutlet weak var fullNameTitle: UILabel!
    @IBOutlet weak var userInformationTitle: UILabel!
    @IBOutlet weak var emailAddressTitle: UILabel!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var btnForSgnOut: UIButton!
    @IBOutlet weak var btnForDelete: UIButton!
    @IBOutlet weak var btnForSave: UIButton!
    
    
    //MARK: - Variable
    let viewModel = LoginViewModel()
    var languageStrings = [String:AnyObject]()
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customizeUI()
    }
    
    //MARK: - private function
  private func customizeUI() {
      languageStringConvert()
      getProfileApi()
}
    
    //MARK: - languageConvert
    func languageStringConvert() {
        languageStrings = Global.readStrings()
        userInformationTitle.text = languageStrings[Keys.myAccount] as? String
        fullNameTitle.text = (languageStrings[Keys.fullName] as? String ?? "")
        fullNameTextfield.placeholder = languageStrings[Keys.namePlaceholder] as? String
        phoneNumberTitle.text = (languageStrings[Keys.phoneNumber] as? String ?? "")
        emailAddressTitle.text = languageStrings[Keys.email] as? String
        btnForSave.setTitle(languageStrings[Keys.save] as? String, for: .normal)
        btnForSgnOut.setAttributedTitle(NSMutableAttributedString(string: languageStrings[Keys.logout] as? String ?? "", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.kern: -0.14]), for: .normal)
        btnForDelete.setAttributedTitle(NSMutableAttributedString(string: languageStrings[Keys.deleteAccount] as? String ?? "", attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.kern: -0.14]), for: .normal)
  }
  
    func setValues(){
        if  let user = Global.getDataFromUserDefaults(.userData) {
            if let userName = user["name"] as? String{
                fullNameTextfield.text = userName
            }
            if let userEmail = user["email"] as? String{
                emailTextfield.text = userEmail
            }
            if let userPhoneNumber = user["phoneNumber"] as? String{
                phoneNumberTextfield.text = userPhoneNumber
            }
            if user["countryCode"] as? String != ""{
                dialCodeLabel.text = user["countryCode"] as? String ?? "+82"
            }else{
                dialCodeLabel.text = "+82"
            }
       }
                
    }

    //MARK: - Actions
    @IBAction func actionForSave(_ sender: Any) {
        self.view.endEditing(true)
        if fullNameTextfield.text.optionalValue().isEmpty {
            self.showAlert(title: languageStrings[Keys.fullNameRequired] as? String, message: nil,buttonTitles: [languageStrings[Keys.ok]] as? [String])
            return
        }
        else if emailTextfield.text.optionalValue().isEmpty {
            self.showAlert(title: languageStrings[Keys.emailRequired] as? String, message: nil,buttonTitles: [languageStrings[Keys.ok]] as? [String])
            return
        }
        else if phoneNumberTextfield.text.optionalValue().isEmpty {
            self.showAlert(title: languageStrings[Keys.phoneNumberRequired] as? String, message: nil,buttonTitles: [languageStrings[Keys.ok]] as? [String])
            return
        }
        self.showCustomAlert(message: languageStrings[Keys.saveChanges] as? String,cancelButtonTitle: languageStrings[Keys.cancel] as? String,doneButtonTitle: languageStrings[Keys.confirm] as? String, doneCallback:  {
            self.callApi()
        })
    }
    
    @IBAction func actionForBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionForSignOut(_ sender: Any) {
        self.showCustomAlertDelete(title: languageStrings[Keys.logoutConfirm]! as? String, message: languageStrings[Keys.logoutDES] as? String ?? "", cancelButtonTitle: languageStrings[Keys.cancel]! as? String,doneButtonTitle: languageStrings[Keys.logout]! as? String,doneCallback:  {
            self.goToLogin()
            for i in 0..<Store.shared.alarms.count {
                Store.shared.alarms.remove(at: i)
            }
           
            if let controllers =  self.tabBarController?.navigationController?.viewControllers {
                if controllers.contains(where: {
                    return $0 is LandingVC
                }){
                    for vc in controllers {
                        if vc is LandingVC {
                            _ = self.tabBarController?.navigationController?.popToViewController(vc as! LandingVC, animated: true)
                        }
                    }
                } else {
                    self.appDelegate?.navigateToLanding()
                }
            }
        })
    }
    @IBAction func actionForDelete(_ sender: Any) {
        self.showCustomAlertDelete(title:languageStrings[Keys.deleteConfirm]! as? String, message: languageStrings[Keys.deletedDesc]! as? String,cancelButtonTitle: languageStrings[Keys.delete]! as? String,doneButtonTitle: languageStrings[Keys.cancel]! as? String, cancelCallback:  {
            self.callDeleteAccountApi()
        })
    }
    
    @IBAction func countryPickerButtonAction(_ sender: Any) {
        showCountryPicker()
    }
    
    override func pickedCountry(name: String, code: String, dialCode: String) {
        dialCodeLabel.text = dialCode
    }
    
    func getProfileApi () {
        
        self.showProgressBar(message: "")
        
        viewModel.getProfile() { [self] status, message in
            self.hideProgressBar()
            if status {
                Global.saveDataInUserDefaults(value: viewModel.userDict as AnyObject, key: .userData)
                setValues()
            }
          }
    }
    
    func callApi() {
        if !fullNameTextfield.text.optionalValue().isEmpty && !phoneNumberTextfield.text.optionalValue().isEmpty && !emailTextfield.text.optionalValue().isEmpty {
            let diction = ["name": fullNameTextfield.text!, "countryCode": dialCodeLabel.text!, "phoneNumber": phoneNumberTextfield.text!, "email": emailTextfield.text!, "step": ProfileCompletionSteps.step2] as [String : AnyObject]
        
        self.showProgressBar(message: "")
        
        viewModel.userAccountInfo(parameters: diction) { [self] status, message in
            
            self.hideProgressBar()
            
            if status {
                Global.saveDataInUserDefaults(value: viewModel.userDict as AnyObject, key: .userData)
                self.showCustomAlert(message: languageStrings[Keys.changesSaved] as? String,cancelButtonTitle: "",doneButtonTitle: languageStrings[Keys.confirm]! as? String, doneCallback:  {
                   // self.callApi()
                })
            } else {
                self.showAlert(title: (languageStrings[message] as? String), message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
            }
          }
       }
    }
    
    func callDeleteAccountApi() {
        
        self.showProgressBar(message: "")
        
        viewModel.deleteAccount() { [self] status, message in
            
            self.hideProgressBar()
            
            if status {
                self.showCustomAlertDelete(title:languageStrings[Keys.accountDeleted]! as? String, message: languageStrings[Keys.thanksKaily]! as? String,cancelButtonTitle: nil,doneButtonTitle: languageStrings[Keys.confirm]! as? String, doneCallback:  {
                    self.goToLogin()
                    for i in 0..<Store.shared.alarms.count {
                        Store.shared.alarms.remove(at: i)
                    }
                    if let controllers =  self.tabBarController?.navigationController?.viewControllers {
                        if controllers.contains(where: {
                            return $0 is LandingVC
                        }){
                            for vc in controllers {
                                if vc is LandingVC {
                                    _ = self.tabBarController?.navigationController?.popToViewController(vc as! LandingVC, animated: true)
                                }
                            }
                        } else {
                            self.appDelegate?.navigateToLanding()
                        }
                    }
                })
               
            } else {
                self.showAlert(title: "Network error!", message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
            }
        }
    }
    
}

//MARK: - Textfield Delegate
extension MyAccountVC : UITextFieldDelegate {


  
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
      
        if textField == fullNameTextfield {
            guard range.location == 0 else {
                return true
            }

            let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
            return newString.rangeOfCharacter(from: CharacterSet.whitespacesAndNewlines).location != 0
        }
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == fullNameTextfield {
            fullNameTextfield.resignFirstResponder()
            phoneNumberTextfield.becomeFirstResponder()
        }else {
            phoneNumberTextfield.resignFirstResponder()
        }
        return true
    }
}

