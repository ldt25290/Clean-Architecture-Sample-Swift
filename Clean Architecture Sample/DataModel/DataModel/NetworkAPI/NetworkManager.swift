//
//  NetworkManager.swift
//  DataModel
//
//  Created by Ali Jawad on 23/03/2020.
//  Copyright © 2020 Ali Jawad. All rights reserved.
//

import Foundation

public protocol NetworkManagerProtocol {
    func fetchData<P, A: ApiProtocol>(parameters:P?, api: A , completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Cancellable?
    func downloadImage(imageURL: String, completionHandler:@escaping (Data?, URLResponse?, Error?) -> Void) -> Cancellable?

}


public class NetworkManager: NetworkManagerProtocol {
    public func downloadImage(imageURL: String, completionHandler:@escaping (Data?, URLResponse?, Error?) -> Void) -> Cancellable? {
        if let url = URL(string: imageURL) {
            let session = URLSession.shared
            var request = URLRequest(url: url)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
                completionHandler(data, response, error)
                
            }
            
            
            task.resume()
            return Cancellable(task: task)
        }
        
        return nil
    }
    
    
    // properties
    var baseURL: String
    
    public init(baseURLString: String) {
        self.baseURL = baseURLString
    }
    
    public func fetchData<P, A>(parameters: P?, api: A, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> Cancellable? where A : ApiProtocol {
        var stringURL = ""
        
        stringURL =  self.baseURL + api.apiEndPoint()
        
        
        if let url = URL(string: stringURL) {
            let session = URLSession.shared
            var request = URLRequest(url: url)
            request.httpMethod = api.httpMethod()
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            if let parameters = parameters as? [String: Any] {
                
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                } catch let error {
                    print(error.localizedDescription)
                }

            }
            
            if let header: (key: String, value: String) = api.apiHeader() {
                request.setValue(header.value, forHTTPHeaderField: header.value)
            }
            
            let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
                completionHandler(data, response, error)
                
            }
            
            
            task.resume()
            return Cancellable(task: task)
        }
        
        return nil
    }
    
}
