//
//  NetworkProtocol.swift
//  DataModel
//
//  Created by Ali J on 12/02/2020.
//  Copyright © 2020 Ali J. All rights reserved.
//


public protocol NetworkProtocol {
    @discardableResult
    func executeRequest<P, T>(parameters: P?, completionHandler:@escaping (_ data: T?, _ error: Error?)->Void) -> Cancellable?
}


public protocol ApiProtocol {
    func apiEndPoint() -> String
    func apiHeader() -> (String, String)?
    func httpMethod() -> String
}

enum enumHttpMethod: String {
    case post = "POST"
    case get = "GET"
}
