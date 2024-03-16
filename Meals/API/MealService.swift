//
//  MealService.swift
//  Meals
//
//  Created by 진현식 on 3/15/24.
//

import Foundation

struct MealService {
    static let shared = MealService()
    
    let rootUrlString = "https://open.neis.go.kr/hub/mealServiceDietInfo?Type=json&MMEAL_SC_CODE=2"
    
    func getMeal(withSchoolInfo school: School, date: String, completion: @escaping (Meal?) -> Void) {
        let urlString = rootUrlString + "&ATPT_OFCDC_SC_CODE=\(school.educationOfficeCode)&SD_SCHUL_CODE=\(school.schoolCode)&MLSV_YMD=\(date)"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let request = URLRequest(url: url)
        
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
