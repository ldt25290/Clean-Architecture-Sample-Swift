//
//  PT_fetchWeatherData_network.swift
//  DataModel
//
//  Created by Ali Jawad on 23/03/2020.
//  Copyright © 2020 Ali Jawad. All rights reserved.
//

import Foundation

public typealias WeatherDataModel = [WeatherItem]

public struct WeatherItem: Codable {
    public let day, description: String
    public let sunrise, sunset: Int
    public let chanceRain: Double
    public let high, low: Double
    public let image: String

    enum CodingKeys: String, CodingKey {
        case day
        case description = "description"
        case sunrise, sunset
        case chanceRain = "chance_rain"
        case high, low, image
    }
    
    public init(from decoder: Decoder) throws {
           let values = try decoder.container(keyedBy: CodingKeys.self)
            day = try values.decodeIfPresent(String.self, forKey: .day) ?? ""
            description = try values.decodeIfPresent(String.self, forKey: .description) ?? ""
            sunrise = try values.decodeIfPresent(Int.self, forKey: .sunrise) ?? 0
            sunset = try values.decodeIfPresent(Int.self, forKey: .sunset) ?? 0
            chanceRain = try values.decodeIfPresent(Double.self, forKey: .chanceRain) ?? 0
            high = try values.decodeIfPresent(Double.self, forKey: .high) ?? 0
            low = try values.decodeIfPresent(Double.self, forKey: .low) ?? 0
            image = try values.decodeIfPresent(String.self, forKey: .image) ?? ""

       }
}

public class FetchWeatherData_network: NetworkProtocol, ApiProtocol {
    
    var networkManager: NetworkManagerProtocol
    var parser: ParserProtocol
    public init(networkManager: NetworkManagerProtocol, parser: ParserProtocol) {
        self.networkManager = networkManager
        self.parser = parser
    }
    
    public func executeRequest<P, T>(parameters: P?, completionHandler: @escaping (T?, Error?) -> Void) -> Cancellable? {
        
        return networkManager.fetchData(parameters: parameters, api: self) {[weak self] (data, apiResponse, error) in
        
                if let data = data {
                completionHandler((self?.parser.parseResponse(data: data, response: WeatherDataModel.self)) as? T, error)

                } else {
                    completionHandler(nil, error)

            }
        }
        
    }
    
    //MARK: API Protocol
    
    public func apiEndPoint() -> String {
        return "api/forecast"
    }
    
    public func apiHeader() -> (String, String)? {
        return nil
    }
    
    public func httpMethod() -> String {
        return enumHttpMethod.get.rawValue
    }
    
}
