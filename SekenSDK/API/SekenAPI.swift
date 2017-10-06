//
//  SekenAPI.swift
//  SekenSDK
//
//  Created by Seken InfoSys on 06/10/17.
//  Copyright © 2017 Seken InfoSys. All rights reserved.
//

import Foundation
public enum HTTPMethod: Int  {
    case GET
    case POST
    case PATCH
    case PUT
    case DELETE
}

public enum Environment: Int  {
    case PROD
    case DEV
    case QA
    case STAGING
}

public class SekenAPI {
    private let webServiceURLs = ["https://admin-dev.zaggle.in/api/v1/", // PROD
        "https://admin-dev.zaggle.in/api/v1/", // DEV
        "https://admin-dev.zaggle.in/api/v1/", // QA
        "https://admin-dev.zaggle.in/api/v1/"] // STAGING
    
    private let httpMethodString = ["GET", "POST", "PATCH", "PUT","DELETE"]
    var env: Environment = .PROD
    
    private var sessionToken: String?
    private let TIMEOUT = 60
    
    private init() {}
    public static let sharedAPI = SekenAPI()
    
    public func performRequest(method: String, type: HTTPMethod, queryParams: Dictionary<String,String>?, customHeaders: Dictionary<String,Any>?, content: Dictionary<String,String>??, completionHandler: @escaping((statusCode: Int, response: Any, data: Data?, error: Error?) ) -> ()) {
        
        performRequest(method: method, type: type, contentType: "application/json", queryParams: queryParams, customHeaders: customHeaders, content: content, completionHandler: completionHandler)
    }
    
    public func performRequest(method: String, type: HTTPMethod, contentType: String, queryParams: Dictionary<String,String>?, customHeaders: Dictionary<String,Any>?, content: Data, completionHandler: @escaping((statusCode: Int, response: Any, data: Data?, error: Error?) ) -> ()) {
        let urlString = method.addingPercentEncoding(withAllowedCharacters:NSCharacterSet.urlQueryAllowed)
        
        if let urlString = urlString {
            let methodURL = URL(string: urlString, relativeTo: URL.init(string: webServiceURLs[env.rawValue]))
            let components = NSURLComponents(url: methodURL!, resolvingAgainstBaseURL: true)
            
            if let queryParams = queryParams, queryParams.count > 0 {
                var queryItems:[NSURLQueryItem] = []
                
                let keys = queryParams.keys
                for key in keys {
                    queryItems.append(NSURLQueryItem(name: key, value:queryParams[key]))
                }
                components?.queryItems = queryItems as [URLQueryItem]
            }
            
            let url = components?.url
            
            var urlRequest = URLRequest(url: url!, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: TimeInterval(TIMEOUT))
            urlRequest.httpMethod = httpMethodString[type.rawValue]
            
            if let sessionToken = sessionToken {
                urlRequest.setValue(sessionToken, forHTTPHeaderField:"token")
            }
            
            urlRequest.setValue(String(format: "%lu", UInt64(content.count)), forHTTPHeaderField:"Content-Length")
            urlRequest.setValue(contentType, forHTTPHeaderField:"Content-Type")
            urlRequest.httpBody = content
            
            
            if let customHeaders = customHeaders {
                for key in customHeaders.keys {
                    if let customHeader = customHeaders[key] as? String {
                        urlRequest.setValue(customHeader, forHTTPHeaderField:key)
                    }
                }
            }
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let data = data {
                    do {
                        let responseObject = try JSONSerialization.jsonObject(with: data, options: [])
                        if let httpResponse = response as? HTTPURLResponse {
                            DispatchQueue.main.async {
                                completionHandler((statusCode: httpResponse.statusCode, response: responseObject, data: data, error: error))
                            }
                        }
                    } catch {
                        
                    }
                }
            }
            
            task.resume()
        }
    }
    
    public func performRequest(method: String, type: HTTPMethod, contentType: String, queryParams: Dictionary<String,String>?, customHeaders: Dictionary<String,Any>?, content: Dictionary<String,String>??, completionHandler: @escaping((statusCode: Int, response: Any, data: Data?, error: Error?) ) -> ()) {
        
        if let content = content {
            do {
                let data = try JSONSerialization.data(withJSONObject: content ?? [], options: JSONSerialization.WritingOptions(rawValue: 0))
                
                performRequest(method: method, type: type, contentType: contentType, queryParams: queryParams, customHeaders: customHeaders, content: data, completionHandler: completionHandler)
                
            } catch {
                
            }
        } else {
            performRequest(method: method, type: type, contentType: contentType, queryParams: queryParams, customHeaders: customHeaders, content: Data.init(), completionHandler: completionHandler)
        }
    }
    
    public func postMultiPartFormDataTo(method: String, type: HTTPMethod, queryParams: Dictionary<String,String>?, customHeaders: Dictionary<String,Any>?, content: Data, completionHandler: @escaping((statusCode: Int, response: Any, data: Data?, error: Error?) ) -> ()) {
        
        let boundary = String.init(format: "---MobileFormBoundary%d--", Int(Date().timeIntervalSince1970))
        let contentType = String.init(format: "multipart/form-data; boundary=%@", boundary)
        
        if let divider = String.init(format: "\r\n--%@\r\n", boundary).data(using: .utf8), let endDivider = String.init(format: "\r\n--%@--\r\n", boundary).data(using: .utf8) {
            
            var body: Data = divider
            
            if let filenameData = String.init(format: "Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", "image","image.jpg").data(using: .utf8) {
                body.append(filenameData)
            }
            body.append("Content-Type: image/jpg\r\n".data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)
            body.append(content)
            body.append(endDivider)
            
            performRequest(method: method, type: type, contentType: contentType, queryParams: queryParams, customHeaders: customHeaders, content: body, completionHandler: completionHandler)
        }
    }
}
