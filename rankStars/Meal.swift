//
//  Meal.swift
//  rankStars
//
//  Created by 马宝森 on 2019/4/21.
//  Copyright © 2019 马宝森. All rights reserved.
//

import Foundation
import UIKit
import os.log

class Meal: NSObject, NSCoding{
    //MARK: properties
    var name: String
    var photo: UIImage?
    var rating: Int
    var price: Int
    var neededTime: Int
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("meals")
    
    //MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
        static let price = "price"
        static let neededTime = "neededTime"
    }
    
    //MARK: Initialization
    init?(name: String, photo: UIImage?, rating: Int, price: Int, neededTime: Int) {
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        guard (price >= 0) && (neededTime >= 0) else {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.rating = rating
        self.price = price
        self.neededTime = neededTime
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)
        aCoder.encode(price, forKey: PropertyKey.price)
        aCoder.encode(neededTime, forKey: PropertyKey.neededTime)
    }
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        let price = aDecoder.decodeInteger(forKey: PropertyKey.price)
        let neededTime = aDecoder.decodeInteger(forKey: PropertyKey.neededTime)
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, rating: rating, price: price, neededTime: neededTime)
    }
}
