//
//  DatabaseProtocol.swift
//  DataModel
//
//  Created by Ali J on 13/02/2020.
//  Copyright © 2020 Ali J. All rights reserved.
//

protocol DatabaseProtocol { 
    func fetchData<P, R>(parameters: P?) -> R?
}
