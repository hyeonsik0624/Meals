//
//  HomeViewModel.swift
//  Meals
//
//  Created by 진현식 on 3/15/24.
//

import Foundation

struct HomeViewModel {
    static let shared = HomeViewModel()
    
    func getCurrentDateString() -> String {
        let now = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 EEEE"
        
        let dateString = dateFormatter.string(from: now)
        
        return dateString
    }
}
