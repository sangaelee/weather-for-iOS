//
//  ViewController.swift
//  WeatherPro
//
//  Created by user144724 on 10/6/18.
//  Copyright © 2018 sangaeLee. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,WeatherInfoDelegate,SearchDelegate,UISearchBarDelegate,NSFetchedResultsControllerDelegate {
 
    lazy var weatherInfo = WeatherInfo()
    lazy var citySearch = CitySearch()
    var filtered:[String] = []
    var data = [String]()
    var selectedCity = "" as String
    var cityName = "" as String
    var temp = 0.0 as Double
    var tempMin = 0.0 as Double
    var tempMax = 0.0 as Double
    
    @IBOutlet weak var myTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherInfo.delegate = self
        self.citySearch.parseCityJson()
        performFetchfucntion()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    lazy var myAppdelegate : AppDelegate = {
        return (UIApplication.shared.delegate as! AppDelegate)
    }()
    
    lazy var fetchcontroller : NSFetchedResultsController<CityWeather> = {
          print("fetchcontroller")
            let fetch = NSFetchRequest<CityWeather>(entityName: "CityWeather")
            let sort1 =  NSSortDescriptor(key: "city", ascending: true)
            fetch.sortDescriptors = [sort1]
            let tempFetch =  NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: myAppdelegate.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            tempFetch.delegate = self;
            return tempFetch
            
    }()
    
    /* protocol fuction for weatherInfo */
    func setWeather(weather wi:WeatherInfo) {
        self.weatherInfo = wi
        self.myTableView.reloadData()
    }
    
    /* display Error Alert box*/
    func jsonErrorMessage(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    /*Save city into coredata*/
    func saveCity(city: String) {
        let cityData =  NSEntityDescription.insertNewObject(forEntityName: "CityWeather", into: myAppdelegate.persistentContainer.viewContext) as! CityWeather
        cityData.city = city
        myAppdelegate.saveContext()
    }
    
    //searching city
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
        let myPredicate : NSPredicate?
        if(searchText.count > 0){
            myPredicate =  NSPredicate(format: "city Contains[c] %@", searchText)
        }
        else{
            myPredicate = nil
        }
        fetchcontroller.fetchRequest.predicate = myPredicate;
        performFetchfucntion()
        myTableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    //method for tableview
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (fetchcontroller.sections![section]).numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "citycell")
        let city = fetchcontroller.object(at: indexPath)
        cell!.textLabel?.text = city.city
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle == .delete){
            let toDelteObj = fetchcontroller.object(at: indexPath)
            myAppdelegate.persistentContainer.viewContext.delete(toDelteObj)
            myAppdelegate.saveContext()
        }
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Delete"
    }
    
    // Method for Controller
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        myTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            myTableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            myTableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            myTableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            myTableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            myTableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            myTableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        myTableView.endUpdates()
    }
    
  //fetch Data using Controller
    func performFetchfucntion() {
        do
        {
            try  fetchcontroller.performFetch()
        }catch{
            
        }
    }
   // when pressed DeleteAll Button
    @IBAction func DeletedPressed(_ sender: Any) {
        var cityCoreData : [CityWeather] = []
        let managedContext = myAppdelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CityWeather")
        
        fetchRequest.includesPropertyValues = false
        do {
            cityCoreData = try managedContext.fetch(fetchRequest) as! [CityWeather]
                
        } catch let error as NSError {
                print("Could not fetch. \(error), \(error.userInfo)")
        }
            
        for item in cityCoreData {
            managedContext.delete(item)
        }
        do{
           try managedContext.save()
        }catch {
                
        }
  
        performFetchfucntion()
    
        myTableView.reloadData()
    }
    
 
    // Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "citydetail" {
            
            let indexPath = self.myTableView.indexPathForSelectedRow
            let currentCell = self.myTableView.cellForRow(at: indexPath!)! as UITableViewCell
            selectedCity = currentCell.textLabel?.text as! String
            
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.selectedCity = selectedCity
            destinationVC.weatherInfo = self.weatherInfo
            self.weatherInfo.getWeather(city: selectedCity, saveIndex: false)
            self.weatherInfo.getWeatherForcast(city: selectedCity)
            
        }
        else if segue.identifier == "searchview" {
            print("prepareSegue")
            let destinationVC = segue.destination as! SearchViewController
            destinationVC.myAppDelegate = self.myAppdelegate
            destinationVC.weatherInfo = self.weatherInfo
            destinationVC.citySearch = self.citySearch
            destinationVC.delegate = self
        }
        
    }
}

