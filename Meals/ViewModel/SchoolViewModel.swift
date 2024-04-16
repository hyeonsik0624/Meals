//
//  SchoolViewModel.swift
//  Meals
//
//  Created by 진현식 on 4/15/24.
//

import Foundation

class SchoolViewModel {
    
    static let shared = SchoolViewModel()
    
    private var schoolList: [School]?
    
    private var selectedSchool: School?
    
    func getSelectedSchoolName() -> String {
        guard let schoolName = selectedSchool?.schoolName else { return "" }
        return schoolName
    }
    
    func updateSchoolList(withQuery query: String, completion: @escaping () -> Void) {
        SchoolInfoService.shared.getSchools(withSchoolName: query) { [weak self] schools in
            guard let self = self else { return }
            self.schoolList = schools
            completion()
        }
    }
    
    func getSchoolData() -> School? {
        guard let school = selectedSchool else { return nil }
        return school
    }
    
    func getSchoolList() -> [School] {
        return schoolList ?? []
    }
    
    func getSchoolName(withIndex index: Int? = nil) -> String {
        if let index = index {
            guard let schoolList = schoolList else { return "" }
            return schoolList[index].schoolName
        } else {
            guard let school = selectedSchool else { return "" }
            return school.schoolName
        }
    }
    
    func getSchoolAddress(withIndex index: Int) -> String {
        guard let schoolList = schoolList else { return "" }
        return schoolList[index].schoolAddress
    }
    
    func setSelectedSchool(withIndex index: Int) {
        guard let schoolList = schoolList else { return }
        self.selectedSchool = schoolList[index]
    }
    
    func saveSchoolInfo() {
        guard let school = selectedSchool else { return }
        UserDefaults.standard.setValue(school.schoolCode, forKey: "schoolCode")
    }
    
    func loadSavedSchool(completion: @escaping () -> Void) {
        guard let schoolCode = UserDefaults.standard.string(forKey: "schoolCode") else { return }
    
        SchoolInfoService.shared.getSchool(withSchoolCode: schoolCode) { school in
            self.selectedSchool = school
            completion()
        }
    }
    
    func getSchoolCode() -> String {
        guard let schoolCode = selectedSchool?.schoolCode else { return "" }
        return schoolCode
    }
}
