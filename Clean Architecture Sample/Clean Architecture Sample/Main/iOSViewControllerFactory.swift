//
//  iOSViewControllerFactory.swift
//  Clean Architecture Sample
//
//  Created by Ali Jawad on 31/03/2020.
//  Copyright © 2020 Ali Jawad. All rights reserved.
//

import Foundation
import UIKit
import DataModel

final class iOSViewControllerFactory: ViewControllerFactory {
    private let networkManager: NetworkManagerProtocol
    private let parser: ParserProtocol
    
    public init(networkManager: NetworkManagerProtocol, parser: ParserProtocol) {
        self.networkManager = networkManager
        self.parser = parser
    }
    
    func forecastViewControllerWithData<T>(data: T, selectionHandler: @escaping (WeatherItem) -> Void) -> UIViewController {
        
        let networkAPI = FetchWeatherData_network(networkManager: networkManager, parser: parser)
               
        let networkService =  ServiceFetchDataFromNetwork(networkHandler: networkAPI)
        
        let presenter = ForecastViewPresenter(data: data, networkHandler: WeatherDataNetworkServiceInvoker(networkService: networkService))
        return ForecastViewController(presenter: presenter, selectionHandler: selectionHandler)
    }
    
    func weatherDataLoaderViewController() -> UIViewController {
        let networkAPI = FetchWeatherData_network(networkManager: networkManager, parser: parser)
               
        let networkService =  ServiceFetchDataFromNetwork(networkHandler: networkAPI)

        return DataLoaderViewController(networkHandler: networkService)
    }
    
    func weatherDetailViewController(data: WeatherItem) -> UIViewController {
        let networkAPI = DownloadImage_network(networkManager: networkManager, parser: parser)
        let networkService =  ServiceFetchDataFromNetwork(networkHandler: networkAPI)

        let imageDownloadServiceInvoker = DownloadImageServiceInvoker(networkService:networkService)
        return WeatherDetailViewController(data: data, imageDownloadService: imageDownloadServiceInvoker)
    }
}
