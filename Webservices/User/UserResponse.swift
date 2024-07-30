//
//  UserResponse.swift

import Alamofire

class UserResponse: BaseResponse {

    static func getDataResponse(responseObj: AFDataResponse<Any>, serviceType: APIRequests)->BaseResponse {
        
        let response = getResponse(responseObj: responseObj, serviceType: serviceType)
        
        if let serverData = response.serverData as? [String : AnyObject] {
            if let status = serverData["status"] as? Bool,status {
                response.isSuccess = true
                if let strMessage = serverData["message"] as? String {
                    response.message = strMessage
                }
                if let data = serverData["result"] {
                    response.serverData = data
                }
            }
        } else {
            response.isSuccess = false
        }
        
        return response
    }
    
}
