//
//  Meal.swift
//  Meals
//
//  Created by 진현식 on 3/15/24.
//

import UIKit

struct MealResponse: Codable {
    let mealInfo: [MealInfoSection]
    
    enum CodingKeys: String, CodingKey {
        case mealInfo = "mealServiceDietInfo"
    }
}

struct MealInfoSection: Codable {
    let row: [Meal]?
}

struct Meal: Codable {
    var dishes: String
    
    enum CodingKeys: String, CodingKey {
        case dishes = "DDISH_NM"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let decodedDishesString = try container.decode(String.self, forKey: .dishes)
        
        let regexPattern = "\\(\\d+(\\.\\d+)*\\)|'"
        
        var editedDishesString = decodedDishesString.replacingOccurrences(of: regexPattern, with: "", options: .regularExpression)
        editedDishesString = editedDishesString.replacingOccurrences(of: " <br/>", with: "\n")
        
        self.dishes = editedDishesString
    }
}
