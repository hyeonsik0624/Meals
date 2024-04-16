//
//  MealViewModel.swift
//  Meals
//
//  Created by 진현식 on 3/15/24.
//

import Foundation

struct MealViewModel {
    
    static let shared = MealViewModel()
    
    private var meal: Meal?
    
    var currentDate = Date()
    
    mutating func setMealData(_ meal: Meal) {
        self.meal = meal
    }
    
    func getMealData(school: School, completion: @escaping (Meal?) -> Void) {
        MealService.shared.fetchMeal(withSchoolInfo: school, date: currentDate) { mealData in
            guard let meal = mealData else { completion(nil); return }
            completion(meal)
        }
    }
    
    func getCurrentDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 EEEE"
        
        let dateString = dateFormatter.string(from: currentDate)
        return dateString
    }
    
    var shouldHideGoToTodayButton: Bool {
        let calendar = Calendar.current
        
        let result = calendar.compare(currentDate, to: .now, toGranularity: .day)
        
        switch result {
        case .orderedSame:
            return true
        default:
            return false
        }
    }
}
