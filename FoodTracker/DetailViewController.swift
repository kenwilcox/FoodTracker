//
//  DetailViewController.swift
//  FoodTracker
//
//  Created by Kenneth Wilcox on 2/21/15.
//  Copyright (c) 2015 Kenneth Wilcox. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  
  @IBOutlet weak var textView: UITextView!
  
  var usdaItem:USDAItem?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func eatItBarButtonItemPressed(sender: UIBarButtonItem) {
  }
}
