//
//  MealViewModel.swift
//  Meals
//
//  Created by 진현식 on 3/15/24.
//

import Foundation

struct MealViewModel {
    
    static var shared = MealViewModel()
    
    private var meal: Meal?
    
    var shouldHideGoToTodayButton = true
    
    mutating func setMealData(_ meal: Meal) {
        self.meal = meal
    }
    
    func getMealData(date: Date, school: School, type: Int?, completion: @escaping (Meal?) -> Void) {
        MealService.shared.fetchMeal(schoolInfo: school, date: date, type: type) { mealData in
            guard let meal = mealData else { completion(nil); return }
            completion(meal)
        }
    }
    
    func getCurrentDateString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 EEEE"
        
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    mutating func calculateShouldHideTodayButton(date: Date) {
        let calendar = Calendar.current
        
        let result = calendar.compare(date, to: .now, toGranularity: .day)
        
        switch result {
        case .orderedSame:
            self.shouldHideGoToTodayButton = true
        default:
            self.shouldHideGoToTodayButton = false
        }
    }
}
