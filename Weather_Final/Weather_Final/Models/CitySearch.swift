//
//  CitySearch.swift
//  WeatherPro
//
//  Created by Sangae Lee on 10/6/18.
//  Copyright © 2018 sangaeLee. All rights reserved.
//

import Foundation

class CitySearch {
    lazy var cityArray = [String]()
    lazy var parseJson = ParseJson()

    func parseCityJson() {
       
        let urlBase = "https://pkgstore.datahub.io/core/world-cities/world-cities_json/data/5b3dd46ad10990bca47b04b4739a02ba/world-cities_json.json"
                
        self.parseJson.parsingJsonCityData(from: urlBase) { (jsonObj : [[String: Any]]) in
            DispatchQueue.main.async {
                for item in jsonObj {
                    self.cityArray.append(item["name"] as! String)
                }
            }
        }
                
    }
}
