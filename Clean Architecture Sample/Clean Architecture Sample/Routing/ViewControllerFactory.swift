//
//  ViewControllerFactory.swift
//  Clean Architecture Sample
//
//  Created by Ali Jawad on 31/03/2020.
//  Copyright © 2020 Ali Jawad. All rights reserved.
//

import Foundation
import UIKit
import DataModel

//protocol NetworkCallProtocol {
//    associatedtype T
//    func loadData(data: T)
//    func displayErrorMesasge(errorMessage: String, retryHandler:()->())
//}

protocol ViewControllerFactory {
    
    //func forecastViewControllerWithData<T, R: UIViewController>(data: T) -> R where R: NetworkCallProtocol
    func forecastViewControllerWithData<T>(data: T, selectionHandler: @escaping (WeatherItem) -> Void) -> UIViewController
    func weatherDataLoaderViewController() -> UIViewController
    func weatherDetailViewController(data: WeatherItem) -> UIViewController
    //  func forecastViewControllerWithRetryAction(vo)
    
}
