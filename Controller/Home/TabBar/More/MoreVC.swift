//
//  MoreVC.swift
//  synex
//
//  Created by Subhash Mehta on 16/03/24.
//

import UIKit
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class MoreVC: BaseVC {
    
    //MARK: - getObject method
    class func getObject() -> MoreVC?{
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: MoreVC.className) as? MoreVC{
            return controller
        }
        return nil
    }
    @IBOutlet weak var btnForBack: UIButton!
    @IBOutlet weak var lblForTitle: UILabel!
    @IBOutlet weak var tblViewMyRecords: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var lblForSubtitle: UILabel!
    @IBOutlet weak var btnForHealthInfo: UIButton!

    var languageStrings = [String:AnyObject]()
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh(notification:)), name: NSNotification.Name(rawValue: "refreshLanguage"), object: nil)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        customizeUI()
    }
    
    private func customizeUI() {
        languageStringConvert()
        setValues()
    }
    @objc func refresh(notification: NSNotification) {
        languageStrings = Global.readStrings()
        if let navVC = self.tabBarController?.viewControllers?[4] as? UINavigationController {
            navVC.popToRootViewController(animated: false)
            navVC.viewControllers.removeAll()
            if let controller = MoreVC.getObject(){
                let tab5Title = languageStrings[Keys.more]! as? String
                controller.tabBarItem =  UITabBarItem(title: tab5Title, image: UIImage(named: "more"), selectedImage: UIImage(named: "more_selected"))
             navVC.viewControllers = [controller]
            }
        }
        
    }
    
    func setValues(){
        let languageString = ""
        if  let user = Global.getDataFromUserDefaults(.userData) {
            if let imageStr = user["thumbnailImage"] as? String, imageStr != ""{
                if let imageUrl = URL(string: imageStr) {
                    self.userImage.load(url: imageUrl)
                }
            }
            if let name = user["name"] as? String, name != ""{
                let languageString = ""
                if languageString.getLanguage() == "en"{
                    userName.text = "\(name),"
                }else {
                    userName.text = "\(name) " + String(languageStrings[Keys.sir] as? String ?? "")
                }
            }
            
            if let dob = user["dateOfBirth"] as? String, dob != ""{
                let newDobStr = dob.replace(target: "/", withString:".")
                if languageString.getLanguage() == "ko"{
                    if user["gender"] as? Int == 2 {
                        lblForSubtitle.text = "\(newDobStr) (\(languageStrings[Keys.female] as? String ?? ""))"
                    } else {
                        lblForSubtitle.text = "\(newDobStr) (\(languageStrings[Keys.male] as? String ?? ""))"
                    }
                } else {
                    if user["gender"] as? Int == 2 {
                        lblForSubtitle.text = "\(newDobStr) (F)"
                    } else {
                        lblForSubtitle.text = "\(newDobStr) (M)"
                    }
                }
            }
           
        }
    }
    
    //MARK: - languageConvert
    func languageStringConvert() {
        languageStrings = Global.readStrings()
        btnForBack.setTitle(languageStrings[Keys.more] as? String, for: .normal)
        btnForHealthInfo.setTitle(languageStrings[Keys.healthInformation] as? String, for: .normal)
    }

    @IBAction func actionForHealthInfo(_ sender: Any) {
        if let controller = HealthInfoVC.getObject() {
            controller.modalPresentationStyle = .fullScreen
            self.navigationController?.present(controller, animated: true, completion: nil)
        }
       
    }
    
    func linkWithKakao(){
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
                // Do something
                _ = user
                if let kakaoId = user?.id{
                    AppInstance.shared.kakaoId = Int(kakaoId)
                }
                if let kakaoName = user?.kakaoAccount?.profile?.nickname{
                    AppInstance.shared.kakaoUserName = kakaoName
                }
                if let kakaoEmail = user?.kakaoAccount?.email{
                    AppInstance.shared.kakaoUserEmail = kakaoEmail
                }
                if let profileURL = user?.kakaoAccount?.profile?.profileImageUrl{
                    AppInstance.shared.kakaoUserProfileImage = profileURL.absoluteString
                }
                if let thumbnailURL = user?.kakaoAccount?.profile?.thumbnailImageUrl{
                    AppInstance.shared.kakaoUserThumbnailImage = thumbnailURL.absoluteString
                }
               
                //API call
                callKakaoLoginApi()
                
            }
        }
    }
    
    func callKakaoLoginApi () {
        
        if AppInstance.shared.kakaoId != nil {
            var userId = ""
            if let user = Global.getDataFromUserDefaults(.userData){
                userId = user["_id"] as? String ?? ""
            }
                   
            let diction = ["userId":userId, "socialId":AppInstance.shared.kakaoId ?? "","email": AppInstance.shared.kakaoUserEmail ?? "","thumbnailImage": AppInstance.shared.kakaoUserThumbnailImage as AnyObject, "profileImage": AppInstance.shared.kakaoUserProfileImage as AnyObject,  "name": AppInstance.shared.kakaoUserName ?? ""] as [String : AnyObject]
            
            //self.showProgressBar(message: "")
            
            viewModel.kakaoLogin(parameters: diction) { [self] status, message in
                
                self.hideProgressBar()
                self.showAlert(title: (languageStrings[message] as? String), message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
//                if status {
//                    Global.saveDataInUserDefaults(value: viewModel.userDict as AnyObject, key: .userData)
//                    Global.saveDataInUserDefaults(value: viewModel.userDict as AnyObject, key: .accessToken)
//                } else {
//                    self.showAlert(title: (languageStrings[message] as? String), message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
//                }
            }
        }
    }
}
extension MoreVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 2
        case 2:
            return 6
        default:
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tblViewMyRecords.dequeueReusableCell(withIdentifier: MoreTVC.className, for: indexPath) as! MoreTVC
        cell.selectionStyle = .none
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let row1Title = languageStrings[Keys.myAccount]! as? String
                cell.btnForTitle.setTitle(row1Title, for: .normal)
                cell.btnForTitle.setImage(UIImage(named: "user_new"), for: .normal)
            case 1:
                let row2Title = languageStrings[Keys.changePassword]! as? String
                cell.btnForTitle.setTitle(row2Title, for: .normal)
                cell.btnForTitle.setImage(UIImage(named: "ic_password"), for: .normal)
            default:
                let row3Title = languageStrings[Keys.linkToKakao]! as? String
                cell.btnForTitle.setTitle(row3Title, for: .normal)
                cell.btnForTitle.setImage(UIImage(named: "ic_kakao"), for: .normal)
            }
        case 1:
            switch indexPath.row {
            case 0:
                let row1Title = languageStrings[Keys.reminder]! as? String
                cell.btnForTitle.setTitle(row1Title, for: .normal)
                cell.btnForTitle.setImage(UIImage(named: "ic_reminder"), for: .normal)
            default:
                let row2Title = languageStrings[Keys.lang]! as? String
                cell.btnForTitle.setTitle(row2Title, for: .normal)
                cell.btnForTitle.setImage(UIImage(named: "ic_lang"), for: .normal)
            }
        case 2:
            switch indexPath.row {
            case 0:
                let row1Title = languageStrings[Keys.notice]! as? String
                cell.btnForTitle.setTitle(row1Title, for: .normal)
                cell.btnForTitle.setImage(UIImage(named: "ic_notice"), for: .normal)
            case 1:
                let row2Title = languageStrings[Keys.faq]! as? String
                cell.btnForTitle.setTitle(row2Title, for: .normal)
                cell.btnForTitle.setImage(UIImage(named: "ic_faq"), for: .normal)
            case 2:
                let row3Title = languageStrings[Keys.customerService]! as? String
                cell.btnForTitle.setTitle(row3Title, for: .normal)
                cell.btnForTitle.setImage(UIImage(named: "ic_customer"), for: .normal)
            case 3:
                let row4Title = languageStrings[Keys.termsAndConditions]! as? String
                cell.btnForTitle.setTitle(row4Title, for: .normal)
                cell.btnForTitle.setImage(UIImage(named: "ic_terms"), for: .normal)
            case 4:
                let row5Title = languageStrings[Keys.medicalDeviceLabel]! as? String
                cell.btnForTitle.setTitle(row5Title, for: .normal)
                cell.btnForTitle.setImage(UIImage(named: "ic_medical"), for: .normal)
            default:
                let row5Title = languageStrings[Keys.appVersionStatus]! as? String
                cell.btnForTitle.setTitle(row5Title, for: .normal)
                cell.btnForTitle.setImage(UIImage(named: "ic_version"), for: .normal)
            }
        default:
            let row1Title = languageStrings[Keys.kardiaMobile] as? String ?? ""
            cell.btnForTitle.setTitle(row1Title, for: .normal)
            cell.btnForTitle.setImage(UIImage(named: "ic_kardia"), for: .normal)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 54
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tblViewMyRecords.dequeueReusableCell(withIdentifier: MoreHeaderTVC.className) as! MoreHeaderTVC
        switch section {
        case 0:
            let section1Title = languageStrings[Keys.account]! as? String
            cell.btnForTitle.setTitle(section1Title, for: .normal)
        case 1:
            let section2Title = languageStrings[Keys.setting]! as? String
            cell.btnForTitle.setTitle(section2Title, for: .normal)
        case 2:
            let section3Title = languageStrings[Keys.support]! as? String
            cell.btnForTitle.setTitle(section3Title, for: .normal)
        default:
            let section4Title = languageStrings[Keys.website]! as? String
            cell.btnForTitle.setTitle(section4Title, for: .normal)
        }
        
        return cell.contentView
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                if let controller = MyAccountVC.getObject() {
                    controller.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            case 1:
                let vc = ChangePasswordVC.instantiate(fromAppStoryboard: .Main)
                vc.hidesBottomBarWhenPushed = true
                vc.comeFromSideMenu = false
                self.navigationController?.pushViewController(vc, animated: true)
                break
                
            default:
                self.linkWithKakao()
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                if let controller = ReminderVC.getObject() {
                    controller.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            default:
                if let controller = LanguageVC.getObject() {
                    controller.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        case 2:
            switch indexPath.row {
            case 0:
                if let controller = WebViewController.getObject() {
                    controller.hidesBottomBarWhenPushed = true
                    controller.url = UrlConfig.NOTICE
                    controller.titleString =  languageStrings[Keys.notice]! as? String ?? ""
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            case 1:
                if let controller = WebViewController.getObject() {
                    controller.hidesBottomBarWhenPushed = true
                    controller.url = UrlConfig.FAQ
                    controller.titleString =  languageStrings[Keys.faq]! as? String ?? ""
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            case 2:
                if let controller = WebViewController.getObject() {
                    controller.hidesBottomBarWhenPushed = true
                    controller.url = UrlConfig.CUSTOMER_SERVICE
                    controller.titleString =  languageStrings[Keys.customerService]! as? String ?? ""
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            case 3:
                let vc = TermsConditionVC.instantiate(fromAppStoryboard: .Setting)
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            case 4:
                let vc = TermsConditionDetailVC.instantiate(fromAppStoryboard: .Setting)
                vc.isMedical = true
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                if let controller = AppVersionVC.getObject() {
                    controller.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            }
        default:
            if let controller = WebViewController.getObject() {
                controller.hidesBottomBarWhenPushed = true
                controller.url = UrlConfig.WEBSITE
                controller.titleString =  languageStrings[Keys.kardiaMobile]! as? String ?? ""
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}

