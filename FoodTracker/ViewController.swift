//
//  ViewController.swift
//  FoodTracker
//
//  Created by Kenneth Wilcox on 2/21/15.
//  Copyright (c) 2015 Kenneth Wilcox. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  let kAppId = "--get your own--"
  let kAppKey = "at http://developer.nutritionix.com"
  
  var searchController: UISearchController!
  var suggestedSearchFoods: [String] = []
  var filteredSuggestedSearchFoods: [String] = []
  var searchString: String?
  var scopeButtonTitles = ["Recommended", "Search Results", "Saved"]
  
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
  
}

// MARK: UITableViewDelegate
extension ViewController: UITableViewDelegate {
  
}

// MARK: UITableViewDataSource
extension ViewController: UITableViewDataSource {
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell
    var foodName: String
    
    if self.searchController.active && self.searchString! != "" {
      foodName = filteredSuggestedSearchFoods[indexPath.row]
    } else {
      foodName = suggestedSearchFoods[indexPath.row]
    }
    
    cell.textLabel?.text = foodName
    cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if self.searchController.active && self.searchString! != "" {
      return self.filteredSuggestedSearchFoods.count
    } else {
      return self.suggestedSearchFoods.count
    }
  }
}

// MARK: UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(searchBar: UISearchBar) {
    makeRequest(searchBar.text)
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
    let url = NSURL(string: "https://api.nutritionix.com/v1_1/search/\(searchString)?results=0%3A20&cal_min=0&cal_max=50000&fields=item_name%2Cbrand_name%2Citem_id%2Cbrand_id&appId=\(kAppId)&appKey=\(kAppKey)")
    let task = NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
      var stringData = NSString(data: data, encoding: NSUTF8StringEncoding)
      println(stringData)
      println(response)
    })
    task.resume()
  }
}

