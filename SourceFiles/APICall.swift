//
//  APICall.swift
//  project
//
//  Created by David Zack Walker on 01.06.20.
//  Copyright © 2020 David Zack Walker. All rights reserved.
//

import Foundation

public class APICall {
    private let urlSession = URLSession.shared
    private var endpoint : URLRequest
    private var completionHandler : (Data?, URLResponse?, Error?) -> Void = { _, _, _ in }
    
    init(endpoint: URLRequest,
         completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void = { _, _, _ in }) {
        self.endpoint = endpoint
        self.completionHandler = completionHandler
    }
    
    public func execute() {
        let task = urlSession.dataTask(with: endpoint, completionHandler: completionHandler)
        task.resume()
    }
}
