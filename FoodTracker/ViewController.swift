//
//  ViewController.swift
//  FoodTracker
//
//  Created by Kenneth Wilcox on 2/21/15.
//  Copyright (c) 2015 Kenneth Wilcox. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  
  var searchController: UISearchController!
  var suggestedSearchFoods: [String] = []
  var filteredSuggestedSearchFoods: [String] = []
   var apiSearchForFoods:[(name: String, idValue: String)] = []
  var searchString: String?
  var scopeButtonTitles = ["Recommended", "Search Results", "Saved"]
  var jsonResponse:NSDictionary!
  var dataController = DataController()
  var favoritedUSDAItems:[USDAItem] = []
 
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    self.searchController = UISearchController(searchResultsController: nil)
    self.searchController.searchResultsUpdater = self
    self.searchController.dimsBackgroundDuringPresentation = false
    self.searchController.hidesNavigationBarDuringPresentation = false
    
    self.searchController.searchBar.frame = CGRect(x: self.searchController.searchBar.frame.origin.x, y: self.searchController.searchBar.frame.origin.y, width: self.searchController.searchBar.frame.size.width, height: 44.0)
    // stick the searchbar in the header
    self.tableView.tableHeaderView = self.searchController.searchBar
    
    self.searchController.searchBar.scopeButtonTitles = self.scopeButtonTitles
    self.searchController.searchBar.delegate = self
    
    // ensure the search results controller is presented inside the view controller
    self.definesPresentationContext = true
    
    self.suggestedSearchFoods = ["apple", "bagel", "banana", "beer", "bread", "carrots", "cheddar cheese", "chicken breast", "chili with beans", "chocolate chip cookie", "coffee", "cola", "corn", "egg", "graham cracker", "granola bar", "green beans", "ground beef patty", "hot dog", "ice cream", "jelly doughnut", "ketchup", "milk", "mixed nuts", "mustard", "oatmeal", "orange juice", "peanut butter", "pizza", "pork chop", "potato", "potato chips", "pretzels", "raisins", "ranch salad dressing", "red wine", "rice", "salsa", "shrimp", "spaghetti", "spaghetti sauce", "tuna", "white wine", "yellow cake"]
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func requestFavoritedUSDAItems () {
    let fetchRequest = NSFetchRequest(entityName: "USDAItem")
    let appDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
    let managedObjectContext = appDelegate.managedObjectContext
    self.favoritedUSDAItems = managedObjectContext?.executeFetchRequest(fetchRequest, error: nil) as [USDAItem]
  }
}

// MARK: UITableViewDelegate
extension ViewController: UITableViewDelegate {
  
}

// MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
    var foodName: String
    let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
    
    if selectedScopeButtonIndex == 0 {
      if self.searchController.active && self.searchString! != "" {
        foodName = filteredSuggestedSearchFoods[indexPath.row]
      } else {
        foodName = suggestedSearchFoods[indexPath.row]
      }
    }
    else if selectedScopeButtonIndex == 1 {
      foodName = apiSearchForFoods[indexPath.row].name
    } else {
      foodName = self.favoritedUSDAItems[indexPath.row].name
    }
    
    cell.textLabel?.text = foodName
    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
    if selectedScopeButtonIndex == 0 {
      if self.searchController.active && self.searchString! != "" {
        return self.filteredSuggestedSearchFoods.count
      } else {
        return self.suggestedSearchFoods.count
      }
    } else if selectedScopeButtonIndex == 1 {
      return self.apiSearchForFoods.count
    } else {
      return self.favoritedUSDAItems.count
    }
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
    if selectedScopeButtonIndex == 0 {
      var searchFoodName:String
      if self.searchController.active {
        searchFoodName = filteredSuggestedSearchFoods[indexPath.row]
      } else {
        searchFoodName = suggestedSearchFoods[indexPath.row]
      }
      self.searchController.searchBar.selectedScopeButtonIndex = 1
      makeRequest(searchFoodName)
    } else if selectedScopeButtonIndex == 1 {
      let idValue = apiSearchForFoods[indexPath.row].idValue
      self.dataController.saveUSDAItemForId(idValue, json: self.jsonResponse)
    } else if selectedScopeButtonIndex == 2 {
      
    }
  }
}

// MARK: UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    self.searchController.searchBar.selectedScopeButtonIndex = 1
    makeRequest(searchBar.text)
  }
  
  func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    if selectedScope == 2 {
      requestFavoritedUSDAItems()
    }
    self.tableView.reloadData()
  }
}

// MARK: UISearchControllerDelegate
extension ViewController: UISearchControllerDelegate {
  
}

// MARK: UISearchResultsUpdating
extension ViewController: UISearchResultsUpdating {
  func filterContentForSearch (searchText: String, scope: Int) {
    self.filteredSuggestedSearchFoods = self.suggestedSearchFoods.filter({ (food: String) -> Bool in
      var foodMatch = food.rangeOfString(searchText)
      return foodMatch != nil
    })
  }
  
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    self.searchString = self.searchController.searchBar.text
    let selectedScopeButtonIndex = self.searchController.searchBar.selectedScopeButtonIndex
    self.filterContentForSearch(self.searchString!, scope: selectedScopeButtonIndex)
    self.tableView.reloadData()
  }
  
  func makeRequest(searchString: String) {
    // Get Request - not using this, but kept for reference.
//    let url = NSURL(string: "https://api.nutritionix.com/v1_1/search/\(searchString)?results=0%3A20&cal_min=0&cal_max=50000&fields=item_name%2Cbrand_name%2Citem_id%2Cbrand_id&appId=\(kAppId)&appKey=\(kAppKey)")
//    let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
//      var stringData = NSString(data: data, encoding: NSUTF8StringEncoding)
//      println(stringData)
//      println(response)
//    })
//    task.resume()
    
    var request = NSMutableURLRequest(URL: NSURL(string: "https://api.nutritionix.com/v1_1/search/")!)
    let session = NSURLSession.sharedSession()
    request.HTTPMethod = "POST"
    
    var params = [
      "appId" : kAppId,
      "appKey" : kAppKey,
      "fields" : ["item_name", "brand_name", "keywords", "usda_fields"],
      "limit"  : "50",
      "query"  : searchString,
      "filters": ["exists":["usda_fields": true]]
    ]
    
    var error: NSError?
    request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params, options: nil, error: &error)
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    // Update the UI with the network spinner
    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    
    var task = session.dataTaskWithRequest(request, completionHandler: { (data, response, err) -> Void in
//      var stringData = NSString(data: data, encoding: NSUTF8StringEncoding)
//      println(stringData)
      
      var conversionError: NSError?
      var jsonDictionary = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableLeaves, error: &conversionError) as? NSDictionary
      
//      println(jsonDictionary)
      
      if conversionError != nil {
        println(conversionError!.localizedDescription)
        let errorString = NSString(data: data, encoding: NSUTF8StringEncoding)
        println("Error in Parsing \(errorString)")
      }
      else {
        if jsonDictionary != nil {
          self.jsonResponse = jsonDictionary!
          self.apiSearchForFoods = DataController.jsonAsUSDAIdAndNameSearchResults(jsonDictionary!)
          
          UIApplication.sharedApplication().networkActivityIndicatorVisible = false
          // Update table view on main thread
          dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.tableView.reloadData()
          })
        } else {
          let errorString = NSString(data: data, encoding: NSUTF8StringEncoding)
          println("Error Could not Parse JSON \(errorString)")
        }                
      }
      
    })
    task.resume()
  }
}

