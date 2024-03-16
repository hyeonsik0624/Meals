//
//  School.swift
//  Meals
//
//  Created by 진현식 on 3/16/24.
//

import Foundation

struct SchoolResponce: Codable {
    let schoolInfo: [SchoolInfoSection]
    
}

struct SchoolInfoSection: Codable {
    let row: [School]?
}

struct School: Codable {
    var educationOfficeCode: String
    var schoolCode: String
    var schoolName: String
    var schoolAddress: String
    
    enum CodingKeys: String, CodingKey {
        case educationOfficeCode = "ATPT_OFCDC_SC_CODE"
        case schoolCode = "SD_SCHUL_CODE"
        case schoolName = "SCHUL_NM"
        case schoolAddress = "ORG_RDNMA"
    }
}
