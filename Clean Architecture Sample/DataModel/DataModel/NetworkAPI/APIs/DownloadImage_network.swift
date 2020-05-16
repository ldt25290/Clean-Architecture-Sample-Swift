//
//  PT_downloadImage_network.swift
//  DataModel
//
//  Created by Ali Jawad on 23/03/2020.
//  Copyright © 2020 Ali Jawad. All rights reserved.
//

import Foundation

public struct ResponseDownloadImage: Codable {
    public var data: Data? 
    
    init(data: Data) {
        self.data = data
    }
}


public class DownloadImage_network: NetworkProtocol {
    
    var networkManager: NetworkManagerProtocol
    var parser: ParserProtocol
    public init(networkManager: NetworkManagerProtocol, parser: ParserProtocol) {
        self.networkManager = networkManager
        self.parser = parser
    }
    
    
    public func executeRequest<P, T>(parameters: P?, completionHandler: @escaping (T?, Error?) -> Void) -> Cancellable? {
        
        if let imageURL = parameters as? String, imageURL != "" {
            return networkManager.downloadImage(imageURL: imageURL) { (data, response, error) in
                if let data = data {
                    completionHandler(ResponseDownloadImage(data: data) as? T, error)

                    } else {
                        completionHandler(nil, error)
                }
            }
        } else {
            fatalError("image url must be a valid, non-empty string")
        }
    
    }
    
}
