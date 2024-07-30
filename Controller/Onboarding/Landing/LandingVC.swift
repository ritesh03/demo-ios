//
//  LandingVC\.swift
//  synex
//
//  Created by Subhash Mehta on 10/03/24.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser


class LandingVC: BaseVC {
    
    //MARK: - getObject method
    class func getObject() -> LandingVC?{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: LandingVC.className) as? LandingVC{
            return controller
        }
        return nil
    }
    @IBOutlet weak var btnForSignInAnotherWay: UIButton!
    @IBOutlet weak var lblForDescription: UILabel!
    @IBOutlet weak var btnForKakao: UIButton!
    @IBOutlet weak var btnForSignUp: UIButton!
    @IBOutlet weak var btnForForgotId: UIButton!
    
    //MARK: - variable
    let viewModel = LoginViewModel()
    var languageStrings = [String:AnyObject]()
    var isTermsAccepted = false
    var appLanguage = Languages.english

    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (Global.getDataFromUserDefaults(.terms) != nil) {
            if let controller = LoginVC.getObject() {
                self.navigationController?.pushViewController(controller, animated: false)
            }
        }
        // Do any additional setup after loading the view.
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        languageStringConvert()
    }
    
    //MARK: - languageConvert
    func languageStringConvert() {
        languageStrings = Global.readStrings()
        lblForDescription.text = languageStrings[Keys.synexDigital]! as? String
        btnForKakao.setTitle(languageStrings[Keys.loginWithKakao] as? String, for: .normal)
        btnForSignInAnotherWay.setTitle(languageStrings[Keys.signInAnotherWay] as? String, for: .normal)
        btnForSignUp.setTitle(languageStrings[Keys.signUpWithEmail] as? String, for: .normal)
        btnForForgotId.setTitle(languageStrings[Keys.forgotYourId] as? String, for: .normal)
  }

    @IBAction func actionForSignInAnotherWay(_ sender: Any) {
        if let controller = LoginVC.getObject() {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    @IBAction func loginForKakao(_ sender: Any) {
      if (AuthApi.hasToken()) {
            UserApi.shared.accessTokenInfo { (accessTokenInfo, error) in
                    if let error = error {
                        if let sdkError = error as? SdkError, sdkError.isInvalidTokenError() == true  {
                            if (UserApi.isKakaoTalkLoginAvailable()) {
                                self.loginWithKakaoTalk()
                            } else {
                                self.loginWithKakaoAccount()
                            }
                        }
                        else {
                            print("\(error.localizedDescription)")
                        }
                    }
                    else {
                        print("accessTokenInfo() success.")
                        print("accessTokenInfo \(accessTokenInfo as Any)")
                        if (UserApi.isKakaoTalkLoginAvailable()) {
                            self.loginWithKakaoTalk()
                        } else {
                            self.loginWithKakaoAccount()
                        }
                    }
                }
        } else
        {
            if (UserApi.isKakaoTalkLoginAvailable()) {
                self.loginWithKakaoTalk()
            } else {
                self.loginWithKakaoAccount()
            }
        }
        
    }
    func loginWithKakaoTalk() {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoTalk() success.")

                // Do something
                self.getUserInfo()
            }
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
        self.showProgressBar(message: "")
        UserApi.shared.me() { [self](user, error) in
            if let error = error {
                print(error)
            }
            else {
//                print("me() success.")
//                print("user ID \(user?.id as Any)")
//                print("user name \(user?.kakaoAccount?.profile?.nickname as Any)")
//                print("user profile image \(user?.kakaoAccount?.profile?.profileImageUrl as Any)")
//                print("user thumbnail image \(user?.kakaoAccount?.profile?.thumbnailImageUrl as Any)")
//                print("user email \(user?.kakaoAccount?.email as Any)")
//                print("user phoneNumber \(user?.kakaoAccount?.phoneNumber as Any)")
//                print("user name \(user?.kakaoAccount?.name as Any)")
//                print("user birthdate \(user?.kakaoAccount?.birthday as Any)")
//                print("user year \(user?.kakaoAccount?.birthyear as Any)")
//                print("user gender \(user?.kakaoAccount?.gender as Any)")
               
                // Do something
                _ = user
                if let kakaoId = user?.id{
                    AppInstance.shared.kakaoId = Int(kakaoId)
                }
                if let userName = user?.kakaoAccount?.name{
                    AppInstance.shared.kakaoUserName = userName
                }
                if let userEmail = user?.kakaoAccount?.email{
                    AppInstance.shared.kakaoUserEmail = userEmail
                }
                if let profileURL = user?.kakaoAccount?.profile?.profileImageUrl{
                    AppInstance.shared.kakaoUserProfileImage = profileURL.absoluteString
                }
                if let thumbnailURL = user?.kakaoAccount?.profile?.thumbnailImageUrl{
                    AppInstance.shared.kakaoUserThumbnailImage = thumbnailURL.absoluteString
                }
                if let userPhoneNumber = user?.kakaoAccount?.phoneNumber{
                    let fullPhoneNumberArr = userPhoneNumber.components(separatedBy: " ")
                    if fullPhoneNumberArr.count > 2 {
                        let countryCode    = fullPhoneNumberArr[0]
                        let phoneNumber = fullPhoneNumberArr[1] + fullPhoneNumberArr[2]
                        AppInstance.shared.kakaoUserCountryCode = countryCode
                        AppInstance.shared.kakaoUserPhoneNumber = phoneNumber
                    }else{
                        AppInstance.shared.kakaoUserPhoneNumber = userPhoneNumber
                    }
                }
                if var userBirthDay = user?.kakaoAccount?.birthday {
                    if userBirthDay.count > 2 {
                        userBirthDay.insert("/", at: userBirthDay.index(userBirthDay.startIndex, offsetBy: 2))
                        AppInstance.shared.kakaoUserDob = userBirthDay
                    }else{
                        AppInstance.shared.kakaoUserDob = userBirthDay
                    }
                }
                
                if let userBirthYear = user?.kakaoAccount?.birthyear {
                    if let userDateMon = AppInstance.shared.kakaoUserDob {
                        let userDob = userDateMon + "/" + userBirthYear
                        AppInstance.shared.kakaoUserDob = userDob.changeFormatKakaoDob()
                    }else{
                        AppInstance.shared.kakaoUserDob = userBirthYear
                    }
                }
                
                if let userGender = user?.kakaoAccount?.gender?.rawValue{
                    AppInstance.shared.kakaoUserGender = userGender
                    print("Gender current \(userGender)")
                }
                if let kakaoId = user?.id{
                    AppInstance.shared.kakaoId = Int(kakaoId)
                }
               
                //API call
                callKakaoLoginApi()
                
            }
        }
    }
    
    func callKakaoLoginApi() {
        
        if AppInstance.shared.kakaoId != nil {
            let params = ["language":appLanguage , "socialId": AppInstance.shared.kakaoId ?? 0 ,"email": AppInstance.shared.kakaoUserEmail ?? "", "signUp": 2, "name": AppInstance.shared.kakaoUserName ?? "","countryCode": AppInstance.shared.kakaoUserCountryCode ?? "", "phoneNumber": AppInstance.shared.kakaoUserPhoneNumber ?? "" , "dateOfBirth": AppInstance.shared.kakaoUserDob ?? "" , "thumbnailImage": AppInstance.shared.kakaoUserThumbnailImage ?? "", "profileImage": AppInstance.shared.kakaoUserProfileImage ?? "" ,"deviceId": UserDefaults.standard.value(forKey: "DeviceToken"), "deviceType": AppConfig.deviceType]
            
            viewModel.kakaoLogin(parameters: params as [String:AnyObject]) { [self] status, message in
                
                self.hideProgressBar()
                
                if status {
                    Global.saveDataInUserDefaults(value: viewModel.userDict as AnyObject, key: .userData)
                    Global.saveDataInUserDefaults(value: viewModel.userDict as AnyObject, key: .accessToken)
                    self.isTermsAccepted = viewModel.userDict["isTermsAccepted"] as? Bool ?? false
                    
                    if isTermsAccepted == true {
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
                        } else {
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
    @IBAction func actionForSignUp(_ sender: Any) {
        let vc = SignUpVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func actionForForgotId(_ sender: Any) {
        let vc = FindMyIdVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
