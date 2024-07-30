//
//  CustomTabBarController.swift
//  CustomTabBar
//
//  Created by Subhash Mehta
//

import UIKit

class CustomTabBarController: UITabBarController {
    var languageStrings = [String:AnyObject]()
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.isTranslucent = false
        tabBar.tintColor = UIColor.themeColor()
        
        delegate = self
        languageStrings = Global.readStrings()
        createTabBarItems()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh(notification:)), name: NSNotification.Name(rawValue: "refreshLanguage"), object: nil)
    }
    @objc func refresh(notification: NSNotification) {
        //handle appearing of keyboard here
        languageStrings = Global.readStrings()
        tabBar.items?[0].title = languageStrings[Keys.home] as? String ?? ""
        tabBar.items?[1].title = languageStrings[Keys.hospital] as? String ?? ""
        tabBar.items?[3].title = languageStrings[Keys.myRecord] as? String ?? ""
        tabBar.items?[4].title = languageStrings[Keys.more] as? String ?? ""
    }
    func createTabBarItems(){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
       
        if let homeVC = HomeVCNew.getObject() {
            let navigationController = UINavigationController(rootViewController: homeVC)
            navigationController.isNavigationBarHidden = true
            let tab1Title = languageStrings[Keys.home]! as? String
            homeVC.tabBarItem = UITabBarItem(title: tab1Title, image: UIImage(named: "home_new"), selectedImage: UIImage(named: "home_selected"))
            self.setViewControllers([navigationController], animated: false)
        }
        if let hospitalVC = HospitalVC.getObject() {
            let navigationController = UINavigationController(rootViewController: hospitalVC)
            navigationController.isNavigationBarHidden = true
            let tab2Title = languageStrings[Keys.hospital]! as? String
            hospitalVC.tabBarItem =  UITabBarItem(title: tab2Title, image: UIImage(named: "hospital"), selectedImage: UIImage(named: "hospital_s"))
            var array = self.viewControllers
            array?.append(navigationController)
            self.viewControllers = array
        }
        if let dummyVC = storyboard.instantiateViewController(withIdentifier: DummyVC.className) as? DummyVC {
            let navigationController = UINavigationController(rootViewController: dummyVC)
            navigationController.isNavigationBarHidden = true
            dummyVC.tabBarItem =  UITabBarItem(title: "", image: nil, selectedImage: nil)
            var array = self.viewControllers
            array?.append(navigationController)
            self.viewControllers = array
        }
        if let myRecordsVC = MyRecordsVC.getObject() {
            let navigationController = UINavigationController(rootViewController: myRecordsVC)
            navigationController.isNavigationBarHidden = true
            let tab4Title = languageStrings[Keys.myRecord]! as? String
            myRecordsVC.tabBarItem =  UITabBarItem(title: tab4Title, image: UIImage(named: "my_records"), selectedImage: UIImage(named: "my_records_selected"))
            var array = self.viewControllers
            array?.append(navigationController)
            self.viewControllers = array
        }
        if let moreVC = MoreVC.getObject() {
            let navigationController = UINavigationController(rootViewController: moreVC)
            navigationController.isNavigationBarHidden = true
            let tab5Title = languageStrings[Keys.more]! as? String
            moreVC.tabBarItem =  UITabBarItem(title: tab5Title, image: UIImage(named: "more"), selectedImage: UIImage(named: "more_selected"))
            var array = self.viewControllers
            array?.append(navigationController)
            self.viewControllers = array
        }
       
       
     //   guard let homeVC = HomeVCNew.getObject(), let hospitalVC = HospitalVC.getObject(), let myrecordsVC = MyRecordsVC.getObject(), let moreVC = MoreVC.getObject(), let dummyVC = dummyVC else { return }
        
        
        // Create TabBar items
       
        
       
        
      
        
       
        
       
        
        
//        // Assign viewControllers to tabBarController
//        let viewControllers = [homeVC,hospitalVC,dummyVC, myrecordsVC,moreVC]
//        self.setViewControllers(viewControllers, animated: false)
//        
        
        guard let tabBar = self.tabBar as? CustomTabBar else { return }
        
        tabBar.didTapButton = { [unowned self] in
            self.adFunction()
        }
    }
    
    func adFunction() {
        (Global.getTopMostViewController() as? BaseVC)?.addButtonFunction()
    }
}

// MARK: - UITabBarController Delegate
extension CustomTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else {
            return true
        }
        
        // Your middle tab bar item index.
        // In my case it's 1.
        if selectedIndex == 2 {
            return false
        }
        
        return true
    }
}

// MARK: - View Controllers

class DummyVC: UIViewController {
    override func viewDidLoad() {
    }
}
