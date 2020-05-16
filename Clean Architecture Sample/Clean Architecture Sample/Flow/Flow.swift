//
//  Flow.swift
//  Clean Architecture Sample
//
//  Created by Ali Jawad on 29/03/2020.
//  Copyright © 2020 Ali Jawad. All rights reserved.
//

import Foundation
import DataModel

class Flow {
    let router: ForecastRouterProtocol
    var data: WeatherDataModel?
    init(router: ForecastRouterProtocol, data: WeatherDataModel?) {
        self.data = data
        self.router = router
        
    }
    
    func start() {
        
        if let data = self.data {
            router.navigateToForecastViewWithData(data: data, selectionHandler:  {[weak self] (weatherItem) in
                self?.router.navigateToWeatherDetailViewController(data: weatherItem)
                
            })
        } else {
            let controller: DataLoaderViewControllerProtocol?  = router.dataLoaderViewController()
            if let controller = controller {
                controller.makeNetworkRequest(completionHandler: {[weak self] (response: Any) in
                    if let data = response as? WeatherDataModel {
                        self?.router.popTopViewController(animated: false)
                        self?.router.navigateToForecastViewWithData(data: data, selectionHandler: {[weak self] (weatherItem) in
                            self?.router.navigateToWeatherDetailViewController(data: weatherItem)

                        })

                    } else {
                        fatalError("WeatherDataModel returned from API call is nil")
                    }
                }, cancelHandler: {
                    controller.presentRetryAcionWithMessage(message: "Request was cancelled. Please retry?")
                }, errorHandler: {error in
                    controller.presentRetryAcionWithMessage(message: "\(error). " + "Please retry?")

                }
                    
            )}
            
        }
        
    }
}
