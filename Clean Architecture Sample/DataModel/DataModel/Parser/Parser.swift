//
//  Parser.swift
//  DataModel
//
//  Created by Ali Jawad on 02/05/2020.
//  Copyright © 2020 Ali Jawad. All rights reserved.
//

import Foundation


public protocol ParserProtocol {
    func parseResponse<T : Decodable>(data: Data? , response: T.Type)->T?
    func parseResponseAsDictionary<T: Codable>(param: T) -> [String: AnyObject]?
}


public class ParseManager: ParserProtocol {

    public init() {
        
    }
    
    public func parseResponse<T : Decodable>(data: Data? , response: T.Type)->T? {
        
        guard let dateValue = data else { return  nil }
        
        let decoder = try? JSONDecoder().decode(response, from: dateValue)
        return decoder
    }
    
    public func parseResponseAsDictionary<T:Codable>(param: T) -> [String: AnyObject]? {
        guard let data = try? JSONEncoder().encode(param) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: AnyObject] }
    }
    
    
}
