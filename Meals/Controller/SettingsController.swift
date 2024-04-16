//
//  SettingsController.swift
//  Meals
//
//  Created by 진현식 on 3/16/24.
//

import UIKit

private let reuseIdentifier = "SettingsCell"

class SettingsController: UITableViewController {
    
    // MARK: - Properties
    
    private var viewModel = SchoolViewModel.shared
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureTableView()
    }
    
    // MARK: - Actions
    
    @objc func handleDone() {
        dismiss(animated: true)
    }
    
    // MARK: - Helpers
    
    private func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        
        navigationItem.title = "설정"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
    }
    
    private func configureTableView() {
        tableView.rowHeight = 68
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
        cell.textLabel?.text = "학교 변경하기"
        cell.textLabel?.font = .boldSystemFont(ofSize: 16)
        cell.detailTextLabel?.text = viewModel.getSelectedSchoolName()
        cell.detailTextLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        cell.selectionStyle = .none
        cell.backgroundColor = .secondarySystemBackground
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = SchoolSearchController()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - SchoolSearchControllerDelegaete

extension SettingsController: SchoolSearchControllerDelegaete {
    func didUpdateSchool() {
        viewModel.saveSchoolInfo()
        tableView.reloadData()
    }
}
