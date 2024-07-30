//
//  NotificationVC.swift
//  synex
//
//  Created by Subhash Mehta on 02/04/24.
//

import UIKit

class LanguageVC: BaseVC {
    //MARK: - getObject method
    class func getObject() -> LanguageVC?{
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: LanguageVC.className) as? LanguageVC{
            return controller
        }
        return nil
    }
    @IBOutlet weak var tableView: UITableView!
    let viewModel = LanguageViewModel()
    var selectedLangObj = [String:AnyObject]()
    var selectedLang = ""
    var arrForTitles = ["한국어","English"]
    var languages = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        //API call
        getLanguagesAPI()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func actionForBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func getLanguagesAPI() {
        
       // self.showProgressBar(message: "")
        
        viewModel.getLanguages() { [self] status, message in
            
           // self.hideProgressBar()
            
            if status {
                for i in viewModel.languages {
                    let language = i[AppConfig.code] as? String
                    let seperateString = language?.components(separatedBy: "-")
                    
                    languages.append((seperateString?.first ?? ""))
                }
                print(viewModel.languages)
                tableView.reloadData()
            } else {
                self.showAlert(title: message, message: nil)
            }
          }
    }
    
    func getLanguageStringsAPI(langId:String) {
        let diction = ["id": langId as AnyObject]
        print(diction)
    
        self.showProgressBar(message: "")
        
        viewModel.getStrings(parameters: diction) { [self] status, message in
            
            self.hideProgressBar()
            
            if status {
                Global.saveDataInUserDefaults(value: viewModel.languageDict as AnyObject, key: .language)
                NotificationCenter.default.post(name:NSNotification.Name(rawValue: "refreshLanguage"), object: nil, userInfo: nil)
             //   Global.saveDataInUserDefaults(value: langId as AnyObject, key: .language)
                self.navigationController?.popViewController(animated: true)
            } else {
                self.showAlert(title: message, message: nil)
            }
        }
        
    }
    @objc func actionSubmit(_ sender: UIButton) {
        if sender.tag == 0 {
            if let index = languages.firstIndex(where: { $0.starts(with: ((Languages.korean))) }) {
                let selectedLang = viewModel.languages[index][AppConfig.id] as? String ?? ""
                getLanguageStringsAPI(langId: selectedLang)
                Global.saveDataInUserDefaults(value: Languages.korean as AnyObject, key: .languageChange)
            }
            
           
        }else {
            if let index = languages.firstIndex(where: { $0.starts(with: ((Languages.english))) }) {
                let selectedLang = viewModel.languages[index][AppConfig.id] as? String ?? ""
                getLanguageStringsAPI(langId: selectedLang)
                Global.saveDataInUserDefaults(value: Languages.english as AnyObject, key: .languageChange)
            }
        }
    }

    

}
extension LanguageVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LanguageTVC.className, for: indexPath) as! LanguageTVC
        cell.selectionStyle = .none
        cell.lblForTitle.text = arrForTitles[indexPath.row]
        cell.btnForSelect.tag = indexPath.row
        if indexPath.row == 0 {
            cell.btnForSelect.isSelected = false
            if Global.getDataFromUserDefaults(.languageChange) != nil {
                if Global.getDataFromUserDefaults(.languageChange) as? String ?? "" == Languages.korean {
                    cell.btnForSelect.isSelected = true
                }
            } else {
                let deviceLanguage = Locale.preferredLanguages.first?.components(separatedBy: "-")
                
                if deviceLanguage?.first == "ko" {
                    cell.btnForSelect.isSelected = true
                }
            }
        } else {
            cell.btnForSelect.isSelected = false
            if Global.getDataFromUserDefaults(.languageChange) != nil {
                if Global.getDataFromUserDefaults(.languageChange) as? String ?? "" == Languages.english {
                    cell.btnForSelect.isSelected = true
                }
            } else {
                let deviceLanguage = Locale.preferredLanguages.first?.components(separatedBy: "-")
                
                if deviceLanguage?.first == "en" {
                    cell.btnForSelect.isSelected = true
                }
            }
        }
        
        cell.btnForSelect.addTarget(self, action: #selector(actionSubmit(_:)), for: .touchUpInside)
        return cell
    }
}
