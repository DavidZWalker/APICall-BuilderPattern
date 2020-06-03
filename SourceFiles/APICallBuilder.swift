//
//  APICallBuilder.swift
//  project
//
//  Created by David Zack Walker on 01.06.20.
//  Copyright © 2020 David Zack Walker. All rights reserved.
//

import Foundation

public class APICallBuilder {
    private var baseUrl : String
    private var requestMethod : HTTPRequestMethods
    private var queryParameters : [String:String]
    private var errorHandler : (Error?) -> Void = { _ in }
    private var responseHandler : (URLResponse?) -> Void = { _ in }
    private var dataHandler : (Data?) -> Void = { _ in }
    
    public init() {
        baseUrl = ""
        queryParameters = [String:String]()
        requestMethod = .GET
    }
    
    public func baseUrl(url: String) -> APICallBuilder {
        self.baseUrl = url
        return self
    }
    
    public func addQueryParameter(paramName: String, paramValue: String) -> APICallBuilder {
        self.queryParameters[paramName] = paramValue
        return self
    }
    
    public func onError(errorHandler : @escaping (Error?) -> Void = { _ in }) -> APICallBuilder {
        self.errorHandler = errorHandler
        return self
    }
    
    public func onHttpResponse(httpResponseHandler : @escaping (URLResponse?) -> Void = { _ in }) -> APICallBuilder {
        self.responseHandler = httpResponseHandler
        return self
    }
    
    public func onDataReceived(dataHandler : @escaping (Data?) -> Void = { _ in }) -> APICallBuilder {
        self.dataHandler = dataHandler
        return self
    }
    
    public func setRequestMethod(requestMethod: HTTPRequestMethods) -> APICallBuilder {
        self.requestMethod = requestMethod
        return self
    }
    
    public func build() -> APICall {
        
        // build url string and completion handler for the api call
        let endpointString = buildURLEndpointString()
        let requestCompletionHandler = buildCompletionHandler()
        
        // create URL and URLRequest
        let url = URL(string: endpointString)!
        var urlReq = URLRequest(url: url)
        urlReq.httpMethod = requestMethod == .GET ? "GET" : "POST"
        
        
        // create and return APICall
        return APICall(endpoint: urlReq, completionHandler: requestCompletionHandler)
    }
    
    private func buildURLEndpointString() -> String {
        var firstParam = true
        var queryString = ""
        
        // build query string
        for q in queryParameters {
            var sep = "&"
            if (firstParam) {
                firstParam = false
                sep = "?"
            }
            
            queryString.append(sep)
            queryString.append(q.key)
            queryString.append("=")
            queryString.append(q.value)
        }
        
        // build full url
        var endpoint = baseUrl
        endpoint.append(queryString)
        
        return endpoint
    }
    
    private func buildCompletionHandler() -> (Data?, URLResponse?, Error?) -> Void {
        let handler : (Data?, URLResponse?, Error?) -> Void = {
            (data, response, error) in
            self.errorHandler(error)
            self.responseHandler(response)
            self.dataHandler(data)
        }
        
        return handler
    }
}
