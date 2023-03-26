//
//  ServiceManager.swift
//  ChatGPT-Swift
//
//  Created by Syed Muhammad on 26/03/2023.
//

import Foundation
enum MethodName: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}


enum APIError:Error {
    
    case ContentNotFound      // 204
    case BadRequest           // 400  Your request is invalid and/or not formed properly. You need to reformulate your request.
    case NotAuthorized        // 401  Either you need to provide authentication credentials, or the credentials provided aren't valid.
    case Forbidden            // 403  We understand your request, but are refusing to fulfill it. An accompanying error message should explain why.
    case MethodNotFound       // 404  Either you're requesting an invalid URI or the resource in question doesn't exist (ex: no such user).
    case InternalServerError  // 500  We did something wrong. We'll be notified and we'll look into it.
    case BadGateway           // 502  Returned if Intervals is down or being upgraded, or if the system is overloaded and API requests are being throttled.
    case ServiceUnavailable   // 503  Usually as a result of suspension, we are refusing to process this request. You *may* try again later.
    case Unknown
    case Timeout
}

class ServiceManager: NSObject {
    
    //MARK: - Properties
    static let shared = ServiceManager()
    var token: String = "Bearer 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"
    
    //MARK: - Init
    override init() {}
    
    //MARK: - Methods
    private var error: Error? {
        didSet {
            // NotificationCenter.default.post(name: .errorOccured, object: nil)
        }
    }
    
    
    func sendAPICall(withEndpoint endpoint:String, Parameters param:Data? = nil, httpMethod type:String, completion: @escaping(Result<Data,Error>) -> Void) {
        
        var urlRequest = URLRequest(url: URL(string: endpoint)!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 120)
        
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = type //"POST"
        urlRequest.addValue(token, forHTTPHeaderField: "Authorization")
        urlRequest.setValue("Avalon", forHTTPHeaderField: "User-Agent")
        
        if param != nil {
            urlRequest.httpBody = param  // This will be passed as encoded data of codeable object
        }
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
        
        let dataTask = session.dataTask(with: urlRequest) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                
                switch httpResponse.statusCode {
                case 200:
                    DispatchQueue.main.async {
                        completion(.success(data ?? Data()))
                    }
                    return
                case 204:
                    self.error = APIError.ContentNotFound
                case 400:
                    self.error = APIError.BadRequest
                case 401:
                    self.error = APIError.NotAuthorized
                case 403:
                    self.error = APIError.Forbidden
                case 404:
                    self.error = APIError.MethodNotFound
                case 500:
                    self.error = APIError.InternalServerError
                case 502:
                    self.error = APIError.BadGateway
                case 503:
                    self.error = APIError.ServiceUnavailable
                default:
                    self.error = APIError.Unknown
                }
                
            } else {
                self.error = APIError.Timeout
            }
            
            DispatchQueue.main.async {
                completion(.failure(self.error!))
            }
        }
        dataTask.resume()
        
    }
}

//MARK: - URLSessionDelegate
extension ServiceManager: URLSessionDelegate {

    //For bypasssing the invalid certificates specially in case of fiddler for debugging the APIs.
    
    public func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
       //Trust the certificate even if not valid
       let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)

       completionHandler(.useCredential, urlCredential)
    }
}
