//
//  SchoolInfoService.swift
//  Meals
//
//  Created by 진현식 on 3/16/24.
//

import Foundation

struct SchoolInfoService {
    
    static let shared = SchoolInfoService()
    
    let rootUrlString = "https://open.neis.go.kr/hub/schoolInfo?Type=json"
    
    func getSchools(withSchoolName schoolName: String, completion: @escaping ([School]) -> Void) {
        var schools = [School]()
        
        let urlString = rootUrlString + "&SCHUL_NM=\(schoolName)"
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
                    let schoolInfoResponse = try JSONDecoder().decode(SchoolResponce.self, from: data)
                    
                    if let school = schoolInfoResponse.schoolInfo.last?.row {
                        schools.append(contentsOf: school)
                        completion(schools)
                    }
                } catch {
                    completion(schools)
                }
            }
        }.resume()
    }
}
