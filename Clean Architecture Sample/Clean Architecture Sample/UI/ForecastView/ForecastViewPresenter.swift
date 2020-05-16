//
//  ForecastViewDelegate.swift
//  Clean Architecture Sample
//
//  Created by Ali Jawad on 06/05/2020.
//  Copyright © 2020 Ali Jawad. All rights reserved.
//

import Foundation
import DataModel

private enum enumViewState: Int {
    case upcoming = 0
    case hottest
}

protocol ForecastViewDelegate: NSObjectProtocol {
    func loadData(data: WeatherDataModel)
    func displayErrorMesasge(errorMessage: String, retryHandler:()->())
}

protocol ForecastViewPresenterProtocol {
    func setViewDelegate(forecastViewDelegate: ForecastViewDelegate?)
    func sortingControlSelected(index: Int)
    func pulledToRefreshWeatherData()
}

class ForecastViewPresenter: ForecastViewPresenterProtocol {
    private var data: WeatherDataModel
    private var networkInvoker: WeatherDataNetworkServiceInvokerProtocol
    private var viewState: enumViewState
    
    weak private var forecastViewDelegate : ForecastViewDelegate?
    
    init<T>(data: T, networkHandler: WeatherDataNetworkServiceInvokerProtocol){
        if let data = data as? WeatherDataModel {
            self.data = data
        } else {
            fatalError("ForecastViewPresenter unable to cast data to WeatherDataModel")
            
        }
        
        self.networkInvoker = networkHandler
        self.viewState = enumViewState.upcoming
    }
    
    func setViewDelegate(forecastViewDelegate: ForecastViewDelegate?){
        self.forecastViewDelegate = forecastViewDelegate
        self.forecastViewDelegate?.loadData(data: sortUpcomingWeatherData())
    }
    
    func sortingControlSelected(index: Int) {
        self.viewState = enumViewState(rawValue: index) ?? enumViewState.upcoming
        self.viewState == enumViewState.upcoming ? forecastViewDelegate?.loadData(data: sortUpcomingWeatherData()) : forecastViewDelegate?.loadData(data: fiterAndSortHottestWeatherData())
    }
    
    
}

//MARK: Sorting And filter

extension ForecastViewPresenter {
    
    private func fiterAndSortHottestWeatherData() -> WeatherDataModel {
        
        var filteredData: WeatherDataModel = data.filter({ (object) -> Bool in
            object.chanceRain < 0.5
        })
        
        filteredData.sort { (object1, object2) -> Bool in
            return object1.high > object2.high
        }
        
        return filteredData
        
    }
    
    private func sortUpcomingWeatherData() -> WeatherDataModel {
        self.data.sort { (object1, object2) -> Bool in
            return (Int(object1.day) ?? 0) < (Int(object2.day) ?? 0)
        }
        
        return self.data
    }
    
    func pulledToRefreshWeatherData() {
        networkInvoker.fetchWeatherData(successBlock: {[weak self] (data: WeatherDataModel) in
            
            if let weakSelf = self {
                weakSelf.viewState == enumViewState.upcoming ? weakSelf.forecastViewDelegate?.loadData(data: weakSelf.sortUpcomingWeatherData()) : weakSelf.forecastViewDelegate?.loadData(data: weakSelf.fiterAndSortHottestWeatherData())

            }

        }) {[weak self] (errorMessage: String) in
            if let weakSelf = self {
                weakSelf.forecastViewDelegate?.displayErrorMesasge(errorMessage: errorMessage, retryHandler: {
                    weakSelf.pulledToRefreshWeatherData()
                })
            }
        }
    }
    
}

