//
//  NotificationVC.swift
//  synex
//
//  Created by Subhash Mehta on 02/04/24.
//

import UIKit

class AppVersionVC: BaseVC {
    //MARK: - getObject method
    class func getObject() -> AppVersionVC?{
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        if let controller = storyboard.instantiateViewController(withIdentifier: AppVersionVC.className) as? AppVersionVC{
            return controller
        }
        return nil
    }
    
    @IBOutlet weak var btnForTitle: UIButton!
    @IBOutlet weak var lblForVersionInfo: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var languageStrings = [String:AnyObject]()
    
    enum VersionError: Error {
        case invalidResponse, invalidBundleInfo
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        languageStringConvert()
    }
    
    //MARK: - languageConvert
    func languageStringConvert() {
        languageStrings = Global.readStrings()
        btnForTitle.setTitle(languageStrings[Keys.appVersionStatus] as? String, for: .normal)
        lblForVersionInfo.text = languageStrings[Keys.version] as? String
     
    }
    
    @IBAction func actionForBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

    func checkForUpdate(completion:@escaping(Bool)->()){

        guard let bundleInfo = Bundle.main.infoDictionary,
            let currentVersion = bundleInfo["CFBundleShortVersionString"] as? String,
            let identifier = bundleInfo["CFBundleIdentifier"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)")
            else{
            print("some thing wrong")
                completion(false)
            return
           }

        let task = URLSession.shared.dataTask(with: url) {
            (data, resopnse, error) in
            if error != nil{
                 completion(false)
                print("something went wrong")
            }else{
                do{
                    guard let reponseJson = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String:Any],
                    let result = (reponseJson["results"] as? [Any])?.first as? [String: Any],
                    let version = result["version"] as? String
                    else{
                         completion(false)
                        return
                    }
                    print("Current Ver:\(currentVersion)")
                    print("Prev version:\(version)")
                    if currentVersion != version{
                        completion(true)
                    }else{
                        completion(false)
                    }
                }
                catch{
                     completion(false)
                    print("Something went wrong")
                }
            }
        }
        task.resume()
    }
    
    @objc func updateButtonAction(sender:UIButton){
        let appURL = URL(string: appStore.appStoreLink)!
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(appURL)
        } else {
            UIApplication.shared.openURL(appURL)
        }
    }
}
extension AppVersionVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationTVC.className, for: indexPath) as! NotificationTVC
        cell.selectionStyle = .none
        cell.lblForName.text = languageStrings[Keys.kaily] as? String
        let versionNumber = UIApplication.release
        cell.lblForSubTitle.text =  "v" + versionNumber
        cell.btnForUpdate.addTarget(self, action: #selector(updateButtonAction), for: .touchUpInside)
        
        checkForUpdate { (isUpdate) in
                print("Update needed:\(isUpdate)")
            DispatchQueue.main.async {
                if isUpdate{
                        print("new update Available")
                    cell.btnForUpdate.isUserInteractionEnabled = true
                }else{
                    cell.btnForUpdate.isUserInteractionEnabled = false
                    cell.btnForUpdate.setTitle(self.languageStrings[Keys.latestVersion] as? String, for: .normal)
                    cell.btnForUpdate.backgroundColor = .clear
                    cell.btnForUpdate.setTitleColor(UIColor.darkGray, for: .normal)
                }
            }
                
            }
        
        return cell
    }
}
