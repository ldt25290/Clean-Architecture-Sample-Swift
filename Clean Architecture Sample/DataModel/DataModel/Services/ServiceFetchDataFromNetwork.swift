//
//  APIFetchDataFromNetwork.swift
//  DataModel
//
//  Created by Ali J on 12/02/2020.
//  Copyright © 2020 Ali J. All rights reserved.
//



public class ServiceFetchDataFromNetwork: DataHandlerProtocol {
    
    var networkHandler: NetworkProtocol
    
    public init(networkHandler: NetworkProtocol) {
        self.networkHandler = networkHandler
    }
    
    //MARK: Data Protocol
    
    public func fetchData<P, T>(parameters: P?, completionHandler: @escaping (T?, Error?) -> Void) -> Cancellable? {
        return self.networkHandler.executeRequest(parameters: parameters) { (data: T?, error: Error?) in
                   
            completionHandler(data, error)
        }
    }

}

