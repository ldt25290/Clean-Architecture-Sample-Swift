//
//  APIFetchDataFromNetworkAndSaveToDatabase.swift
//  DataModel
//
//  Created by Ali J on 14/02/2020.
//  Copyright © 2020 Ali J. All rights reserved.
//

class ServiceFetchDataFromNetworkAndSaveToDatabase: DataHandlerProtocol {
    
    var networkDataFetcher: DataHandlerProtocol
    var databaseManager: DatabaseManagerProtocol
    
    init(networkDataFetcher: DataHandlerProtocol, databaseManager: DatabaseManagerProtocol) {
        // networkDataFetcher parameter expects concrete object of APIFetchDataFromNetwork Class
        self.networkDataFetcher = networkDataFetcher
        self.databaseManager = databaseManager
    }
    
    func fetchData<P, T>(parameters: P?, completionHandler: @escaping (T?, Error?) -> Void) -> Cancellable? {
        return networkDataFetcher.fetchData(parameters: parameters) { (data: T?, error: Error?) in
            self.databaseManager.saveData(dataToSave: data)
            completionHandler(data, error)
        }
    }
}
