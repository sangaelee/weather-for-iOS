//
//  ParseJson.swift
//  WeatherPro
//
//  Created by user144724 on 10/9/18.
//  Copyright © 2018 sangaeLee. All rights reserved.
//

import Foundation
class ParseJson: NSObject {
    
    
    
    // execute GET request and pass data from escaping closure
    func executeGetRequest(with urlString: String, completion: @escaping (Data?) -> ()) {
        
        let escapedString = urlString.replacingOccurrences(of: " ", with: "%20")
        let url = URL(string: escapedString)
        
        let dataTask = URLSession.shared.dataTask(with: url!) {
            (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error.debugDescription)
            } else {
                //  Passing the data from closure to the calling method
                completion(data)
            }
        };dataTask.resume()
    }
    
    
    func parsingJsonData(from urlString: String, completion: @escaping (NSDictionary) -> ()) {
        //  Calling executeGetRequest(with:)
        
        
        self.executeGetRequest(with: urlString) { (data) in  // Data received from closure
            do {
                //  JSON Serialization
                let responseDict = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary
                //  Passing parsed JSON data from closure to the calling method.
                completion(responseDict!)
                
            } catch {
                print("ERROR: could not retrieve response")
            }
        }
        
    }
    
    func parsingJsonCityData(from urlString: String, completion: @escaping ([[String: Any]]) -> ()) {
       
            self.executeGetRequest(with: urlString) { (data) in  // Data received from closure
                do {
                    //  JSON parsing
                    let responseDict = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [[String: Any]]
                    
                    //  Passing parsed JSON data from closure to the calling method.
                    completion(responseDict!)
                    
                } catch {
                    print("ERROR: could not retrieve response")
                }
            }
     }
 
}

