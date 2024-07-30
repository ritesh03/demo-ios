//
//  AppDelegate.swift
//  synex
//
//  Created by Ritesh Chopra on 26/09/22.
//

import UIKit
import IQKeyboardManagerSwift
import SideMenuSwift
import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser
import Firebase
import FirebaseCore
import FirebaseMessaging
import MessageUI
import AudioToolbox
import AVFoundation
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate,AVAudioPlayerDelegate, AlarmApplicationDelegate,MessagingDelegate {
    var window: UIWindow?
    var sideMenu: SideMenuController?
    private var audioPlayer: AVAudioPlayer?
    
    private let notificationScheduler: NotificationSchedulerDelegate = NotificationScheduler()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        RunLoop.current.run(until: NSDate(timeIntervalSinceNow:1) as Date)
        
        //Keyboard Manager
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        
        //Initiate Kakao
        KakaoSDK.initSDK(appKey: AppConstants.kakaoAppKey, loggingEnable:true)
        
        //Register Firebase
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        //Register for push notifications
        self.registerNotificationFunction(application: application)
        notificationScheduler.requestAuthorization()
        notificationScheduler.registerNotificationCategories()
        
        return true
    }
    
    //MARK: - Navigate To Home
    func navigateToHome(){
        let homeVC = HomeVC.instantiate(fromAppStoryboard: .Home)
        let sideMenuVC = SideMenuVC.instantiate(fromAppStoryboard: .Home)
        let centerViewController = UINavigationController(rootViewController: homeVC)
        centerViewController.navigationBar.isHidden = true
        sideMenu = SideMenuController(contentViewController: centerViewController, menuViewController: sideMenuVC)
        BaseVC().makeVcToRoot(sideMenu!)
        setSideMenuController()
        
       
        
    }
    
    
    //MARK: - set Side Menu
    func setSideMenuController() {
        SideMenuController.preferences.basic.position = .sideBySide
        SideMenuController.preferences.basic.supportedOrientations = .all
        SideMenuController.preferences.basic.menuWidth = UIScreen.main.bounds.width*0.72
        SideMenuController.preferences.basic.enablePanGesture = false
    }
    
    //MARK: - Navigate To Login
    func navigateToLogin(){
         let loginVC = LoginVC.instantiate(fromAppStoryboard: .Main)
         let centerViewController = UINavigationController(rootViewController: loginVC)
         BaseVC().makeVcToRoot(loginVC)
    }
    
    func navigateToLanding(){
         let landingVC = LandingVC.instantiate(fromAppStoryboard: .Main)
         let centerViewController = UINavigationController(rootViewController: landingVC)
         BaseVC().makeVcToRoot(landingVC)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        return false
    }

}

