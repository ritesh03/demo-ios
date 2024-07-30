//
//  BaseRequest.swift

import UIKit
import Alamofire
import PDFKit

protocol ServiceRequestDelegate {
    func successWithdata(response: BaseResponse);
    func failureWithdata(response: BaseResponse);
}

class NetworkManager {
    
    //shared instance
    static let shared = NetworkManager()
    
    let reachabilityManager = NetworkReachabilityManager()
    
    func startNetworkReachabilityObserver() {
        reachabilityManager?.startListening(onUpdatePerforming: { (status) in
            switch status {
            case .notReachable:
                print("The network is not reachable")
            case .unknown :
                print("It is unknown whether the network is reachable")
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
            case .reachable(.cellular):
                print("The network is reachable over the cellular")
            }
        })
    }
    
}

class BaseRequest: NSObject {
    
    var delegate: ServiceRequestDelegate!
    
    func sendRequestWithJson(dataObject: AnyObject?, header: String?, url: String, type: RequestType, request: APIRequests){
        
        var headers = HTTPHeaders()
        if let token = header {
            headers = ["x-access-token" : "\(token)"]
        }
        
        print("Url: \(url)")
        print("Parameters: \(dataObject as Any)")
        print("Headers: \(headers)")
        
        let requestType = getRequestType(requestType: type)
        
        var encoding:ParameterEncoding = URLEncoding.default
        if type == .RType_Post || type == .RType_Delete || type == .RType_Put {
            encoding = JSONEncoding.init(options: JSONSerialization.WritingOptions.prettyPrinted)
        }
        
        Alamofire.AF.request(url, method: requestType, parameters: dataObject as? Parameters, encoding: encoding , headers: headers).responseJSON { (dataResponse) in
            print(dataResponse)
            self.serviceResult(responseObject: dataResponse, serviceType: request)
        }
        
    }
    
    func sendRequestWithHeader(dataObject: AnyObject?, header: String?, url: String, type: RequestType, request: APIRequests){
        
        var headers = HTTPHeaders()
        if let token = header {
            headers = ["Authorization" : "Basic \(token)"]
        }
        
        print("Url: \(url)")
        print("Parameters: \(dataObject as Any)")
        print("headers: \(headers)")
        
        let requestType = getRequestType(requestType: type)
        
        let encoding:ParameterEncoding = URLEncoding.default
//        if type == .RType_Post || type == .RType_Delete || type == .RType_Put {
//            encoding = JSONEncoding.init(options: JSONSerialization.WritingOptions.prettyPrinted)
//        }
        
        
        Alamofire.AF.request(url, method: requestType, parameters: dataObject as? Parameters, encoding: encoding , headers: headers).responseJSON { (dataResponse) in
            print(dataResponse)
            self.serviceResult(responseObject: dataResponse, serviceType: request)
        }
        
    }
    
    func sendRequestWithPDF(pdfData: Data, fileName: String, rawAtcData: Data, atcFileName: String, parameters: [String : Any], header: String?, url: String, type: RequestType, request: APIRequests) {
        
        var headers = HTTPHeaders()
        if let token = header {
            headers = ["authorization" : "\(token)"]
        }
        
        print("Url: \(url)")
        print("Parameters: \(parameters as Any)")
        print("Headers: \(headers)")
        
        let requestType = getRequestType(requestType: type)
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                if let arrayValue = value as? [String] {
                    for code in arrayValue {
                        if let codeData = code.data(using: .utf8) {
                            multipartFormData.append(codeData, withName: key+"[]" )
                        }
                    }
                } else {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
            }
            
            multipartFormData.append(pdfData, withName: "pdfFile", fileName: fileName, mimeType:"application/pdf")
            multipartFormData.append(rawAtcData, withName: "atcFile", fileName: atcFileName, mimeType:"application/atc")
            
            
        }, to: url,method: requestType,headers: headers).responseJSON(completionHandler: { (dataResponse) in
            print("dataResponse: \(dataResponse)")
            self.serviceResult(responseObject: dataResponse, serviceType: request)
        })
    }
    
    func uploadToMedAI(rawAtcData: Data, atcFileName: String, parameters: [String : Any], header: String?, url: String, type: RequestType, request: APIRequests) {
        
        var headers = HTTPHeaders()
        if let token = header {
            headers = ["Authorization" : "Bearer \(token)"]
        }
        
        print("Url: \(url)")
        print("Parameters: \(parameters as Any)")
        print("Headers: \(headers)")
        
        let requestType = getRequestType(requestType: type)
        
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                if let arrayValue = value as? [String] {
                    for code in arrayValue {
                        if let codeData = code.data(using: .utf8) {
                            multipartFormData.append(codeData, withName: key+"[]" )
                        }
                    }
                } else {
                    multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
                }
            }
            multipartFormData.append(rawAtcData, withName: "atc", fileName: atcFileName, mimeType:"application/atc")
            
            
        }, to: url,method: requestType,headers: headers).responseJSON(completionHandler: { (dataResponse) in
            print("dataResponse: \(dataResponse)")
            self.serviceResult(responseObject: dataResponse, serviceType: request)
        })
    }
    
    //MARK: - Utility
    func getRequestType(requestType: RequestType)->HTTPMethod{
        switch requestType{
        case .RType_Get:
            return HTTPMethod.get
        case .RType_Post:
            return HTTPMethod.post
        case .RType_Put:
            return HTTPMethod.put
        case . RType_Delete:
            return HTTPMethod.delete
        }
    }
    
    //MARK: - Result
    func serviceResult(responseObject: AFDataResponse<Any>, serviceType: APIRequests) {
        
    }
  
   

}
