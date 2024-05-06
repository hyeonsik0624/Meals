//
//  MealService.swift
//  Meals
//
//  Created by 진현식 on 3/15/24.
//

import Foundation

struct MealService {
    static var shared = MealService()
    
    let rootUrlString = "https://open.neis.go.kr/hub/mealServiceDietInfo?Type=json"
    
    func fetchMeal(schoolInfo school: School, date: Date, type: Int? = 2, completion: @escaping (Meal?) -> Void) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let dateString = dateFormatter.string(from: date)
        
        var urlString = rootUrlString + "&ATPT_OFCDC_SC_CODE=\(school.educationOfficeCode)&SD_SCHUL_CODE=\(school.schoolCode)&MLSV_YMD=\(dateString)"
        
        if let type = type {
            urlString += "&MMEAL_SC_CODE=\(String(type))"
        }
        
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let request = URLRequest(url: url)
        
        DispatchQueue.global().async {
            session.dataTask(with: request) { data, response, error in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                if let data = data {
                    do {
                        let response = try JSONDecoder().decode(MealResponse.self, from: data)
                        let meal = response.mealInfo.last?.row?.first
                        completion(meal)
                    } catch {
                        completion(nil)
                    }
                }
            }.resume()
        }
    }
}
