//
//  ViewController.swift
//  Clean Architecture Sample
//
//  Created by Ali Jawad on 29/03/2020.
//  Copyright © 2020 Ali Jawad. All rights reserved.
//

import UIKit
import DataModel



class ForecastViewController: UIViewController, ForecastViewDelegate {
    
    
    var data: WeatherDataModel?
    var presenter: ForecastViewPresenterProtocol
    var selectionHandler: (WeatherItem) -> Void
    
    private let refreshControl = UIRefreshControl()
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortingControl: UISegmentedControl!
    
    
    init(presenter: ForecastViewPresenterProtocol, selectionHandler: @escaping (WeatherItem) -> Void) {
        self.presenter = presenter
        self.selectionHandler = selectionHandler
        super.init(nibName: "ForecastViewController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.tableView.register(ForecastTableviewCell.self, forCellReuseIdentifier: "Cell")
        sortingControl.addTarget(self, action: #selector(self.sortingControlAction(_:)), for: .valueChanged)
        self.presenter.setViewDelegate(forecastViewDelegate: self)
        
        // Add Pull down to refresh
        
        // Add Refresh Control to Table View
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)

        
        // Do any additional setup after loading the view.
    }
    
    //MARK: Helper

    @objc private func refreshWeatherData(_ sender: Any) {
        self.presenter.pulledToRefreshWeatherData()
    }
    
    
    func presentRetryAcionWithMessage(message: String, retryHandler:@escaping() -> ()) {
        let alert = UIAlertController(title: "Data could not be feched", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { action in
              switch action.style{
              case .default:
                retryHandler()
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
}

 //MARK: UITableView Delegate and Datasource

extension ForecastViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
           return 1
       }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .none
        if let weatherItem = self.data?[indexPath.row] {
            cell.textLabel?.text = "Day \(weatherItem.day): \(weatherItem.description)"
//            if let imageDownloaded = object["image_downloaded"] as? Bool, imageDownloaded {
//                cell.textLabel?.textColor = .gray
//            }
        }
                   
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let data = data {
            selectionHandler(data[indexPath.row])

        }
    }
    
    //MARK: ForecastViewDelegate
    
    func loadData(data: WeatherDataModel) {
        self.data = data
        
        DispatchQueue.main.async {[weak self] in
            self?.tableView.reloadData()
            self?.refreshControl.endRefreshing()
        }
    }
    
    func displayErrorMesasge(errorMessage: String, retryHandler: () -> ()) {
        
        DispatchQueue.main.async {[weak self] in
            self?.refreshControl.endRefreshing()
        }
        
        presentRetryAcionWithMessage(message: errorMessage) {[weak self] in
            self?.presenter.pulledToRefreshWeatherData()
        }
    }
    
}
 
//MARK: Sorting

extension ForecastViewController {
   @objc func sortingControlAction(_ segmentedControl: UISegmentedControl) {
    
    presenter.sortingControlSelected(index: segmentedControl.selectedSegmentIndex)
        
   }
}
