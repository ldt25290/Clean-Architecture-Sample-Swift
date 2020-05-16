//
//  Router Protocols.swift
//  Clean Architecture Sample
//
//  Created by Ali Jawad on 30/03/2020.
//  Copyright © 2020 Ali Jawad. All rights reserved.
//

import Foundation
import UIKit
import DataModel

protocol ForecastRouterProtocol {
    func showMessage_fetchingData(cancelHandler:@escaping ()->Void)
    func showMessage_networkError(retryHandler:@escaping ()->Void)
    func navigateToForecastViewWithData<T>(data: T, selectionHandler: @escaping (WeatherItem) -> Void)
    func dataLoaderViewController() -> DataLoaderViewControllerProtocol?
    func loadData<T>(data: T?)
    func popTopViewController(animated: Bool)
    func navigateToWeatherDetailViewController(data: WeatherItem)
}


class ForecastRouter: ForecastRouterProtocol {
    
    
    func loadData<T>(data: T?) {
        
    }
    
    
    let navigationController: UINavigationController
    let viewControllerFactory: ViewControllerFactory
    
    init(navigationController: UINavigationController, viewControllerFactory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
    }
    
    func showMessage_fetchingData(cancelHandler: @escaping () -> Void) {
        
    }
    
    func showMessage_networkError(retryHandler: @escaping () -> Void) {
        
    }
    
    func navigateToForecastViewWithData<T>(data: T, selectionHandler: @escaping (WeatherItem) -> Void) {
   
        DispatchQueue.main.async {[weak self] in
           
            if let controller = self?.viewControllerFactory.forecastViewControllerWithData(data: data, selectionHandler: selectionHandler) {
                self?.navigationController.pushViewController( controller, animated: false)
                controller.navigationItem.hidesBackButton = true
            }

        }

    }
    
    func dataLoaderViewController() -> DataLoaderViewControllerProtocol? {
       
        let controller = self.viewControllerFactory.weatherDataLoaderViewController()
        self.navigationController.pushViewController(controller, animated: false)
        
        return controller as? DataLoaderViewControllerProtocol
    }
    
    func popTopViewController(animated: Bool) {
        DispatchQueue.main.async {
            self.navigationController.popViewController(animated: animated)

        }
    }
    
    func navigateToWeatherDetailViewController(data: WeatherItem) {
        DispatchQueue.main.async {[weak self] in
           
            if let controller = self?.viewControllerFactory.weatherDetailViewController(data: data) {
                self?.navigationController.pushViewController( controller, animated: true)
            }

        }
    }
    
}
