//
//  CityWeather+CoreDataProperties.swift
//  
//
//  Created by user144724 on 10/16/18.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension CityWeather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CityWeather> {
        return NSFetchRequest<CityWeather>(entityName: "CityWeather")
    }

    @NSManaged public var city: String?

}
