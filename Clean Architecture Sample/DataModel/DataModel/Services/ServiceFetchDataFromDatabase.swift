//
//  APIFetchDataFromDatabase.swift
//  DataModel
//
//  Created by Ali J on 13/02/2020.
//  Copyright © 2020 Ali J. All rights reserved.
//

class ServiceFetchDataFromDatabase: DataHandlerProtocol {
    var _databaseHandler: DatabaseProtocol
    
    init(databaseHandler: DatabaseProtocol) {
        _databaseHandler = databaseHandler
    }
    
    //MARK: Data Protocol
    
    func fetchData<P, T>(parameters: P?, completionHandler: @escaping (T?, _ error: Error?) -> Void) -> Cancellable? {
        return nil
    }
    
    
}

