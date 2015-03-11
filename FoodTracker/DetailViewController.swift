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
  
  var usdaItem: USDAItem?
  var darkStyle: Bool = true
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "usdaItemDidComplete:", name: kUSDAItemCompleted, object: nil)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    // Do any additional setup after loading the view.
    if usdaItem != nil {
      textView.attributedText = createAttributedString(usdaItem!)
    }
  }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func usdaItemDidComplete(notification: NSNotification) {
    println("usdaItemDidComplete in DetailViewController")
    usdaItem = notification.object as? USDAItem
    if self.isViewLoaded() && self.view.window != nil {
      textView.attributedText = createAttributedString(usdaItem!)
    }
  }
  
  @IBAction func eatItBarButtonItemPressed(sender: UIBarButtonItem) {
  }
  
  func attributedString(title: String, fieldValue: String) -> NSAttributedString {
    var itemAttributedString = NSMutableAttributedString()
    
    var leftAllignedParagraphStyle = NSMutableParagraphStyle()
    leftAllignedParagraphStyle.alignment = NSTextAlignment.Left
    leftAllignedParagraphStyle.lineSpacing = 20.0
    
    var styleFirstWordAttributesDictionary = [
      NSForegroundColorAttributeName: UIColor.blackColor(),
      NSFontAttributeName: UIFont.boldSystemFontOfSize(18.0),
      NSParagraphStyleAttributeName: leftAllignedParagraphStyle]
    
    var style1AttributesDictionary = [
      NSForegroundColorAttributeName: UIColor.darkGrayColor(),
      NSFontAttributeName: UIFont.systemFontOfSize(18.0),
      NSParagraphStyleAttributeName: leftAllignedParagraphStyle]
    
    var style2AttributesDictionary = [
      NSForegroundColorAttributeName: UIColor.lightGrayColor(),
      NSFontAttributeName: UIFont.systemFontOfSize(18.0),
      NSParagraphStyleAttributeName: leftAllignedParagraphStyle]
    
    // This just toggles from darkGrayColor style to lightGrayColor style
    var style = darkStyle == true ? style1AttributesDictionary : style2AttributesDictionary
    darkStyle = !darkStyle
    
    let titleString = NSAttributedString(string: "\(title) ", attributes: styleFirstWordAttributesDictionary)
    //let bodyString = NSAttributedString(string: "\(fieldValue)% \n", attributes: style)
    let bodyString = NSAttributedString(string: String(format: "%.2f", (fieldValue as NSString).doubleValue) + "% \n", attributes: style)
    
    itemAttributedString.appendAttributedString(titleString)
    itemAttributedString.appendAttributedString(bodyString)
    
    return itemAttributedString
  }
  
  func createAttributedString (usdaItem: USDAItem!) -> NSAttributedString {
    var itemAttributedString = NSMutableAttributedString()
    
    var centeredParagraphStyle = NSMutableParagraphStyle()
    centeredParagraphStyle.alignment = NSTextAlignment.Center
    centeredParagraphStyle.lineSpacing = 10.0
    
    var titleAttributesDictionary = [
      NSForegroundColorAttributeName: UIColor.blackColor(),
      NSFontAttributeName: UIFont.boldSystemFontOfSize(22.0),
      NSParagraphStyleAttributeName: centeredParagraphStyle]
    
    let titleString = NSAttributedString(string: "\(usdaItem.name)\n", attributes: titleAttributesDictionary)
    itemAttributedString.appendAttributedString(titleString)
    
    itemAttributedString.appendAttributedString(attributedString("Calcium", fieldValue: usdaItem.calcium))
    itemAttributedString.appendAttributedString(attributedString("Carbohydrate", fieldValue: usdaItem.carbohydrate))
    itemAttributedString.appendAttributedString(attributedString("Cholesterol", fieldValue: usdaItem.cholesterol))
    itemAttributedString.appendAttributedString(attributedString("Energy", fieldValue: usdaItem.energy))
    itemAttributedString.appendAttributedString(attributedString("Fat Total", fieldValue: usdaItem.fatTotal))
    itemAttributedString.appendAttributedString(attributedString("Protein", fieldValue: usdaItem.protein))
    itemAttributedString.appendAttributedString(attributedString("Sugar", fieldValue: usdaItem.sugar))
    itemAttributedString.appendAttributedString(attributedString("Vitamin C", fieldValue: usdaItem.vitaminC))
    
    return itemAttributedString
  }
}
