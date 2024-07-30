//
//  BaseResponse.swift

import UIKit
import Alamofire

class BaseResponse: NSObject {

    var isSuccess = false
    var serverData: AnyObject!
    var authToken:String?
    var requestType: APIRequests!
    var statusCode: Int = 0
    var message = ""
    
    //MARK: - RESPONSES
    //===========================================================================================
    static func responseFromResponseDict(responseDict: [String: AnyObject])->BaseResponse{
        let response = BaseResponse()
        if let errorDescription = responseDict[ServiceConstants.kErrorDescription] as? String {
            response.message = errorDescription
            response.isSuccess = false
        } else if let status = responseDict[ServiceConstants.kstatus] as? Bool,!status {
            response.message = responseDict[ServiceConstants.kmessage] as? String ?? "Server Error"
            response.isSuccess = false
        } else {
            response.isSuccess = true
            response.serverData = responseDict as AnyObject?
        }
        
        return response
        
    }
    
    //===========================================================================================
    static func getResponse(responseObj: AFDataResponse<Any>, serviceType: APIRequests)->BaseResponse{
       
        var response = BaseResponse()
        
        if let responseVal = responseObj.response{
            response.statusCode = responseVal.statusCode
        }
        
        if responseObj.response?.statusCode != ServiceStatusCode.kSuccess && responseObj.response?.statusCode != ServiceStatusCode.kSuccessRegister {
            
            if let responseDict = responseObj.value as? [String: AnyObject] {
                if let errorDescription = responseDict[ServiceConstants.kErrorDescription] as? String {
                    response.message = errorDescription
                    response.isSuccess = false
                }
                else if let msgDescription = responseDict[ServiceConstants.kMessage] as? String {
                    response.message = msgDescription
                    response.isSuccess = false
                }
                else if let msgDescription = responseDict[ServiceConstants.kmessage] as? String {
                    response.message = msgDescription
                    response.isSuccess = false
                }
                else if let msgDescription = responseDict[ServiceConstants.kError] as? String {
                    response.message = msgDescription
                    response.isSuccess = false
                }
                
                response.serverData = responseObj.value as AnyObject?
            }
            else  {
                response.message = "Server Error"
                response.isSuccess = false
            }
            
        } else{
            if let responseDict = responseObj.value as? [String: AnyObject] {
                response = responseFromResponseDict(responseDict: responseDict)
            }
            else if let responseDict = responseObj.value as? [AnyObject] {
                response.isSuccess = true
                response.serverData = responseDict as AnyObject?
            }
            else {
                response.isSuccess = true
                response.serverData = responseObj.value as AnyObject
            }
            if response.serverData != nil {
                if let token = response.serverData["accesstoken"] as? String {
                    response.authToken = token
                }
            }
        }
        
        response.requestType = serviceType
        
        return response
        
    }
    
    //===========================================================================================
    static func getResponseForError(responseObj: AFDataResponse<Any>)->BaseResponse {
        
        let error = responseObj.error
        var response = BaseResponse()
        if let errorObj = error as NSError? {
            
            print(errorObj.code)
            
            response.message = errorObj.localizedDescription
            
            if errorObj.code == -1009{
                response.message = NSLocalizedString("Network Error", comment: "")
            }
        }
        else{
            response = getDefaultErrorResponse()
        }
        response.isSuccess = false
        
        return response
    }
    
    //===========================================================================================
    static func getDefaultErrorResponse()->BaseResponse{
        
        let response = BaseResponse()
        response.message = NSLocalizedString("Server Error", comment: "")
        response.isSuccess = false
        
        return response
    }
    
}
