//
//  DetailViewController.swift
//  FoodTracker
//
//  Created by Kenneth Wilcox on 2/21/15.
//  Copyright (c) 2015 Kenneth Wilcox. All rights reserved.
//

import UIKit
import HealthKit

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
    requestAuthorizationForHealthStore()
    
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
    saveFoodItem(self.usdaItem!)
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
  
  func requestAuthorizationForHealthStore() {
    let dataTypesToWrite = [
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCalcium),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCarbohydrates),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCholesterol),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryEnergyConsumed),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryFatTotal),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryProtein),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietarySugar),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryVitaminC)
    ]
    
    let dataTypesToRead = [
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCalcium),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCarbohydrates),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCholesterol),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryEnergyConsumed),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryFatTotal),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryProtein),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietarySugar),
      HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryVitaminC)
    ]
    
    var store: HealthStoreConstant = HealthStoreConstant()
    store.healthStore?.requestAuthorizationToShareTypes(NSSet(array: dataTypesToWrite), readTypes: NSSet(array: dataTypesToRead), completion: { (success, error) -> Void in
      if success {
        println("User completed authorization request.")
      } else {
        println("User canceled the request \(error)")
      }
    })
  }
  
  func saveFoodItem (foodItem : USDAItem) {
    if HKHealthStore.isHealthDataAvailable() {
      let timeFoodWasEntered = NSDate()
      let foodMetaData = [
        HKMetadataKeyFoodType : foodItem.name,
        "HKBrandName" : "USDAItem",
        "HKFoodTypeID" : foodItem.idValue
      ]
      
      let energyUnit = HKQuantity(unit: HKUnit.kilocalorieUnit(), doubleValue: (foodItem.energy as NSString).doubleValue)
      let calories = HKQuantitySample(type: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryEnergyConsumed), quantity: energyUnit, startDate: timeFoodWasEntered, endDate: timeFoodWasEntered)
      
      let calciumUnit = HKQuantity(unit: HKUnit.gramUnitWithMetricPrefix(HKMetricPrefix.Milli), doubleValue: (foodItem.calcium as NSString).doubleValue)
      let calcium = HKQuantitySample(type: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCalcium), quantity: calciumUnit, startDate: timeFoodWasEntered, endDate: timeFoodWasEntered)
      
      let carbohydrateUnit = HKQuantity(unit: HKUnit.gramUnit(), doubleValue: (foodItem.carbohydrate as NSString).doubleValue)
      let carbohydrates = HKQuantitySample(type: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCarbohydrates), quantity: carbohydrateUnit, startDate: timeFoodWasEntered, endDate: timeFoodWasEntered)
      
      let fatTotalUnit = HKQuantity(unit: HKUnit.gramUnit(), doubleValue: (foodItem.fatTotal as NSString).doubleValue)
      let fatTotal = HKQuantitySample(type: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryFatTotal), quantity: fatTotalUnit, startDate: timeFoodWasEntered, endDate: timeFoodWasEntered)
      
      let proteinUnit = HKQuantity(unit: HKUnit.gramUnit(), doubleValue: (foodItem.protein as NSString).doubleValue)
      let protein = HKQuantitySample(type: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryProtein), quantity: proteinUnit, startDate: timeFoodWasEntered, endDate: timeFoodWasEntered)
      
      let sugarUnit = HKQuantity(unit: HKUnit.gramUnit(), doubleValue: (foodItem.sugar as NSString).doubleValue)
      let sugar = HKQuantitySample(type: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietarySugar), quantity: sugarUnit, startDate: timeFoodWasEntered, endDate: timeFoodWasEntered)
      
      let vitaminCUnit = HKQuantity(unit: HKUnit.gramUnitWithMetricPrefix(HKMetricPrefix.Milli), doubleValue: (foodItem.vitaminC as NSString).doubleValue)
      let vitaminC = HKQuantitySample(type: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryVitaminC), quantity: vitaminCUnit, startDate: timeFoodWasEntered, endDate: timeFoodWasEntered)
      
      let cholesterolUnit = HKQuantity(unit: HKUnit.gramUnitWithMetricPrefix(HKMetricPrefix.Milli), doubleValue: (foodItem.cholesterol as NSString).doubleValue)
      let cholesterol = HKQuantitySample(type: HKQuantityType.quantityTypeForIdentifier(HKQuantityTypeIdentifierDietaryCholesterol), quantity: cholesterolUnit, startDate: timeFoodWasEntered, endDate: timeFoodWasEntered)
      
      let foodDataSet = NSSet(array: [calories, calcium, carbohydrates, cholesterol, fatTotal, protein, sugar, vitaminC])
      let foodCoorelation = HKCorrelation(type: HKCorrelationType.correlationTypeForIdentifier(HKCorrelationTypeIdentifierFood), startDate: timeFoodWasEntered, endDate: timeFoodWasEntered, objects: foodDataSet, metadata : foodMetaData)
      
      var store:HealthStoreConstant = HealthStoreConstant()
      store.healthStore?.saveObject(foodCoorelation, withCompletion: { (success, error) -> Void in
        if success {
          println("Saved Successfully")
        } else {
          println("Error Occurred: \(error)")
        }
      })
      

    }
  }
}
