//
//  DownloadImageServiceInvoker.swift
//  Clean Architecture Sample
//
//  Created by Ali Jawad on 10/05/2020.
//  Copyright © 2020 Ali Jawad. All rights reserved.
//

import Foundation
import DataModel


protocol DownloadImageServiceInvokerProtocol  {
    func downloadImage(imageUrl: String, successBlock: @escaping (ResponseDownloadImage) -> Void, failureBlock:@escaping (String) ->Void)
}


class DownloadImageServiceInvoker: DownloadImageServiceInvokerProtocol {
    var networkService: DataHandlerProtocol

    public init(networkService: DataHandlerProtocol) {
        self.networkService = networkService
    }
    
    func downloadImage(imageUrl: String, successBlock: @escaping (ResponseDownloadImage) -> Void, failureBlock: @escaping (String) -> Void) {
        if imageUrl != "" {
            _ = self.networkService.fetchData(parameters: imageUrl, completionHandler: { (response: ResponseDownloadImage?, error: Error?) in
                
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
        } else {
            failureBlock("Invalid url")

        }
        
    }

}
