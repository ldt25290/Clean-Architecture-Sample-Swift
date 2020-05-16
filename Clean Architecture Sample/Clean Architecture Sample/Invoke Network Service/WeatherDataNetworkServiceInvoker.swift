//
//  NetworkServiceInvoker.swift
//  Clean Architecture Sample
//
//  Created by Ali Jawad on 07/05/2020.
//  Copyright © 2020 Ali Jawad. All rights reserved.
//

import Foundation
import DataModel


protocol WeatherDataNetworkServiceInvokerProtocol  {
    func fetchWeatherData(successBlock: @escaping (WeatherDataModel) -> Void, failureBlock:@escaping (String) ->Void)
}

class WeatherDataNetworkServiceInvoker: WeatherDataNetworkServiceInvokerProtocol {
    var networkService: DataHandlerProtocol
    
    public init(networkService: DataHandlerProtocol) {
        self.networkService = networkService
    }
    
    func fetchWeatherData(successBlock: @escaping (WeatherDataModel) -> Void, failureBlock:@escaping (String) ->Void) {
        
        _ = self.networkService.fetchData(parameters: nil as [String: Any]?, completionHandler: { (response: WeatherDataModel?, error: Error?) in
            
            if let error = error {
                failureBlock(error.localizedDescription)
                return
            }
            
            if let response = response {
                successBlock(response)
            } else {
                failureBlock("Something went wrong")
            }
        })
        
    }
    
//    func authenticateUser(userName: String, password: String, successBlock: @escaping () -> Void, failureBlock:@escaping (Error?) ->Void) {
//        _ = self.networkService.fetchData(parameters: ["UserName":userName, "password":password]) { (response: LoginModel?, error: Error?) in
//            print("Login Response: \(String(describing: response)) and error \(String(describing: error))")
//
//            //NOTE: Ignoring the failed API response and moving to HomeViewController
//
//            successBlock()
//
////            if let error = error {
////                failureBlock(error)
////            } else if let token = response?.token {
////                self?.keychain.saveTokenToKeyChain(token: token)
////                successBlock()
////            }
//
//
//        }
//    }
}
