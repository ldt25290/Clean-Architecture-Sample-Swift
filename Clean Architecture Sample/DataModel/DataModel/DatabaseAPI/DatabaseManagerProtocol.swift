//
//  DatabaseManagerProtocol.swift
//  DataModel
//
//  Created by Ali J on 14/02/2020.
//  Copyright © 2020 Ali J. All rights reserved.
//

protocol FetchDataManagerProtocol_database {
    func getData<P, T>(parametes: P?) -> T
}

protocol SaveDataManagerProtocol_database {
    func saveData<T>(dataToSave: T)
}

protocol DatabaseManagerProtocol { 
    var saveDataManager: SaveDataManagerProtocol_database { get set }
    var fetchDataManager: FetchDataManagerProtocol_database { get set }
    
    func getData<P, T>(parametes: P?) -> T
    func saveData<T>(dataToSave: T)
}

extension DatabaseManagerProtocol {
    func getData<P, T>(parametes: P?) -> T {
        return self.fetchDataManager.getData(parametes: parametes)
    }
    
    func saveData<T>(dataToSave: T) {
        self.saveDataManager.saveData(dataToSave: dataToSave)
    }
}

