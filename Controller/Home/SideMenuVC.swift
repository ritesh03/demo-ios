//
//  SideMenuVC.swift
//  synex
//
//  Created by Ritesh chopra on 06/09/23.
//

import UIKit

class SideMenuVC: BaseVC {
   
    //MARK: - Outlets
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variable
    let viewModel = LoginViewModel()
    var languageStrings = [String:AnyObject]()
    var sideMenuItem = [String]()

    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customizeUI()
    }
    
    //MARK: - Private function
    private func customizeUI() {
        languageStringConvert()
    }
    
    
    //MARK: - languageConvert
    func languageStringConvert() {
        languageStrings = Global.readStrings()
        let versionNumber = UIApplication.release
        versionLabel.text = (languageStrings[Keys.version] as? String ?? "Version") + " " + versionNumber
      
//        sideMenuItem.append()
//        homeTitleLabel.append(languageStrings[Keys.bloodPressureTitle] as? String ?? AppConfig.empty)
//        homeTitleLabel.append(languageStrings[Keys.restingTitle] as? String ?? AppConfig.empty)
//        homeTitleLabel.append(languageStrings[Keys.weightTitle] as? String ?? AppConfig.empty)
//        homeTitleLabel.append(languageStrings[Keys.medicationTitle] as? String ?? AppConfig.empty)
    }
}

//MARK: - TableView Delegate
extension SideMenuVC:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SideMenuArray.sideMenuItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:SideMenuCell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier.sideMenuCell) as! SideMenuCell
        if indexPath.row == SideMenuArray.sideMenuItem.count - 1 || indexPath.row == SideMenuArray.sideMenuItem.count - 2 {
            cell.forwardImage.isHidden = true
        }
        if indexPath.row == SideMenuArray.sideMenuItem.count - 1 {
            cell.titleLabel.textColor = UIColor(named: "red")
        }
        
        switch indexPath.row {
            
        case 0:
            cell.titleLabel.text = languageStrings[Keys.home]! as? String
        case 1:
            cell.titleLabel.text = languageStrings[Keys.sideMenuUserInfo]! as? String
        case 2:
            cell.titleLabel.text = languageStrings[Keys.history]! as? String
        case 3:
            cell.titleLabel.text = languageStrings[Keys.changePassword]! as? String
        case 4:
            cell.titleLabel.text = languageStrings[Keys.logout]! as? String
//        case 5:
//            cell.titleLabel.text = languageStrings[Keys.deleteAccount]! as? String
        default:
            break
        }
        
       return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        switch indexPath.row {
            
        case 0:
            let vc = HomeVC.instantiate(fromAppStoryboard: .Home)
            let navVc = UINavigationController(rootViewController: vc)
            navVc.navigationBar.isHidden = true
            appDelegate?.sideMenu?.setContentViewController(to: navVc)
            break;
            
        case 1:
            let vc = UserInformationVC.instantiate(fromAppStoryboard: .Main)
            vc.comeFromSideMenu = true
            let navVc = UINavigationController(rootViewController: vc)
            navVc.navigationBar.isHidden = true
            appDelegate?.sideMenu?.setContentViewController(to: navVc)
            break;
            
        case 2:
            let vc = HistoryVC.instantiate(fromAppStoryboard: .Home)
            vc.comeFromSideMenu = true
            let navVc = UINavigationController(rootViewController: vc)
            navVc.navigationBar.isHidden = true
            appDelegate?.sideMenu?.setContentViewController(to: navVc)
            break
            
        case 3:
            let vc = ChangePasswordVC.instantiate(fromAppStoryboard: .Main)
            vc.comeFromSideMenu = true
            let navVc = UINavigationController(rootViewController: vc)
            navVc.navigationBar.isHidden = true
            appDelegate?.sideMenu?.setContentViewController(to: navVc)
            break
         
        case 4:
            self.showCustomAlert(message: languageStrings[Keys.logoutConfirm]! as? String, cancelButtonTitle: languageStrings[Keys.cancel]! as? String,doneButtonTitle: languageStrings[Keys.logout]! as? String,doneCallback:  {
                self.goToLogin()
            })
            break
            
//        case 5:
//            self.showCustomAlert(message: languageStrings[Keys.deleteConfirm]! as? String,cancelButtonTitle: languageStrings[Keys.no]! as? String,doneButtonTitle: languageStrings[Keys.yes]! as? String, doneCallback:  {
//                self.callDeleteAccountApi()
//            })
//            break
            
        default:
            break;
        }
       
        sideMenuController?.hideMenu()
        
    }
    
//    func callDeleteAccountApi() {
//        
//        self.showProgressBar(message: "")
//        
//        viewModel.deleteAccount() { [self] status, message in
//            
//            self.hideProgressBar()
//            
//            if status {
//                self.goToLogin()
//            } else {
//                self.showAlert(title: "Network error!", message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
//            }
//        }
//    }
    
//    func goToLogin(){
//        Global.removeDataFromUserDefaults(.userData) //remove user data
//        Global.removeDataFromUserDefaults(.accessToken) //remove access token
//        Global.removeDataFromUserDefaults(.terms)
//        //remove terms accepted
//        self.appDelegate?.navigateToLogin()
//    }
}

