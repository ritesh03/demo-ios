//
//  LoginVC.swift
//  synex
//
//  Created by Ritesh chopra on 01/09/23.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser


class LoginVC: BaseVC {
    
    //MARK: - getObject method
    class func getObject() -> LoginVC?{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: LoginVC.className) as? LoginVC{
            return controller
        }
        return nil
    }

    //MARK: - Outlets
    
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var findMyIdButton: UIButton!
    @IBOutlet weak var passwordTitle: UILabel!
    @IBOutlet weak var emailTitle: UILabel!
    @IBOutlet weak var passEyeBtn: UIButton!
    
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passTextfield: UITextField!
    
    //MARK: - variable
    let viewModel = LoginViewModel()
    var languageStrings = [String:AnyObject]()
    var isTermsAccepted = false
    var appLanguage = Languages.english
    var kakaoUserId = 0
    
    //MARK: -  View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if (Global.getDataFromUserDefaults(.terms) != nil) {
            let storyboard = UIStoryboard(name: "Home", bundle: nil)
            let controller = storyboard.instantiateViewController(withIdentifier: CustomTabBarController.className) as! UITabBarController
             controller.selectedIndex = 0
            self.navigationController?.pushViewController(controller, animated: false)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customizeUI()
        kakaoLogout()//Required if user go back without completing the signup
    }
    
    //MARK: - private function
    private func customizeUI() {
        hideNavigationBar()
        passEyeBtn.tintColor = UIColor(hexString: "#CCD1D3")
        languageStringConvert()
    }
    
    //MARK: - languageConvert
    func languageStringConvert() {
        languageStrings = Global.readStrings()
      //  loginTitle.text = languageStrings[Keys.synexDigital]! as? String
        emailTitle.text = languageStrings[Keys.enterEmailAddress] as? String
        emailTextfield.placeholder = languageStrings[Keys.emailAddress] as? String
        passwordTitle.text = languageStrings[Keys.password] as? String
        passTextfield.placeholder = languageStrings[Keys.password] as? String
        findMyIdButton.setTitle(languageStrings[Keys.findId] as? String, for: .normal)
        forgotPassword.setTitle(languageStrings[Keys.forgotPassword] as? String, for: .normal)
        loginButton.setTitle(languageStrings[Keys.login] as? String, for: .normal)

  }
    
    //MARK: -  Actions
    @IBAction func loginButtonAction(_ sender: UIButton) {
        self.view.endEditing(true)
        if emailTextfield.text.optionalValue().isEmpty {
            self.showAlert(title: languageStrings[Keys.emailRequired] as? String, message: nil,buttonTitles: [languageStrings[Keys.ok]] as? [String])
            return
        }
        else if !emailTextfield.text!.isValidEmail() {
            self.showAlert(title: languageStrings[Keys.invalidEmail] as? String, message: nil,buttonTitles: [languageStrings[Keys.ok]] as? [String])
            return
        }
        else if passTextfield.text.optionalValue().isEmpty {
            self.showAlert(title: languageStrings[Keys.passwordRequired] as? String, message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
            return
        }

        //API call
        callLoginApi ()
    }
    
    @IBAction func actionForBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func loginWithKakaoButtonAction(_ sender: Any) {
        if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (accessTokenInfo, error) in
                    if let error = error {
                        if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                            self.loginWithKakaoAccount()
                        }
                        else {
                            print("\(error.localizedDescription)")
                        }
                    }
                    else {
                        print("accessTokenInfo() success.")
                        print("accessTokenInfo \(accessTokenInfo as Any)")
                    }
                }
        } else 
        {
            self.loginWithKakaoAccount()
        }
        
    }
 
    func loginWithKakaoAccount() {
        UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print(oauthToken as Any)
                self.getUserInfo()
            }
        }
    }
    
    func getUserInfo() {
        UserApi.shared.me() { [self](user, error) in
            if let error = error {
                print(error)
            }
            else {
//                print("me() success.")
//                print("user ID \(user?.id as Any)")
//                print("user name \(user?.kakaoAccount?.profile?.nickname as Any)")
//                print("user email \(user?.kakaoAccount?.email as Any)")
//                print("user phoneNumber \(user?.kakaoAccount?.phoneNumber as Any)")
                // Do something
                _ = user
                self.kakaoUserId = Int((user?.id ?? 0))
               
                //API call
                callKakaoLoginApi()
                
            }
        }
    }
    @IBAction func passwordHideAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            passTextfield.isSecureTextEntry = false
            passEyeBtn.tintColor = UIColor(hexString: "#FF9160")
        }else{
            passTextfield.isSecureTextEntry = true
            passEyeBtn.tintColor = UIColor(hexString: "#CCD1D3")

        }
    }
    
    
    @IBAction func signUpButtonAction(_ sender: UIButton) {
        let vc = SignUpVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func forgotButtonAction(_ sender: UIButton) {
        let vc = ForgotPasswordVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func findMyIdButtonAction(_ sender: UIButton) {
        let vc = FindMyIdVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func callLoginApi () {
        if !emailTextfield.text.optionalValue().isEmpty && !passTextfield.text.optionalValue().isEmpty {
            let diction = ["email": emailTextfield.text!, "password": passTextfield.text as AnyObject, "deviceId":UserDefaults.standard.value(forKey: "DeviceToken") ?? "","deviceType":AppConfig.deviceType] as [String : AnyObject]
        
        self.showProgressBar(message: "")
        
        viewModel.userLogin(parameters: diction) { [self] status, message in
            
            self.hideProgressBar()
            
            if status {
                Global.saveDataInUserDefaults(value: viewModel.userDict as AnyObject, key: .userData)
                Global.saveDataInUserDefaults(value: viewModel.userDict as AnyObject, key: .accessToken)
                let isTempPassword = viewModel.userDict["isTempPassword"] as! Bool
                if isTempPassword == true {
                    self.navigateToResetPassword()
                }
                else if AppInstance.shared.isTermsAccepted == true {
                        Global.saveDataInUserDefaults(bool: self.isTermsAccepted as AnyObject, key: .terms)
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
            } else {
                self.showAlert(title: (languageStrings[message] as? String)!, message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
            }
          }
       }
    }
   
    func callKakaoLoginApi () {
        
        if kakaoUserId != 0 {
            let diction = ["language":appLanguage.getLanguage(), "socialId":kakaoUserId,"email": "", "signUp": 2,"countryCode": "", "phoneNumber": "",  "name": ""] as [String : AnyObject]
            
            self.showProgressBar(message: "")
            
            viewModel.kakaoLogin(parameters: diction) { [self] status, message in
                
                self.hideProgressBar()
                
                if status {
                    Global.saveDataInUserDefaults(value: viewModel.userDict as AnyObject, key: .userData)
                    Global.saveDataInUserDefaults(value: viewModel.userDict as AnyObject, key: .accessToken)
                    if AppInstance.shared.isTermsAccepted == true {
                            Global.saveDataInUserDefaults(bool: self.isTermsAccepted as AnyObject, key: .terms)
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
                } else {
                    self.showAlert(title: (languageStrings[message] as? String), message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
                }
            }
        }
    }
    
    func navigateToResetPassword(){
        let vc = ChangePasswordVC.instantiate(fromAppStoryboard: .Main)
        vc.isReset = true
        vc.comeFromSideMenu = false
        vc.termsStatus = self.isTermsAccepted
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - Textfield Delegate
extension LoginVC : UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
      
        if string == AppConfig.empty2 {
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextfield {
            emailTextfield.resignFirstResponder()
            passTextfield.becomeFirstResponder()
        }else{
            passTextfield.resignFirstResponder()

        }
        return true
    }
}
