//
//  SearchViewController.swift
//  WeatherPro
//
//  Created by SangaeLee on 10/6/18.
//  Copyright © 2018 sangaeLee. All rights reserved.
//

import UIKit
import CoreData

protocol SearchDelegate {
    func saveCity(city: String)
}

class SearchViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    
    //delegate
    var delegate : SearchDelegate?
    
    var weatherInfo = WeatherInfo()
    var citySearch = CitySearch()
    
    var searchActive : Bool = false
    var filtered:[String] = []
    var data = [String]()
    var myAppDelegate :AppDelegate?
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    override func viewDidLoad() {
       super.viewDidLoad()
     
      // self.weatherInfo.delegate = self
       self.searchBar.becomeFirstResponder()
        
    }
    
    @IBAction func CancelPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    func setWeather(weather wi:WeatherInfo) {
        //self.weatherInfo = wi
        self.dismiss(animated: true)
        self.tableView.reloadData()
    }
    
    func jsonErrorMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        data = self.citySearch.cityArray
        filtered = data.filter{$0.range(of :searchText, options: .caseInsensitive) !=  nil}
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchcell") as! UITableViewCell
        if(searchActive){
            cell.textLabel?.text = filtered[indexPath.row]
        } else {
            cell.textLabel?.text = data[indexPath.row];
        }
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return data.count;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //getting the index path of selected row
        let indexPath = tableView.indexPathForSelectedRow
        //getting the current cell from the index path
        let currentCell = tableView.cellForRow(at: indexPath!)
        let cityName = currentCell!.textLabel!.text
        
        if self.isExistedCity(city: cityName!) {
             self.jsonErrorMessage(message: "This City already Existed!")
        }
        else {
            self.weatherInfo.getWeather(city: cityName!, saveIndex: true)
            if self.delegate != nil {
                print("delegate from serchview")
                self.delegate?.saveCity(city: cityName!)
                self.dismiss(animated: true)
                
            }
        }
        
    }
    
    //check city duplication
    func isExistedCity(city: String)->Bool {
        var names:[String] = []
        var count : Int = 0
        
        let managedContext = myAppDelegate!.persistentContainer.viewContext
        var cityCoreData : [CityWeather] = []
        let myFetrequest :NSFetchRequest<CityWeather> = CityWeather.fetchRequest()
        
        do
        {
            cityCoreData =  try managedContext.fetch(myFetrequest)
        }catch{
            
        }
        count = cityCoreData.count
        if(count == 0) {
            return false
        }
        else {
            for index in 0...count - 1{
                let cityData = cityCoreData[index]
                let cityName = cityData.value(forKey: "city") as! String
                names.append(cityName)
            }
        
            for index in 0...names.count - 1 {
                if(names[index] == city) {
                    return true
                }
            }
        }
        return false
        
    }
}

