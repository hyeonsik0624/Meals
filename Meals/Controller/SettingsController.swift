//
//  SettingsController.swift
//  Meals
//
//  Created by 진현식 on 3/16/24.
//

import UIKit

protocol SettingsControllerDelegate: AnyObject {
    func handleDismissal(_ controller: SettingsController)
}

private let reuseIdentifier = "SettingsCell"

class SettingsController: UITableViewController {
    
    // MARK: - Properties
    
    weak var delegate: SettingsControllerDelegate?
    
    var school: School? {
        didSet { tableView.reloadData() }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    // MARK: - Actions
    
    @objc func handleDone() {
        saveSchoolInfo()
        delegate?.handleDismissal(self)
    }
    
    // MARK: - API
    
    func saveSchoolInfo() {
        guard let school = school else { return }
        UserDefaults.standard.setValue(school.schoolCode, forKey: "schoolCode")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        navigationItem.title = "설정"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
    }
    
    func configureTableView() {
        tableView.rowHeight = 60
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
}

// MARK: - UITableViewDataSource / Delegate

extension SettingsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        cell.textLabel?.text = "🏫 학교 변경하기"
        cell.detailTextLabel?.text = school?.schoolName
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = SchoolSearchController()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension SettingsController: SchoolSearchDelegate {
    func didSetUpSchool(_ controller: SchoolSearchController) {
        self.school = controller.selectedSchool
        controller.navigationController?.popViewController(animated: true)
    }
}
