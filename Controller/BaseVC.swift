//
//  BaseVC.swift
//  synex
//
//  Created by Ritesh chopra on 01/09/23.
//

import UIKit
import SwifterSwift
import NVActivityIndicatorView
import ADCountryPicker
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import AliveCorKitLite

@objc protocol PickerDelegate {
    @objc optional func didSelectDate(date: Date)
}

class BaseVC: UIViewController {
    //MARK: - Variable
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var datePickerView = UIDatePicker()
    var pickerTextfield : UITextField!
    weak var pickerDelegate: PickerDelegate?
    let viewModelHome = HomeViewModel()
    
    var transition:CATransition{
        let transition = CATransition()
        transition.type = CATransitionType.fade
        transition.duration = 0.2
        return transition
    }

//    public var length: Int {
//        return self.characters.count
//    }
//
//    public var isEmail: Bool {
//        let dataDetector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
//        let firstMatch = dataDetector?.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSRange(location: 0, length: length))
//        return (firstMatch?.range.location != NSNotFound && firstMatch?.url?.scheme == "mailto")
//    }
    
    //MARK: - Hide Navigation Bar
    
    func hideNavigationBar() {
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.barStyle = .black
    }
    
    //MARK: - set Navigation bar
    
    func setNavigation(title:String, showBack: Bool = true, showMenuButton:Bool = false,showRightIcon: Bool = false,showRedLine:Bool = false) {
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.barTintColor = .clear
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIColor.clear.as1ptImage(), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.backgroundColor = UIColor.white
        self.navigationController?.navigationBar.shadowImage = UIColor.clear.as1ptImage()

        let titleButton = UIButton(frame: CGRect(x: 0, y:0, width:110, height:30))
            titleButton.titleLabel?.textAlignment = .center
            titleButton.setTitle(title, for: .normal)
            titleButton.isUserInteractionEnabled = false
            titleButton.titleEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 7, right: 0)
        titleButton.setTitleColor(UIColor.black, for: .normal)
              titleButton.titleLabel?.font = UIFont.CustomFont.extraBold.fontWithSize(size: 24)
            titleButton.titleLabel?.adjustsFontSizeToFitWidth = true
            titleButton.titleLabel?.minimumScaleFactor = 0.5
        var redView = UIView()
        redView = UIView(frame: CGRect(x:10, y:5, width:202, height:3))
        redView.backgroundColor = UIColor(named: "buttonColor")
        redView.isHidden = !showRedLine
        titleButton.addSubview(redView)
        self.navigationItem.titleView = titleButton

    
        if showBack {
            self.setBackButton()
        } else {
            self.navigationItem.hidesBackButton = true
        }
        if showMenuButton {
            self.setMenuButton()
            
        }
    }
    
    //MARK: - Back Button
    func setBackButton(){
        let backButton = UIButton()
        backButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
           let origImage = UIImage(named: "ic_back_black")
            backButton.setImage(origImage, for: .normal)
        
        backButton.addTarget(self, action: #selector(self.backButtonAction), for: UIControl.Event.touchUpInside)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem()
        
        leftBarButton.customView = backButton
        self.navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc func backButtonAction() {
        self.view.endEditing(true)
        let backDone = self.navigationController?.popViewController(animated: true)
        if backDone == nil {
            self.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - right Button
    func setRigtButton(icon:String){
        let rightButton = UIButton()
        rightButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        rightButton.setImage(#imageLiteral(resourceName: icon), for: UIControl.State.normal)
        rightButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: 0)
        rightButton.addTarget(self, action: #selector(self.rightButtonAction), for: UIControl.Event.touchUpInside)
        let rightBarButton = UIBarButtonItem()
        
        rightBarButton.customView = rightButton
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc func rightButtonAction() {

    }
    
    //MARK: -  Menu Button
    func setMenuButton() {
        let menuButton = UIButton()
        menuButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    menuButton.setImage(#imageLiteral(resourceName: "menu"), for: UIControl.State.normal)
       
        menuButton.addTarget(self, action: #selector(self.menuButtonAction), for: UIControl.Event.touchUpInside)
        menuButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 4 , bottom: 0, right: 0)
        let leftBarButton = UIBarButtonItem()
        leftBarButton.customView = menuButton
        self.navigationItem.leftBarButtonItem = leftBarButton
    }

    
    @objc  func menuButtonAction(){
        openSideMenu()
        view.endEditing(true)
    }
    
    func openSideMenu(){
        appDelegate?.sideMenu?.revealMenu()
    }

}

extension BaseVC {
    
    //MARK: - Set Root
    func makeVcToRoot(_ vc:UIViewController) {
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.isHidden = true
        UIApplication.shared.windows.first?.layer.add(transition, forKey: kCATransition)
        
        UIApplication.shared.windows.first?.rootViewController = nav
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func navigateToTerms(){
        let vc = TermsConditionVC.instantiate(fromAppStoryboard: .Setting)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func navigatetoUserInfo(){
        let vc = UserInformationVC.instantiate(fromAppStoryboard: .Main)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func goToLogin(){
        kakaoLogout()
        Global.removeDataFromUserDefaults(.userData) //remove user data
        Global.removeDataFromUserDefaults(.accessToken) //remove access token
        Global.removeDataFromUserDefaults(.terms)//remove terms accepted
        AppInstance.shared.kakaoUserGender = nil
       // self.appDelegate?.navigateToLogin()
    }
    
    func kakaoLogout(){
        if (AuthApi.hasToken()) {
            UserApi.shared.logout { _ in
                
            }
        }
    }
    
    func redirectToHome() {
       let storyboard = UIStoryboard(name: "Home", bundle: nil)
       let controller = storyboard.instantiateViewController(withIdentifier: CustomTabBarController.className) as! UITabBarController
        controller.selectedIndex = 0
       self.navigationController?.pushViewController(controller, animated: true)
   }
   
   func launchOnboarding(){
       if let controller = InstructionScreenViewController.getObject() {
           self.navigationController?.pushViewController(controller, animated: true)
       }
   }
   
   func showTerm(navController:UINavigationController)  {
       if let controller = TermVC.getObject(){
           navController.addChild(controller)
           controller.navigationItem.hidesBackButton = true
           controller.view?.frame = (navController.view?.frame)!
           controller.hidesBottomBarWhenPushed = true
           navController.view.window?.addSubview((controller.view)!)
           controller.dismissVCCompletion { result  in
               self.navigationController?.navigationBar.isHidden = true
               self.navigationController?.isNavigationBarHidden = true
               self.redirectToHome()
           }
       }
   }
}
extension BaseVC{
    func addButtonFunction() {
        self.showAddDeviceAlert(navController: self.navigationController ?? UINavigationController())
    }
    
    func showAddDeviceAlert(navController:UINavigationController)  {
        if let controller = CustomAlertViewController.getObject(){
            controller.isSdkViewVisible = true
            navController.addChild(controller)
            controller.navigationItem.hidesBackButton = true
            controller.view?.frame = (navController.view?.frame)!
            controller.hidesBottomBarWhenPushed = true
            navController.view.window?.addSubview((controller.view)!)
            controller.dismissVCCompletion { result  in
                if result != "Cancel" {
                    self.openSDKBase(device: result ?? "")
                }
            }
        }
    }
    func openSDKBase(device:String){
        self.showProgressBar()
        
        let diction = ["bundleId": AppConstants.bundleId as AnyObject, "patientMrn": "" as AnyObject, "teamId": AppConstants.teamId as AnyObject, "partnerId": AppConstants.partnerId as AnyObject]
        viewModelHome.getToken(diction) { status, message in
            if status {
                self.getinitAlivecoreHome(device: device)
            } else {
                self.hideProgressBar()
                // self.showToast(message)
            }
        }
    }
    
    
    func getinitAlivecoreHome(device: String) {
        ACKManager.initWithApiKey(viewModelHome.jwtToken, isDebugMode: true) { error, config in
            if let config = config {
                print(config)
                if Global.getTopMostViewController() is ACKEcgMonitorViewController{
                    return
                }
                DispatchQueue.main.async {
                    var configg = ACKEcgRecordingConfig.init(deviceType: ACKDeviceType.card, leadsConfig: .single, filterType: .enhanced, algorithmPackage: "", error: nil)
                
                    if device == "2"{
                        configg = ACKEcgRecordingConfig.init(deviceType: ACKDeviceType.triangle, leadsConfig: .six, filterType: .enhanced,  algorithmPackage: "", error: nil)
                    }
                    else if device == "3"{
                        configg = ACKEcgRecordingConfig.init(deviceType: ACKDeviceType.mobile, leadsConfig: .single, filterType: .enhanced, algorithmPackage: "", error: nil)
                    }
                
                    Global.saveDataInUserDefaults(value: device as AnyObject, key: .device)
                    if ((configg?.leadsConfig) != nil) {
                        Global.saveDataInUserDefaults(value: configg?.leadsConfig.rawValue as AnyObject, key: .leadConfig)
                    }
                    self.hideProgressBar()
                    if let config1 = configg {
                        if let monitorViewController = ACKEcgMonitorViewController(config: config1, delegate: self) {
                           // monitorViewController.delegate = self
                            let newController = UINavigationController(rootViewController: monitorViewController)
                            newController.modalPresentationStyle = .overFullScreen
                            self.present(newController, animated: true)
                        }
                    }
                }
            } else {
                self.hideProgressBar()
            }
        }
    }
}
//MARK: - ACKEcgMontitor Delegate
extension BaseVC: ACKEcgMonitorDelegate {
 
    func ecgMonitorViewController(_ viewController: ACKEcgMonitorViewController, didChange config: ACKLeadsConfig) {
        Global.saveDataInUserDefaults(value: config.rawValue as AnyObject, key: .leadConfig)
    }
    
    func ecgMonitorViewController(_ viewController: ACKEcgMonitorViewController, didCancelWithError error: ACKError?) {
        print(error?.localizedDescription as Any)
    }
    
    func ecgMonitorViewController(_ viewController: ACKEcgMonitorViewController, didEncounterError error: ACKError?) {
        print(error?.localizedDescription as Any)
    }
    
    func showSettingsButton(in viewController: ACKEcgMonitorViewController) -> Bool {
        return true
    }
    
    func showCancelButton(in viewController: ACKEcgMonitorViewController) -> Bool {
        return true
    }
    func ecgMonitorViewController(_ viewController: ACKEcgMonitorViewController, didPressCancelWith config: ACKEcgRecordingConfig?) {
        Global.getTopMostViewController()?.dismiss(animated: true, completion: {
        })
    }
    
    func ecgMonitorViewController(_ viewController: ACKEcgMonitorViewController, didPressSettingWith config: ACKEcgRecordingConfig?) {
        if let controller = CustomAlertViewController.getObject(){
            controller.isSdkViewVisible = true
            let navController = self.navigationController ?? UINavigationController()
            navController.addChild(controller)
            controller.navigationItem.hidesBackButton = true
            controller.view?.frame = (navController.view?.frame)!
            controller.hidesBottomBarWhenPushed = true
            navController.view.window?.addSubview((controller.view)!)
            controller.dismissVCCompletion { result  in
                if result != "Cancel" {
                    Global.getTopMostViewController()?.dismiss(animated: true, completion: {
                        self.openSDKBase(device: result ?? "")
                    })
                    
                }
            }
        }
//        let alert = UIAlertController(title: "Select Device", message: nil, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "TRIANGLE", style: .default, handler: { _ in
//            
//            Global.getTopMostViewController()?.dismiss(animated: true, completion: {
//                
//                
//                var configg = ACKEcgRecordingConfig.init(deviceType: ACKDeviceType.triangle, leadsConfig: .six, filterType: .enhanced, algorithmPackage: "", error: nil)
//                if Global.getDataFromUserDefaults(.lockMode) != nil {
//                    configg = ACKEcgRecordingConfig.init(deviceType: ACKDeviceType.triangle, leadsConfig: .single, filterType: .enhanced, algorithmPackage: "", error: nil)
//                }
//                Global.saveDataInUserDefaults(value: configg?.deviceType.rawValue as AnyObject, key: .device)
//                Global.saveDataInUserDefaults(value: configg?.leadsConfig.rawValue as AnyObject, key: .leadConfig)
//                if let config1 = configg {
//                    if let monitorViewController = ACKEcgMonitorViewController(config: config1,delegate: self) {
//                        let newController = UINavigationController(rootViewController: monitorViewController)
//                        newController.modalPresentationStyle = .overFullScreen
//                        self.present(newController, animated: true)
//                    }
//                }
//                
//            })
//            
//        }))
//        alert.addAction(UIAlertAction(title: "KARDIA MOBILE", style: .default, handler: { _ in
//            
//            Global.getTopMostViewController()?.dismiss(animated: true, completion: {
//                
//                let configg = ACKEcgRecordingConfig.init(deviceType: ACKDeviceType.mobile, leadsConfig: .single, filterType: .enhanced, algorithmPackage: "", error: nil)
//                Global.saveDataInUserDefaults(value: configg?.deviceType.rawValue as AnyObject, key: .device)
//                Global.saveDataInUserDefaults(value: configg?.leadsConfig.rawValue as AnyObject, key: .leadConfig)
//                if let config1 = configg {
//                    if let monitorViewController = ACKEcgMonitorViewController(config: config1,delegate: self) {
//                        let newController = UINavigationController(rootViewController: monitorViewController)
//                        newController.modalPresentationStyle = .overFullScreen
//                        self.present(newController, animated: true)
//                    }
//                }
//                
//            })
//        }))
//        
//        alert.addAction(UIAlertAction(title: "KARDIA CARD", style: .default, handler: { _ in
//            
//            Global.getTopMostViewController()?.dismiss(animated: true, completion: {
//                
//                let configg = ACKEcgRecordingConfig.init(deviceType: ACKDeviceType.card, leadsConfig: .single, filterType: .enhanced, algorithmPackage: "", error: nil)
//                Global.saveDataInUserDefaults(value: configg?.deviceType.rawValue as AnyObject, key: .device)
//                Global.saveDataInUserDefaults(value: configg?.leadsConfig.rawValue as AnyObject, key: .leadConfig)
//                if let config1 = configg {
//                    if let monitorViewController = ACKEcgMonitorViewController(config: config1,delegate: self) {
//                        let newController = UINavigationController(rootViewController: monitorViewController)
//                        newController.modalPresentationStyle = .overFullScreen
//                        self.present(newController, animated: true)
//                    }
//                }
//                
//            })
//        }))
////        alert.addAction(UIAlertAction(title: languageStrings[Keys.cancel] as? String, style: .destructive, handler: { _ in
////
////        }))
//        Global.getTopMostViewController()?.present(alert, animated: true)
    }
    
    func ecgMonitorViewController(_ viewController: ACKEcgMonitorViewController, didCompleteRecording record: ACKEcgRecord?) {
        Global.getTopMostViewController()?.dismiss(animated: true, completion: {
            if let record = record {
                let recordPreviewVC = RecordDetailVC.instantiate(fromAppStoryboard: .Home)
                    recordPreviewVC.patientId = ""
                    recordPreviewVC.eckRecord = record
                    recordPreviewVC.hidesBottomBarWhenPushed = true
                    //recordPreviewVC.modalPresentationStyle = .overFullScreen
                self.navigationController?.pushViewController(recordPreviewVC, animated: true)
            }
        })
    }
    
//    func ecgPreviewViewController(_ viewController: ACKEcgPreviewViewController, didInvertRecord record: ACKEcgRecord?) {
//        let vc = TermsConditionDetailVC.instantiate(fromAppStoryboard: .Setting)
//        vc.isHome = true
//        vc.titleString = ""
//        vc.modalPresentationStyle = .overFullScreen
//        self.navigationController?.present(vc, animated: true, completion: nil)
//    }
    
//    - (void)ecgPreviewViewController:(ACKEcgPreviewViewController *_Nonnull)viewController didInvertRecord:(ACKEcgRecord *_Nullable)record;
    
}

//MARK: - show Indicator
extension BaseVC:NVActivityIndicatorViewable {
    func showProgressBar(message: String? = nil) {
        DispatchQueue.main.async {
            let size = CGSize(width: 50.0,
                              height: 50.0)
           // let background = Color(hexString: "#21223A")?.withAlphaComponent(0.8)
            let hex = "#21223A"
            let background = UIColor(hexString: hex).withAlphaComponent(0.8)
            self.startAnimating(size, message: message, messageFont: nil, type: .ballClipRotatePulse, color: .white, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: background, textColor: nil, fadeInAnimation: nil)
        }
    }
    
    func hideProgressBar() {
        DispatchQueue.main.async {
            self.stopAnimating()
        }
    }
}

extension BaseVC : ADCountryPickerDelegate{
    

    func showCountryPicker(){
        let picker = ADCountryPicker()
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        self.present(pickerNavigationController, animated: true, completion: nil)
        picker.delegate = self
        picker.showCallingCodes = true
        picker.showFlags = true
        picker.pickerTitle = NormalString.chooseCountry
        picker.defaultCountryCode = "+91"
        picker.alphabetScrollBarTintColor = UIColor.black
        picker.alphabetScrollBarBackgroundColor = UIColor.clear
        picker.closeButtonTintColor = UIColor.black
        picker.font = UIFont.CustomFont.medium.fontWithSize(size: 14)
        picker.flagHeight = 40
        picker.hidesNavigationBarWhenPresentingSearch = true
        picker.searchBarBackgroundColor = UIColor.white
    }
    
    @objc func pickedCountry(name : String , code : String , dialCode : String){
        
    }
    
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        self.pickedCountry(name : name , code : code , dialCode : dialCode)
        self.dismiss(animated: true)
    }
}


extension BaseVC {
    
    //MARK: Custom Date Picker
    
    func setDatePicker(textField: UITextField, datePickerMode: UIDatePicker.Mode = .dateAndTime, maximunDate: Date? = nil, minimumDate: Date? = Date()) {
        textField.inputView = datePickerView
       // textField.text = minimumDate?.string(format: .ymdDate, type: .local)
        pickerTextfield = textField
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        }
        
        datePickerView.datePickerMode = datePickerMode
        datePickerView.timeZone = NSTimeZone.local
        datePickerView.backgroundColor = UIColor.white
        datePickerView.maximumDate = maximunDate
        datePickerView.minimumDate = minimumDate
        datePickerView.locale = Locale(identifier: "en_US_POSIX")
        datePickerView.addTarget(self, action: #selector(self.didDatePickerViewValueChanged(sender:)), for: .valueChanged)
    }
    
    func setPicker(textField: UITextField, datePickerMode: UIDatePicker.Mode = .dateAndTime, maximunDate: Date? = nil, minimumDate: Date? = Date()) {
        textField.inputView = datePickerView
        textField.text = minimumDate?.string(format: .ymdDate, type: .local)
        pickerTextfield = textField
        if #available(iOS 13.4, *) {
            datePickerView.preferredDatePickerStyle = .wheels
        }
        
        datePickerView.datePickerMode = datePickerMode
        datePickerView.timeZone = NSTimeZone.local
        datePickerView.backgroundColor = UIColor.white
        datePickerView.maximumDate = maximunDate
        datePickerView.minimumDate = minimumDate
        datePickerView.locale = Locale(identifier: "en_US_POSIX")
        datePickerView.addTarget(self, action: #selector(self.didDatePickerViewValueChanged(sender:)), for: .valueChanged)
    }
    
    
    @objc func didDatePickerViewValueChanged(sender: UIDatePicker) {
       let selectedDate = sender.date.string(format: .ymdDate, type: .local)
       let newDobStr = selectedDate.replace(target: "/", withString:".")
       pickerTextfield.text = newDobStr
       pickerDelegate?.didSelectDate?(date: sender.date)
    }
}

extension BaseVC {
    //MARK: - Show Alert
    
    func showCustomAlert(title: String? = AppConfig.empty, message: String?,cancelButtonTitle: String? = NormalString.cancel, doneButtonTitle: String? = NormalString.logout,cancelCallback: ButtonAction? = nil,  doneCallback: ButtonAction? = nil) {
        let customAlert = CustomAlert(title: title, message: message, cancelButtonTitle: cancelButtonTitle, doneButtonTitle: doneButtonTitle)

        customAlert.cancelButton.addTarget {
            cancelCallback?()
            customAlert.remove()
        }
        customAlert.doneButton.addTarget {
            doneCallback?()
            customAlert.remove()
        }
        customAlert.show()
    }
    func showCustomAlertDelete(title: String? = AppConfig.empty, message: String?,cancelButtonTitle: String? = NormalString.cancel, doneButtonTitle: String? = NormalString.logout,cancelCallback: ButtonAction? = nil,  doneCallback: ButtonAction? = nil) {
        let customAlert = CustomAlertDelete(title: title, message: message, cancelButtonTitle: cancelButtonTitle, doneButtonTitle: doneButtonTitle)

        customAlert.cancelButton.addTargetDelete {
            cancelCallback?()
            customAlert.remove()
        }
        customAlert.doneButton.addTargetDelete {
            doneCallback?()
            customAlert.remove()
        }
        customAlert.show()
    }
    
    func alert(view: UIViewController, title: String, message: String? = nil, buttonText: String? = nil, handler: (()->Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: buttonText, style: .default, handler: { action in
            handler?()
        })
        alert.addAction(defaultAction)
        DispatchQueue.main.async(execute: {
            view.present(alert, animated: true)
        })
    }
    
    func showToast(_ message: String) {
        self.view.makeToast(NSLocalizedString(message, comment: ""))
    }
}
