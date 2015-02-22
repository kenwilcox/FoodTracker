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
  
  var searchController: UISearchController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
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
    return cell
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 0
  }
}

// MARK: UISearchBarDelegate
extension ViewController: UISearchBarDelegate {
  
}

// MARK: UISearchControllerDelegate
extension ViewController: UISearchControllerDelegate {
  
}

// MARK: UISearchResultsUpdating
extension ViewController: UISearchResultsUpdating {
  func updateSearchResultsForSearchController(searchController: UISearchController) {
    
  }
}
