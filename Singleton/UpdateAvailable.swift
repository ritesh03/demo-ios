//
//  UpdateAvailable.swift


import UIKit
import Alamofire
class UpdateAvailable: NSObject {

    static let sharedInstance = UpdateAvailable()
    
//    func isUpdateAvailable() {
//        
//        let info = Bundle.main.infoDictionary
//        let currentVersion = info?["CFBundleShortVersionString"] as? String
//        let identifier = info?["CFBundleIdentifier"] as? String
//        var url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier ?? "")")
//        if identifier != nil{
//            url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier!)")
//        }
//        
//        Alamofire.request(url!, method: .post, parameters: nil, encoding: URLEncoding.httpBody, headers: nil).responseJSON { (response) in
//            guard ((response.result.value) != nil) else{
//                print(response.result.error!.localizedDescription)
//                return
//            }
//            var json = JSON(response.result.value!)
//            
//            guard (json["resultCount"].intValue) != 0 else {
//                //self.showalertview(json["msg"].stringValue)
//                print("No data available")
//                return
//            }
//            print("success")
//            
//            let newVersion = json["results"].arrayValue.map({$0["version"] .stringValue})[0]
//            
//            if currentVersion! < newVersion{
//                //creating the alert
//                let alert = UIAlertController(title: "Update Available", message: "An update to MAK.today is available on the AppStore. Please update to version \(newVersion) now.", preferredStyle: UIAlertControllerStyle.alert)
//                
//                //adding action
//                alert.addAction(UIAlertAction(title: NSLocalizedString("Update", comment: "Update"), style: UIAlertActionStyle.default, handler: {
//                    action in
//                    
//                    let appURL = URL(string: appStore.appStoreLink)!
//                    
//                    if #available(iOS 10.0, *) {
//                        UIApplication.shared.open(appURL)
//                    } else {
//                        UIApplication.shared.openURL(appURL)
//                    }
//                    
//                }))
//                //showing alert
//                if #available(iOS 10.0, *) {
//                    let window = (UIApplication.shared.delegate  as! AppDelegate).window
//                     window?.rootViewController?.present(alert,animated: true, completion: nil)
//                } else {
//                    // Fallback on earlier versions
//                }
//            }
//            
//        }
//        
//    }
}
