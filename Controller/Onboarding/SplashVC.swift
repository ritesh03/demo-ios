//
//  SplashVC.swift
//  synex
//
//  Created by Ritesh chopra on 04/09/23.
//

import UIKit

class SplashVC: BaseVC {
    
    //MARK: - Variable
    let viewModel = LanguageViewModel()
    var languages = [String]()


    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        getLanguagesAPI()

    }
    
    //MARK: - API
    
    func getLanguagesAPI() {
        
        self.showProgressBar(message: AppConfig.empty)
        
        viewModel.getLanguages() { [self] status, message in
            
            self.hideProgressBar()
            
            if status {
                print(viewModel.languages)
                for i in viewModel.languages {
                    let language = i[AppConfig.code] as? String
                    let seperateString = language?.components(separatedBy: "-")
                    
                    languages.append((seperateString?.first)!)
                }
                if Global.getDataFromUserDefaults(.languageChange) != nil  {
                    if let deviceLanguage = Global.getDataFromUserDefaults(.languageChange) as? String {
                        if deviceLanguage == "ko" || deviceLanguage == "en" {
                            if let index = languages.firstIndex(where: { $0.starts(with: ((deviceLanguage))) }) {
                                //let idObj = viewModel.languages[index][AppConfig.id] as! [String : AnyObject]
                                if let selectedLang = viewModel.languages[index][AppConfig.id] as? String{
                                    getLanguageStringsAPI(langId: selectedLang)
                                }
                            }else{
                                let index = languages.firstIndex(where: { $0.starts(with: ((Languages.english))) })
                                if let selectedLang = viewModel.languages[index!][AppConfig.id] as? String{
                                    getLanguageStringsAPI(langId: selectedLang)
                                }
                            }
                        }
                    }
                } else{
                    let deviceLanguage = Locale.preferredLanguages.first?.components(separatedBy: "-")
                    if deviceLanguage?.first == "ko" || deviceLanguage?.first == "en" {
                        if let index = languages.firstIndex(where: { $0.starts(with: ((deviceLanguage?.first)!)) }) {
                            //let idObj = viewModel.languages[index][AppConfig.id] as! [String : AnyObject]
                            if let selectedLang = viewModel.languages[index][AppConfig.id] as? String {
                                getLanguageStringsAPI(langId: selectedLang)
                            }
                        }else{
                            let index = languages.firstIndex(where: { $0.starts(with: ((Languages.english))) })
                            if let selectedLang = viewModel.languages[index!][AppConfig.id] as? String{
                                getLanguageStringsAPI(langId: selectedLang)
                            }
                            
                        }
                    }
                }

            } else {
                self.showAlert(title: message, message: nil)
            }
        }
    }
    
    
    func getLanguageStringsAPI(langId:String) {
        let diction = [AppConfig.id2: langId as AnyObject]
        print(diction)
    
        self.showProgressBar(message: AppConfig.empty)
        
        viewModel.getStrings(parameters: diction) { [self] status, message in
            
            self.hideProgressBar()
            
            if status {
                Global.saveDataInUserDefaults(value: viewModel.languageDict as AnyObject, key: .language)
                if (Global.getDataFromUserDefaults(.terms) != nil) {
                    if let controller = InstructionScreenViewController.getObject() {
                        self.navigationController?.pushViewController(controller, animated: false)
                    }
                } else {
                    self.launchOnboarding()
                }
                
            } else {
                self.showAlert(title: message, message: nil)
            }
        }
    }
}
