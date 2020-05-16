//
//  DataProtocol.swift
//  DataModel
//
//  Created by Ali J on 12/02/2020.
//  Copyright © 2020 Ali J. All rights reserved.
//

public class Cancellable: NSObject {
    var task: URLSessionDataTask
    
    init(task: URLSessionDataTask) {
        self.task = task
    }
    
    public func cancelRequest() {
        self.task.cancel()
    }
}


protocol DataResponseProtocol {
    associatedtype T
    var data: T? { get set }

}

protocol APIDataResponseProtocol: DatabaseProtocol {
    var _isSuccessful: Bool { get set }
}

public protocol DataHandlerProtocol {
    @discardableResult
    func fetchData<P,T>(parameters: P?, completionHandler:@escaping (T?, _ error: Error?)->Void) -> Cancellable?
}
