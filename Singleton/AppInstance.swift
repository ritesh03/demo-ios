
import Foundation
import UIKit
class AppInstance: NSObject {
    
    static let shared = AppInstance()
    var userDict = [String:AnyObject]()
    var languageString = ""
    var headerToken:String?{
        return userDict["token"] as? String ?? ""
    }
    var step:Int?{
        return userDict["step"] as? Int ?? 0
    }
    var isTermsAccepted:Bool?{
        return userDict["isTermsAccepted"] as? Bool ?? false
    }
    var appLanguage:String?{
        return languageString.getLanguage()
    }
    
    var kakaoId:Int?
    var kakaoUserName:String?
    var kakaoUserEmail:String?
    var kakaoUserProfileImage:String?
    var kakaoUserThumbnailImage:String?
    var kakaoUserCountryCode:String?
    var kakaoUserPhoneNumber:String?
    var kakaoUserDob:String?
    var kakaoUserGender:String?
    var ecgID:String?
    var selectedIndexPath: IndexPath?
    
    override init() {
        super.init()
    }
    
}

