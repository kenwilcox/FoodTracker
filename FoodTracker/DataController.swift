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
}
