//
//  WeatherDetailViewController.swift
//  Clean Architecture Sample
//
//  Created by Ali Jawad on 10/05/2020.
//  Copyright © 2020 Ali Jawad. All rights reserved.
//

import Foundation
import UIKit
import DataModel

class WeatherDetailViewController: UIViewController {
    
    @IBOutlet weak var forecastLabel: UILabel!
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var chanceOfRainLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var data: WeatherItem
    var imageDownloadService: DownloadImageServiceInvokerProtocol
    
    init(data: WeatherItem, imageDownloadService: DownloadImageServiceInvokerProtocol) {
        self.data = data
        self.imageDownloadService = imageDownloadService
        super.init(nibName: "WeatherDetailViewController", bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        configureView()
    }
    
    //MARK: IBAction
    
    @IBAction func downloadImage(_ sender: Any) {
        self.imageDownloadService.downloadImage(imageUrl: self.data.image, successBlock: {[weak self] (imageData) in
            
            DispatchQueue.main.async {
                if let data = imageData.data {
                    self?.imageView.image = UIImage(data: data)

                } else {
                    self?.presentErrorWithMessage(message: "Something went wrong")
                }
            }
        }) {[weak self] (errorMesasge) in
            self?.presentErrorWithMessage(message: errorMesasge)
        }
    }
    
    //MARK: Configur View
    
    func configureView() {
        forecastLabel.text = self.data.description
        sunriseLabel.text = "\(self.data.sunrise) seconds"
        sunsetLabel.text = "\(self.data.sunset) seconds"
        highLabel.text = "\(self.data.high)ºC"
        lowLabel.text = "\(self.data.low)ºC"
        chanceOfRainLabel.text = "\(self.data.chanceRain)%"
    }
    
    func presentErrorWithMessage(message: String) {
        let alert = UIAlertController(title: "Data could not be feched", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
              switch action.style{
              case .default:
                print("default")
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
