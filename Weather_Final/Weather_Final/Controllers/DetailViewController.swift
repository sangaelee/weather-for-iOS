//
//  DetailViewController.swift
//  WeatherPro
//
//  Created by user144724 on 10/6/18.
//  Copyright © 2018 sangaeLee. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController , WeatherInfoDelegate, UIWebViewDelegate {

    var weatherInfo = WeatherInfo()
    var selectedCity = "" as String
    var cityName : String = ""
    //for current weather
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var humidLabel: UILabel!
    @IBOutlet weak var ctempLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    //for forcast weather
    
    @IBOutlet weak var day3Label: UILabel!
    @IBOutlet weak var day1Label: UILabel!
    
    @IBOutlet weak var day2Label: UILabel!
    
    
    @IBOutlet weak var day1ImageView: UIImageView!
    
    @IBOutlet weak var day2ImageView: UIImageView!
    
    @IBOutlet weak var day3ImageView: UIImageView!
    
    @IBOutlet weak var day1TempLabel: UILabel!
    
    @IBOutlet weak var day2TempLabel: UILabel!
    
    
    @IBOutlet weak var day3TempLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherInfo.delegate = self
        displayCurrentWeather()
        displayForcastWeather()
        
        
    }
    
    func displayCurrentWeather() {
        
        self.cityLabel.text = selectedCity
        
        let tempDisplay = self.weatherInfo.weatherData.tempCurrent
        let tempC = tempDisplay - 273.15
        self.ctempLabel.text = String(format:" %.0f",tempC)+"°C"
        
        let humidDisplay = self.weatherInfo.weatherData.humidity
        self.humidLabel.text = String(format:" %.0f",humidDisplay)+"%"
        
        let tminDisplay = self.weatherInfo.weatherData.tempMin
        let tmaxDisplay = self.weatherInfo.weatherData.tempMax
        let min = (tminDisplay - 273.15)
        let minD = String(format:" %.0f",min) as String
        let max = (tmaxDisplay - 273.15)
        let maxD = String(format:" %.0f",max) as String
        self.tempLabel.text = "\(minD)° /\(maxD)°"
        
        let windDisplay = self.weatherInfo.weatherData.wind
        self.windLabel.text = String(format:" %.1f",windDisplay)+"mph"
        
        let descDisplay = self.weatherInfo.weatherData.description
        self.descLabel.text = descDisplay
        
        var iconImageFile = self.weatherInfo.weatherData.icon
        iconImageFile = iconImageFile.dropLast() + ".png"
        
        let iconImage = UIImage(named: iconImageFile)
        self.imageView.image = iconImage
        self.view.addSubview(self.imageView)
    }
    
    func displayForcastWeather() {
        
        if(self.weatherInfo.forcastData.count != 0) {
            let day1Date = self.weatherInfo.forcastData[0].forcastDate as String
            let day1tiDisplay = self.weatherInfo.forcastData[0].forcastTemp as Double
            let tempmin = (day1tiDisplay - 273.15)
            let tempMI = String(format:" %.0f",tempmin) as String
                        self.day1Label.text = day1Date
            self.day1TempLabel.text = "\(tempMI)°C"
            var icon1ImageFile = self.weatherInfo.forcastData[0].forcastIcon
            icon1ImageFile = icon1ImageFile.dropLast() + "small.png"
            let icon1Image = UIImage(named: icon1ImageFile)
            self.day1ImageView.image = icon1Image
            self.view.addSubview(self.day1ImageView)
            
            let day2Date = self.weatherInfo.forcastData[1].forcastDate as String
            let day2tiDisplay = self.weatherInfo.forcastData[1].forcastTemp as Double
            
            let tempmin2 = (day2tiDisplay - 273.15)
            let tempMI2 = String(format:" %.0f",tempmin2) as String
            self.day2Label.text = day2Date
            self.day2TempLabel.text = "\(tempMI2)°C"
            var icon2ImageFile = self.weatherInfo.forcastData[1].forcastIcon
            icon2ImageFile = icon2ImageFile.dropLast() + "small.png"
            let icon2Image = UIImage(named: icon2ImageFile)
            self.day2ImageView.image = icon2Image
            self.view.addSubview(self.day2ImageView)
            
            let day3Date = self.weatherInfo.forcastData[2].forcastDate as String
            let day3tiDisplay = self.weatherInfo.forcastData[2].forcastTemp as Double
            let tempmin3 = (day3tiDisplay - 273.15)
            let tempMI3 = String(format:" %.0f",tempmin3) as String
            self.day3Label.text = day3Date
            self.day3TempLabel.text = "\(tempMI3)°C"
            var icon3ImageFile = self.weatherInfo.forcastData[2].forcastIcon
            icon3ImageFile = icon3ImageFile.dropLast() + "small.png"
            let icon3Image = UIImage(named: icon3ImageFile)
            self.day3ImageView.image = icon3Image
            self.view.addSubview(self.day2ImageView)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    @IBAction func WebPressed(_ sender: Any) {
        if let url = URL(string: "https://www.theweathernetwork.com/ca") {
           UIApplication.shared.open(url, options: [:])
        }
    }


    @IBAction func ReloadPressed(_ sender: Any) {
        self.weatherInfo.getWeather(city: selectedCity, saveIndex: false)
        self.weatherInfo.getWeatherForcast(city: selectedCity)
        self.viewDidLoad()
    }
    
    func setWeather(weather wi:WeatherInfo) {
        self.weatherInfo = wi
        self.viewDidLoad()
    }
    
    func jsonErrorMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }
}
