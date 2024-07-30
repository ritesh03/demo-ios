//
//  UserRequest.swift

import Alamofire
import UIKit

class UserRequest: BaseRequest {
    
    static let shared = UserRequest()
    
    // Get Languages
    func getLanguages(delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL  + UrlConfig.LANGUAGES_URL
        super.sendRequestWithJson(dataObject: nil, header: nil, url: url, type: RequestType.RType_Get, request: APIRequests.RType_Language)
    }
    
    // Get Language Strings
    func getLanguageStrings(paramaters: [String: AnyObject], delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL  + UrlConfig.STRINGS_URL
        super.sendRequestWithJson(dataObject: paramaters as AnyObject, header: nil, url: url, type: RequestType.RType_Post, request: APIRequests.RType_Language_Strings)
    }
    
    // User Login
    func login(paramaters: [String: AnyObject], delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL  + UrlConfig.LOGIN_URL
        super.sendRequestWithJson(dataObject: paramaters as AnyObject, header: nil, url: url, type: RequestType.RType_Post, request: APIRequests.RType_Login)
    }
    
    // Kakao Login
    func kakaoLogin(paramaters: [String: AnyObject], delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL  + UrlConfig.KAKAO_LOGIN_URL
        super.sendRequestWithJson(dataObject: paramaters as AnyObject, header: nil, url: url, type: RequestType.RType_Post, request: APIRequests.RType_Login)
    }
    
    // Forgot Password
    func forgotPassword(paramaters: [String: AnyObject], delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL  + UrlConfig.FORGOT_PASSWORD_URL
        super.sendRequestWithJson(dataObject: paramaters as AnyObject, header: nil, url: url, type: RequestType.RType_Put, request: APIRequests.RType_Forgot_Password)
    }
    
    // Find My Id
    func findMyId(paramaters: [String: AnyObject], delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL  + UrlConfig.FIND_ID_URL
        super.sendRequestWithJson(dataObject: paramaters as AnyObject, header: nil, url: url, type: RequestType.RType_Post, request: APIRequests.RType_Find_Id)
    }
    
    // Delete Account
    func deleteAccount(header: String?, delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL  + UrlConfig.DELETE_ACCOUNT_URL
        super.sendRequestWithJson(dataObject: nil, header: header, url: url, type: RequestType.RType_Delete, request: APIRequests.RType_Delete_Account)
    }
    
    // User SignUp
    func signUp(paramaters: [String: AnyObject], delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL  + UrlConfig.REGISTER_URL
        super.sendRequestWithJson(dataObject: paramaters as AnyObject, header: nil, url: url, type: RequestType.RType_Post, request: APIRequests.RType_Login)
    }
    
    // Accept Terms
    func acceptTerms(header: String?, paramaters: [String: AnyObject], delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL  + UrlConfig.ACCEPT_TERMS_URL
        super.sendRequestWithJson(dataObject: paramaters as AnyObject, header: header, url: url, type: RequestType.RType_Put, request: APIRequests.RType_Terms)
    }
    
    // Update User Info
    func userInfo(header: String?, paramaters: [String: AnyObject], delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL  + UrlConfig.PROFILE_UPDATE_URL
        super.sendRequestWithJson(dataObject: paramaters as AnyObject, header: header, url: url, type: RequestType.RType_Put, request: APIRequests.RType_Login)
    }
    
    func accountInfo(header: String?, paramaters: [String: AnyObject], delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL  + UrlConfig.ACCOUNT_UPDATE_URL
        super.sendRequestWithJson(dataObject: paramaters as AnyObject, header: header, url: url, type: RequestType.RType_Put, request: APIRequests.RType_Login)
    }
    
    // Get Profile
    func getUserProfile(header: String?, delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL  + UrlConfig.GET_PROFILE_URL
        super.sendRequestWithJson(dataObject: nil, header: header, url: url, type: RequestType.RType_Get, request: APIRequests.RType_Login)
    }
    
    // Change Password
    func changePassword(header: String?, paramaters: [String: AnyObject], delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL  + UrlConfig.CHANGE_PASSWORD_URL
        super.sendRequestWithJson(dataObject: paramaters as AnyObject, header: header, url: url, type: RequestType.RType_Put, request: APIRequests.RType_Change_Password)
    }
    
    // Home
    func home(header: String?,selectedDate:String, delegate: ServiceRequestDelegate){
        self.delegate = delegate
        var url = UrlConfig.BASE_URL  + UrlConfig.HOME_URL
         url = "\(url)?date=\(selectedDate)"
        super.sendRequestWithJson(dataObject: nil, header: header, url: url, type: RequestType.RType_Get, request: APIRequests.RType_Home)
    }
    
    func getContent(header: String?,selectedLang:String, delegate: ServiceRequestDelegate){
        self.delegate = delegate
        var url = UrlConfig.BASE_URL  + UrlConfig.CONTENT_URL
         url = "\(url)?lang=\(selectedLang)"
        super.sendRequestWithJson(dataObject: nil, header: header, url: url, type: RequestType.RType_Get, request: APIRequests.RType_Home)
    }
    
