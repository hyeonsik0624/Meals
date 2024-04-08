//
//  HomeViewModel.swift
//  Meals
//
//  Created by 진현식 on 3/15/24.
//

import Foundation

struct HomeViewModel {
    static let shared = HomeViewModel()
    
    var currentDate = Date()
    
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
