//
//  TermsConditionVC.swift
//  synex
//
//  Created by Ritesh chopra on 06/09/23.
//

import UIKit

class TermsConditionVC: BaseVC {
    
    //MARK: - outlets
    
    @IBOutlet weak var consentTitle: UILabel!
    @IBOutlet weak var termsTitle: UILabel!
    @IBOutlet weak var agreeTitle: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var termsConditionLabel: UILabel!
    @IBOutlet weak var marketingTitle: UILabel!
    @IBOutlet weak var btnForTitle: UIButton!
    
    //MARK: - Variable
    let viewModel = LoginViewModel()
    var languageStrings = [String:AnyObject]()
    var comeFromSideMenu = false

    
    //MARK: - view Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        customizeUI()
    }
    
    //MARK: - private Function
    private func customizeUI(){
        languageStringConvert()
      //  setNavigation(title: AppConfig.empty,showBack: comeFromSideMenu ? false : true,showMenuButton: comeFromSideMenu ? true : false)
        if !checkBoxButton.isSelected {
            checkButton.alpha = 0.5
            checkButton.isEnabled = false
        }
        
        //MARK: - languageConvert
        func languageStringConvert() {
            languageStrings = Global.readStrings()
            termsTitle.text = languageStrings[Keys.termsOfUse] as? String
            consentTitle.text = languageStrings[Keys.privacyPolicy] as? String
            marketingTitle.text = languageStrings[Keys.marketingConsent] as? String
            agreeTitle.text = languageStrings[Keys.agreeTitle] as? String
            checkButton.setTitle(languageStrings[Keys.confirm] as? String, for: .normal)
            btnForTitle.setTitle(languageStrings[Keys.termsAndConditions] as? String, for: .normal)
      }
       
    }
    
    //MARK: - Action
    @IBAction func checkButtonAction(_ sender: Any) {
        self.callAPI()
    }
    @IBAction func actionForBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkBoxButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            checkButton.alpha = 1
            checkButton.isEnabled = true
        }else{
            checkButton.alpha = 0.5
            checkButton.isEnabled = false

        }
    }
    
    @IBAction func termsOfServiceButtonAction(_ sender: UIButton) {
        let vc = TermsConditionDetailVC.instantiate(fromAppStoryboard: .Setting)
        vc.isTerms = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func informationSharingAction(_ sender: UIButton) {
        let vc = TermsConditionDetailVC.instantiate(fromAppStoryboard: .Setting)
        vc.isPrivacy = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func actionForMarketing(_ sender: Any) {
        let vc = TermsConditionDetailVC.instantiate(fromAppStoryboard: .Setting)
        vc.isMarketing = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func callAPI(){
        
        let diction = ["isTermsAccepted": true] as [String : AnyObject]
        
        viewModel.acceptTerms(parameters: diction) { [self] status, message in
            
            self.hideProgressBar()
            
            if status {
                let value = 1
                Global.saveDataInUserDefaults(value: value as AnyObject, key: .terms)
                self.navigatetoUserInfo()
            } else {
                self.showAlert(title: (languageStrings[message] as? String) ?? "", message: nil, buttonTitles: [languageStrings[Keys.ok]] as? [String])
            }
          }
    }
}




