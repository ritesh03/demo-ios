//
//  UserInformationVC.swift
//  synex
//
//  Created by Ritesh chopra on 04/09/23.
//

import UIKit

class UserInformationVC: BaseVC {
    
    //MARK: - outlets
    //MARK: - getObject method
    class func getObject() -> UserInformationVC?{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: UserInformationVC.className) as? UserInformationVC{
            return controller
        }
        return nil
    }
    
    @IBOutlet weak var confirmButtomTopContraint: NSLayoutConstraint!
    @IBOutlet weak var fullNameTopContraint: NSLayoutConstraint!
    @IBOutlet weak var titleHeightContraint: NSLayoutConstraint!
    @IBOutlet weak var dialCodeLabel: UILabel!
    @IBOutlet weak var dobTextfield: UITextField!
    @IBOutlet weak var phoneNumberTextfield: UITextField!
    @IBOutlet weak var fullNameTextfield: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var dobTitle: UILabel!
    @IBOutlet weak var phoneNumberTitle: UILabel!
    @IBOutlet weak var fullNameTitle: UILabel!
    @IBOutlet weak var userInformationTitle: UILabel!
    
    
    //MARK: - Variable
    let viewModel = LoginViewModel()
    var languageStrings = [String:AnyObject]()
    var comeFromSideMenu = false
    var gender = 1
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButton.backgroundColor = UIColor(hexString: "#DCDFE3")
        confirmButton.isEnabled = false
        [fullNameTextfield, dobTextfield,phoneNumberTextfield].forEach {
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
      setNavigation(title: AppConfig.empty,showBack: comeFromSideMenu ? false : true,showMenuButton: comeFromSideMenu ? true : false)
      languageStringConvert()
      setValues()
   //   getProfileApi ()
        
//      if UIDevice.current.hasNotch {
//          titleHeightContraint.constant = 100
//          fullNameTopContraint.constant = 35
//         // confirmButtomTopContraint.constant = 50
//      }else{
//          //confirmButtomTopContraint.constant = 10
//          fullNameTopContraint.constant = 10
//          titleHeightContraint.constant = 70
//
//      }
}
    @objc func editingChanged(_ textField: UITextField) {
        
        // Trim whitespace and newlines
        textField.text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines)

            guard
              let name = fullNameTextfield.text, !name.isEmpty,
              let dob = dobTextfield.text, !dob.isEmpty,
              let phoneNumber = phoneNumberTextfield.text, !phoneNumber.isEmpty
              else
                {
              return
            }
            // enable okButton if all conditions are met
              self.confirmButton.isEnabled = true
              self.confirmButton.backgroundColor = UIColor.greenColor()
    }
    
    //MARK: - languageConvert
    func languageStringConvert() {
        languageStrings = Global.readStrings()
        userInformationTitle.text = languageStrings[Keys.userInformation] as? String
        fullNameTitle.text = (languageStrings[Keys.fullName] as? String ?? "")
        fullNameTextfield.placeholder = languageStrings[Keys.namePlaceholder] as? String
        phoneNumberTitle.text = (languageStrings[Keys.phoneNumber] as? String ?? "")
      //  phoneNumberTextfield.placeholder = languageStrings[Keys.phoneNumber] as? String
        dobTitle.text = languageStrings[Keys.dob] as? String
       // dobTextfield.placeholder = languageStrings[Keys.dob] as? String
        confirmButton.setTitle(languageStrings[Keys.next] as? String, for: .normal)
  }
  
    func setValues(){
        if  let user = Global.getDataFromUserDefaults(.userData) {
            fullNameTextfield.text = user["name"] as? String
            if user["countryCode"] as? String != ""{
                dialCodeLabel.text = user["countryCode"] as? String ?? "+82"
            }else{
                dialCodeLabel.text = "+82"
            }
            if let userPhoneNumber = user["phoneNumber"] as? String{
                phoneNumberTextfield.text = userPhoneNumber
            }
            if let userDob = user["dateOfBirth"] as? String{
                dobTextfield.text = userDob
            }
       }
                
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
        if fullNameTextfield.text.optionalValue().isEmpty {
            self.showAlert(title: languageStrings[Keys.fullNameRequired] as? String, message: nil,buttonTitles: [languageStrings[Keys.ok]] as? [String])
            return
        }
        else if phoneNumberTextfield.text.optionalValue().isEmpty {
            self.showAlert(title: languageStrings[Keys.phoneNumberRequired] as? String, message: nil,buttonTitles: [languageStrings[Keys.ok]] as? [String])
            return
        }
        self.callApi()
    }
    @IBAction func skipButtonAction(_ sender: UIButton) {
        if comeFromSideMenu {
            self.showCustomAlert(message: languageStrings[Keys.deleteConfirm]! as? String,cancelButtonTitle: languageStrings[Keys.no]! as? String,doneButtonTitle: languageStrings[Keys.yes]! as? String, doneCallback:  {
                self.callDeleteAccountApi()
            })
        } else {
            //appDelegate?.navigateToHome()
            self.redirectToHome()
        }
    }
    
    func getProfileApi () {
        
        self.showProgressBar(message: "")
        
        viewModel.getProfile() { [self] status, message in
            self.hideProgressBar()
            if status {
                Global.saveDataInUserDefaults(value: viewModel.userDict as AnyObject, key: .userData)
            }
          }
    }
    
    func callApi() {
        if !fullNameTextfield.text.optionalValue().isEmpty && !phoneNumberTextfield.text.optionalValue().isEmpty && !dobTextfield.text.optionalValue().isEmpty {
            let newDobStr = dobTextfield.text!.replace(target: ".", withString:"/")
            let diction = ["name": fullNameTextfield.text!, "countryCode": dialCodeLabel.text!, "phoneNumber": phoneNumberTextfield.text!, "dateOfBirth": newDobStr, "step": ProfileCompletionSteps.step1] as [String : AnyObject]
        
        self.showProgressBar(message: "")
        
        viewModel.userInfo(parameters: diction) { [self] status, message in
            
            self.hideProgressBar()
            
            if status {
//                if var dict = Global.getDataFromUserDefaults(.userData) as? [String:AnyObject] {
//                    dict["step"] = ProfileCompletionSteps.step1 as AnyObject
//                    Global.saveDataInUserDefaults(value: viewModel.userDict as AnyObject, key: .userData)
//                    AppInstance.shared.userDict = dict
//                }
                //Global.saveDataInUserDefaults(value: viewModel.userDict as AnyObject, key: .userData)
              //  self.showAlert(title: (languageStrings[Keys.profileSuccess] as? String)!, message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
               // self.showToast((languageStrings[Keys.profileSuccess] as? String)!)
                if let controller = HealthDetailsVC.getObject() {
                    self.navigationController?.pushViewController(controller, animated: true)
                }
               
              // self.appDelegate?.navigateToHome()
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
                self.goToLogin()
            } else {
                self.showAlert(title: "Network error!", message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
            }
        }
    }
    
}

//MARK: - Textfield Delegate
extension UserInformationVC : UITextFieldDelegate {


    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == dobTextfield {
            setDatePicker(textField: textField, datePickerMode: .date, maximunDate: Date(), minimumDate: nil)
        }
    }
  
    
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

extension UserInformationVC:DelegateGetSelectedDate {
    func getSelectedDate(fromDate: String, toDate: String) {
        dobTextfield.text = toDate
    }
}