extension UIApplication {
    static var release: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "x.x"
    }
    static var build: String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "x"
    }
    static var version: String {
        return "\(release).\(build)"
    }
}
extension AppDelegate {
    func applicationDidBecomeActive(_ application: UIApplication) {
        application.applicationIconBadgeNumber = 0
        notificationScheduler.syncAlarmStateWithNotification()
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("getNotifications"), object: nil)

    }
    
    func registerNotificationFunction(application:UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .sound, .alert], completionHandler: {(granted, error) in
                if (granted) {
                    DispatchQueue.main.async(execute: {
                        UIApplication.shared.registerForRemoteNotifications()
                    })
                }else {
                    //Do stuff if unsuccessful...
                }
            })
        } else { //If user is not on iOS 10 use the old methods we've been using
            application.registerUserNotificationSettings(UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil))
            application.registerForRemoteNotifications()
        }
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?){
        UserDefaults.standard.setValue(fcmToken, forKey: "DeviceToken")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
       // let token = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
       // print("Token---\(token)")
       
        //UserDefaults.standard.setValue(token, forKey: "DeviceToken")
        let chars = (deviceToken as NSData).bytes.bindMemory(to: CChar.self, capacity: deviceToken.count)
        var token = ""
        for i in 0..<deviceToken.count {
            token += String(format: "%02.2hhx", arguments: [chars[i]])
        }
        token = Messaging.messaging().fcmToken ?? ""
        UserDefaults.standard.setValue(token, forKey: "DeviceToken")
        print(token )
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func notificationActions(userInfo: [AnyHashable : Any]){
//        if UIApplication.shared.applicationState == .active || UIApplication.shared.applicationState == .background{
//            
//        }else if UIApplication.shared.applicationState == .inactive{
//          
//        }
        let nc = NotificationCenter.default
               nc.post(name: Notification.Name("getNotifications"), object: nil)
    }
    
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let nc = NotificationCenter.default
            nc.post(name: Notification.Name("getNotifications"), object: nil)
        
        //show an alert window
        let alertController = UIAlertController(title: Global.readStrings()[Keys.alarmText] as? String, message: nil, preferredStyle: .alert)
        let userInfo = notification.request.content.userInfo
        guard
            let snoozeEnabled = userInfo["snooze"] as? Bool,
            let soundName = userInfo["soundName"] as? String,
            let uuidStr = userInfo["uuid"] as? String
        else {return}
        
        playSound(soundName)
        //schedule notification for snooze
        if snoozeEnabled {
            let snoozeOption = UIAlertAction(title: "Snooze", style: .default) {
                (action:UIAlertAction) in
                self.audioPlayer?.stop()
                self.notificationScheduler.setNotificationForSnooze(ringtoneName: soundName, snoozeMinute: 9, uuid: uuidStr)
            }
            alertController.addAction(snoozeOption)
        }
        
        let stopOption = UIAlertAction(title: Global.readStrings()[Keys.ok] as? String ?? "", style: .default) {
            (action:UIAlertAction) in
            self.audioPlayer?.stop()
            AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate)
            let alarms = Store.shared.alarms
            if let alarm = alarms.getAlarm(ByUUIDStr: uuidStr) {
                if alarm.repeatWeekdays.isEmpty {
                    alarm.enabled = false
                    alarms.update(alarm)
                }
            }
        }
        
        alertController.addAction(stopOption)
        Global.getTopMostViewController()?.navigationController?.present(alertController, animated: true, completion: nil)
        if #available(iOS 14.0, *) {
            completionHandler(.list)
        } else {
            // Fallback on earlier versions
        }
    }
    
    // The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction. The delegate must be set before the application returns from application:didFinishLaunchingWithOptions:.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        guard
            let soundName = userInfo["soundName"] as? String,
            let uuid = userInfo["uuid"] as? String
        else {return}
        
        switch response.actionIdentifier {
        case Identifier.snoozeActionIdentifier:
            // notification fired when app in background, snooze button clicked
            notificationScheduler.setNotificationForSnooze(ringtoneName: soundName, snoozeMinute: 9, uuid: uuid)
            break
        case Identifier.stopActionIdentifier:
            // notification fired when app in background, ok button clicked
            let alarms = Store.shared.alarms
            if let alarm = alarms.getAlarm(ByUUIDStr: uuid) {
                if alarm.repeatWeekdays.isEmpty {
                    alarm.enabled = false
                    alarms.update(alarm)
                }
            }
            break
        default:
            break
        }
        
        completionHandler()
    }
    
    
    //AlarmApplicationDelegate protocol
    func playSound(_ soundName: String) {
        //vibrate phone first
        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        //set vibrate callback
        AudioServicesAddSystemSoundCompletion(SystemSoundID(kSystemSoundID_Vibrate),nil,
                                              nil,
                                              { (_:SystemSoundID, _:UnsafeMutableRawPointer?) -> Void in
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
        },
                                              nil)
        
        guard let filePath = Bundle.main.path(forResource: soundName, ofType: "mp3") else {fatalError()}
        let url = URL(fileURLWithPath: filePath)
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
        } catch let error as NSError {
            audioPlayer = nil
            print("audioPlayer error \(error.localizedDescription)")
            return
        }
        
        if let player = audioPlayer {
            player.delegate = self
            player.prepareToPlay()
            //negative number means loop infinity
            player.numberOfLoops = -1
            player.play()
        }
    }
    
    //AVAudioPlayerDelegate protocol
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        
    }
}
