//
//  DataController.swift
//  FoodTracker
//
//  Created by Kenneth Wilcox on 3/6/15.
//  Copyright (c) 2015 Kenneth Wilcox. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataController {
  init() {
    
  }
  
  class func jsonAsUSDAIdAndNameSearchResults (json : NSDictionary) -> [(name: String, idValue: String)] {
    
    var usdaItemsSearchResults:[(name : String, idValue: String)] = []
    var searchResult: (name: String, idValue : String)
    
    // And this folks is how a new language is designed to work? Um...
    if json["hits"] != nil {
      let results:[AnyObject] = json["hits"]! as [AnyObject]
      for itemDictionary in results {
        if itemDictionary["_id"] != nil {
          if itemDictionary["fields"] != nil {
            let fieldsDictionary = itemDictionary["fields"] as NSDictionary
            if fieldsDictionary["item_name"] != nil {
              let idValue:String = itemDictionary["_id"]! as String
              let name:String = fieldsDictionary["item_name"]! as String
              searchResult = (name : name, idValue : idValue)
              usdaItemsSearchResults += [searchResult]
            }
          }
        }
      }
    }
    return usdaItemsSearchResults
  }
  
  var usdaFieldsDictionary: NSDictionary!
  
  func usdaFieldForKey(key: String) -> String {
    if usdaFieldsDictionary != nil {
      if let keyDictionary = usdaFieldsDictionary[key] as? NSDictionary {
        let value: AnyObject = keyDictionary["value"]!
        return "\(value)"
      }
    }
    return "0"
  }
  
  func saveUSDAItemForId(idValue: String, json: NSDictionary) {
    if json["hits"] != nil {
      let results:[AnyObject] = json["hits"]! as [AnyObject]
      for itemDictionary in results {
        if itemDictionary["_id"] != nil && itemDictionary["_id"] as String == idValue {
          let managedObjectContext = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext
          var requestForUSDAItem = NSFetchRequest(entityName: "USDAItem")
          //let itemDictionaryId = itemDictionary["_id"]! as String // redundant
          
          let predicate = NSPredicate(format: "idValue == %@", idValue)
          requestForUSDAItem.predicate = predicate
          
          var error: NSError?
          var items = managedObjectContext?.executeFetchRequest(requestForUSDAItem, error: &error)
          
          if items?.count != 0 {
            println("The item is already saved!")
            return
          } else {
            println("Lets Save this to CoreData!")
            
            let entityDescription = NSEntityDescription.entityForName("USDAItem", inManagedObjectContext: managedObjectContext!)
            
            let usdaItem = USDAItem(entity: entityDescription!, insertIntoManagedObjectContext: managedObjectContext!)
            usdaItem.idValue = itemDictionary["_id"]! as String
            usdaItem.dateAdded = NSDate()
            
            if itemDictionary["fields"] != nil {
              let fieldsDictionary = itemDictionary["fields"]! as NSDictionary
              if fieldsDictionary["item_name"] != nil {
                usdaItem.name = fieldsDictionary["item_name"]! as String
                
                if fieldsDictionary["usda_fields"] != nil {
                  usdaFieldsDictionary = fieldsDictionary["usda_fields"]! as NSDictionary
                  
                  // Calcium
                  usdaItem.calcium = usdaFieldForKey("CA")
                  
                  // Carbs
                  usdaItem.carbohydrate = usdaFieldForKey("CHOCDF")
                  
                  // Fat
                  usdaItem.fatTotal = usdaFieldForKey("FAT")
                  
                  // Cholesterol
                  usdaItem.cholesterol = usdaFieldForKey("CHOLE")
                  
                  // Protein
                  usdaItem.protein = usdaFieldForKey("PROCNT")
                  
                  // Sugar
                  usdaItem.sugar = usdaFieldForKey("SUGAR")
                  
                  // Vitamin C
                  usdaItem.vitaminC = usdaFieldForKey("VITC")
                  
                  // Energy
                  usdaItem.energy = usdaFieldForKey("ENERC_KCAL")
                  
                  // set to nil for the next time around
                  usdaFieldsDictionary = nil;
                  
                } // end usda_fields
                
                (UIApplication.sharedApplication().delegate as AppDelegate).saveContext()
              }
            }
          }
        }
      }
    }
  }
  
}
