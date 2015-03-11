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
    
    let calciumTitleString = NSAttributedString(string: "Calcium ", attributes: styleFirstWordAttributesDictionary)
    let calciumBodyString = NSAttributedString(string: "\(usdaItem.calcium)% \n", attributes: style1AttributesDictionary)
    
    itemAttributedString.appendAttributedString(calciumTitleString)
    itemAttributedString.appendAttributedString(calciumBodyString)
    
    let carbohydrateTitleString = NSAttributedString(string: "Carbohydrate ", attributes: styleFirstWordAttributesDictionary)
    let carbohydrateBodyString = NSAttributedString(string: "\(usdaItem.carbohydrate)% \n", attributes: style2AttributesDictionary)
    
    itemAttributedString.appendAttributedString(carbohydrateTitleString)
    itemAttributedString.appendAttributedString(carbohydrateBodyString)
    
    let cholesterolTitleString = NSAttributedString(string: "Cholesterol ", attributes: styleFirstWordAttributesDictionary)
    let cholesterolBodyString = NSAttributedString(string: "\(usdaItem.cholesterol)% \n", attributes: style1AttributesDictionary)
    
    itemAttributedString.appendAttributedString(cholesterolTitleString)
    itemAttributedString.appendAttributedString(cholesterolBodyString)
    
    return itemAttributedString
  }
}