    // Get Token
    func getToken(header: String?, paramaters: [String: AnyObject], delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL  + UrlConfig.TOKEN_URL
        super.sendRequestWithJson(dataObject: paramaters as AnyObject, header: header, url: url, type: RequestType.RType_Post, request: APIRequests.RType_Token)
    }
    
    //Get Hospital
    func getHospital(header: String?,delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL  + UrlConfig.HOSPITAL_URL
        super.sendRequestWithJson(dataObject: nil, header: header, url: url, type: RequestType.RType_Get, request: APIRequests.RType_Home)
    }
    
    // Register Hospital
    func registerHospital(header: String?,paramaters: [String: AnyObject], delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL  + UrlConfig.LINK_HOSPITAL_URL
        super.sendRequestWithJson(dataObject: paramaters as AnyObject, header: header, url: url, type: RequestType.RType_Put, request: APIRequests.RType_Home)
    }
    
    // Delete Hospital
    func deleteHospital(header: String?, delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL  + UrlConfig.LINK_HOSPITAL_URL
        super.sendRequestWithJson(dataObject: nil, header: header, url: url, type: RequestType.RType_Put, request: APIRequests.RType_Home)
    }
    
    //Get Notifications
    func getNotifications(header: String?,paramaters: [String: AnyObject], delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL  + UrlConfig.NOTIFICATIONS_URL
        super.sendRequestWithJson(dataObject: paramaters as AnyObject, header: header, url: url, type: RequestType.RType_Get, request: APIRequests.RType_Notification)
    }
    
    func getNotificationsCount(header: String?, delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL  + UrlConfig.NOTIFICATIONS_COUNT_URL
        super.sendRequestWithJson(dataObject: nil, header: header, url: url, type: RequestType.RType_Get, request: APIRequests.RType_Notification)
    }
    
    // Get History
    func getHistory(header: String?,paramaters: [String: AnyObject], delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL  + UrlConfig.HISTORY_URL
        super.sendRequestWithJson(dataObject: paramaters as AnyObject, header: header, url: url, type: RequestType.RType_Get, request: APIRequests.RType_History)
    }
    
    // Update Notes
    func updateNote(paramaters: [String: AnyObject], header: String?, delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL  + UrlConfig.NOTES_URL
        super.sendRequestWithJson(dataObject: paramaters as AnyObject, header: header, url: url, type: RequestType.RType_Put, request: APIRequests.RType_Fav)
    }
    
    // Fav Record
    func favorite(favId: String?,header: String?, delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.BASE_URL  + UrlConfig.FAV_URL + "/\(favId!)"
        super.sendRequestWithJson(dataObject: nil, header: header, url: url, type: RequestType.RType_Put, request: APIRequests.RType_Fav)
    }
    
    //MARK: - File Upload
    func uploadFile(pdfData: Data, fileName: String, rawAtcData: Data, atcFileName: String, parameter: [String:AnyObject], delegate: ServiceRequestDelegate) {
        self.delegate = delegate
        let url = UrlConfig.BASE_URL  + UrlConfig.UPLOAD_URL
        super.sendRequestWithPDF(pdfData: pdfData, fileName: fileName, rawAtcData : rawAtcData, atcFileName:atcFileName, parameters: parameter, header: nil, url: url, type: .RType_Post, request: .RType_Upload_Pdf)
    }
    
    //MARK: - MEDAI API
    // Get Access Token
    func getAccessToken(header: String?, paramaters: [String: AnyObject], delegate: ServiceRequestDelegate){
        self.delegate = delegate
        let url = UrlConfig.ACCESSTOKEN_URL
        super.sendRequestWithHeader(dataObject: paramaters as AnyObject, header: header, url: url, type: RequestType.RType_Post, request: APIRequests.RType_Token)
    }
    
    //upload ATC to MedAI server
    func uploadATCFile(header: String?, rawAtcData: Data, atcFileName: String, parameter: [String:AnyObject], delegate: ServiceRequestDelegate) {
        self.delegate = delegate
        let url = UrlConfig.MEDAI_URL
        super.uploadToMedAI(rawAtcData : rawAtcData, atcFileName:atcFileName, parameters: parameter, header: header, url: url, type: .RType_Post, request: .RType_Upload_Pdf)
    }
    
    //MARK: - REQUESTS
    override func serviceResult(responseObject: AFDataResponse<Any>, serviceType: APIRequests) {
        
        switch responseObject.result {
        case .success:
            var response = BaseResponse()
            response = UserResponse.getDataResponse(responseObj: responseObject, serviceType: serviceType)
            delegate?.successWithdata(response: response)
        case .failure(let error):
            let response = BaseResponse.getResponseForError(responseObj: responseObject)
            response.requestType = serviceType
            response.message = error.localizedDescription
            delegate?.failureWithdata(response: response)
        }
    }
    
}
