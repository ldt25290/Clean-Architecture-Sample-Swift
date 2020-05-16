//
//  DataLoaderViewController.swift
//  Clean Architecture Sample
//
//  Created by Ali Jawad on 01/05/2020.
//  Copyright © 2020 Ali Jawad. All rights reserved.
//

import Foundation
import UIKit
import DataModel

protocol DataLoaderViewControllerProtocol {
    func makeNetworkRequest(completionHandler:@escaping(_ data: Any)->Void, cancelHandler:@escaping() ->Void, errorHandler:@escaping(String)->Void)
    
    func presentRetryAcionWithMessage(message: String)
}

class DataLoaderViewController: UIViewController, DataLoaderViewControllerProtocol {
    var networkHandler: DataHandlerProtocol
    var cancellable: Cancellable?
    var cancelHandler: (() -> Void)?
    var completionHandler: ((Any)->Void)?
    var errorHandler: ((String) -> Void)?

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    init(networkHandler: DataHandlerProtocol) {
        self.networkHandler = networkHandler
        super.init(nibName: "DataLoaderViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    //MARK: IBAction
    
    @IBAction func cancelAction(_ sender: Any) {
        if let cancellable = cancellable {
            cancellable.cancelRequest()
        }
        
        activityIndicator.stopAnimating()
        
        cancelHandler?()
        
    }
    
    //MARK: DataLoaderViewControllerProtocol
    
    func makeNetworkRequest(completionHandler:@escaping(_ data: Any)->Void, cancelHandler:@escaping() ->Void, errorHandler:@escaping(String)->Void) {
        self.cancelHandler = cancelHandler
        self.completionHandler = completionHandler
        self.errorHandler = errorHandler
        
        self.makeNetworkRequest()
    }
    
    func presentRetryAcionWithMessage(message: String) {
        let alert = UIAlertController(title: "Data could not be feched", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: {[weak self] action in
              switch action.style{
              case .default:
                self?.makeNetworkRequest()

              case .cancel:
                    print("cancel")

              case .destructive:
                    print("destructive")


              @unknown default:
                print("Unknown values")
            }}))
        
        DispatchQueue.main.async {[weak self] in // Correct
            self?.present(alert, animated: true, completion: nil)
        }
        
    }

    //MARK: Helper
    func makeNetworkRequest() {
        
        DispatchQueue.main.async {[weak self] in
            self?.activityIndicator.startAnimating()
        }
        
        networkHandler.fetchData(parameters: nil as [String: Any]?, completionHandler: {[weak self]  (response: WeatherDataModel?, error: Error?) in
            
            DispatchQueue.main.async {[weak self] in
                self?.activityIndicator.stopAnimating()
            }
            
            if let error = error {
                self?.errorHandler?(error.localizedDescription)
                return
            }
            
            self?.completionHandler?(response as Any)
        })
      
    }
    
}
