//
//  WeatherInfo.swift
//  WeatherPro
//
//  Created by Sangae Lee on 10/6/18.
//  Copyright © 2018 sangaeLee. All rights reserved.
//

import Foundation
import CoreData
import UIKit

//define delegate
protocol WeatherInfoDelegate {
    func setWeather(weather:WeatherInfo)
    func jsonErrorMessage(message:String)
}


//Weather Info model
class WeatherInfo {

    //CoreData Objects
    var cityCoreData : [CityWeather] = []
    //lazy var cityCoreData: [NSManagedObject] = []
    lazy var parseJson = ParseJson()
   
    //delegate
    var delegate : WeatherInfoDelegate?
    
    struct WeatherData {
        var cityName = "" as String
        var tempCurrent = 0.0 as Double
        var tempMin = 0.0 as Double
        var tempMax = 0.0 as Double
        var description = "" as String
        var icon = "" as String
        var humidity = 0.0 as Double
        var wind = 0.0 as Double
    }
    struct ForcastData {
        var forcastDate: String
        var forcastTemp: Double
        var forcastIcon: String
    }
    
    lazy var weatherData = WeatherData()
    var forcastData:[ForcastData] = []
    lazy var myAppDelegate :AppDelegate = {
        return(UIApplication.shared.delegate as! AppDelegate)
    }()
    
    
    // get weather 7day forcast data from Server
    func getWeatherForcast(city : String) {
        print("getWeatherForcast=\(city)")
        var errCode = 0
        
        var fDate: String = ""
        var fTemp: Double = 0
        var fIcon: String = ""
        forcastData.removeAll()
        let urlBase = "http://api.openweathermap.org/data/2.5/forecast?q=\(city)&APPID=cba928d6f7f30fba6271425601a2747c"
        self.parseJson.parsingJsonData(from: urlBase) { (jsonObj : NSDictionary) in
        errCode = jsonObj.value(forKey: "cod") as? Int ?? 200
        if errCode == 200 {
            if let weatherArray = jsonObj.value(forKey:"list") as? [[String: Any]] {
                for item in weatherArray {
                if let wDate = item["dt_txt"] as? String{
                     let compareString = "12:00:00"
                     if(wDate.contains(compareString)) {
                        let tempDate =  String(wDate.dropFirst(5))
                        fDate = String(tempDate.dropLast(9))
                        if let main1Dictionary = item["main"] as? NSDictionary {
                            fTemp = main1Dictionary.value(forKey: "temp") as! Double
                        }
                        if let weatherAr = item["weather"] as? [[String: Any]]{
                            fIcon = weatherAr[0]["icon"] as! String
                       }//if let weather
                        
                       self.forcastData.append(ForcastData(forcastDate: fDate, forcastTemp: fTemp,forcastIcon: fIcon))
                        
                        }//print("forcast in cnt=\(forcastData.count )")
                        
                    }//wdate.
                    
                }//for
                DispatchQueue.main.async {
                    if self.delegate != nil{
                         self.delegate?.setWeather(weather: self)
                    }
                }//self delegate                 }
        }//Errocode
            }//self
        }
        
    }//func
    

    
    
    // get weather data from Server
    func getWeather(city : String, saveIndex: Bool) {
        var errCode = 0
        let urlBase =    "http://api.openweathermap.org/data/2.5/weather?q=\(city)&APPID=cba928d6f7f30fba6271425601a2747c"
        self.parseJson.parsingJsonData(from: urlBase) { (jsonObj : NSDictionary) in
            errCode = jsonObj.value(forKey: "cod") as? Int ?? 200
            if errCode == 200 {
                if let mainDictionary = jsonObj.value(forKey: "main") as? NSDictionary {
                    self.weatherData.tempCurrent = mainDictionary.value(forKey: "temp") as! Double
                    self.weatherData.tempMin = mainDictionary.value(forKey: "temp_min") as! Double
                    self.weatherData.tempMax =  mainDictionary.value(forKey: "temp_max") as! Double
                    self.weatherData.humidity =  mainDictionary.value(forKey: "humidity") as! Double
                    
                }
                if let windDictionary = jsonObj.value(forKey: "wind") as? NSDictionary {
                    self.weatherData.wind = windDictionary.value(forKey: "speed") as! Double
                    
                }
                if let jsonArray = jsonObj.value(forKey: "weather") as? [[String: Any]] {
                    self.weatherData.description = jsonArray[0]["description"] as! String
                    self.weatherData.icon = jsonArray[0]["icon"] as! String
                }
                if self.delegate != nil {
                    DispatchQueue.main.async {
                        if saveIndex == true {
                  
                            self.delegate?.setWeather(weather: self)
                        }
                    }//dispatch
                }//self delegate
        
            }
            else if errCode == 404 {
                if self.delegate != nil {
                     DispatchQueue.main.async {
                       self.delegate?.jsonErrorMessage(message: "City not Found")
                     }
                }
            }
                        
            else  {
                if self.delegate != nil {
                     DispatchQueue.main.async {
                           print("error=\(errCode)")
                            self.delegate?.jsonErrorMessage(message: "Something Wrong")
                     }
                 }
            }
    }

}


    
 
}

