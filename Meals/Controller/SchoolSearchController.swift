//
//  SchoolSearchController.swift
//  Meals
//
//  Created by 진현식 on 3/16/24.
//

import UIKit

private let reuseIdentifier = "SchoolCell"

class SchoolSearchController: UITableViewController {
    
    // MARK: - Properties
    
    private var viewModel = SchoolViewModel.shared
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var schoolList: [School] {
        return viewModel.getSchoolList()
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureSearchController()
    }
    
    // MARK: - Helpers
    
    private func configureTableView() {
        view.backgroundColor = .secondarySystemBackground
        
        tableView.rowHeight = 60
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    private func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "검색"
        definesPresentationContext = true
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.becomeFirstResponder()
        navigationItem.searchController = searchController
    }
}

// MARK: - UITableViewDataSource / Delegate

extension SchoolSearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getSchoolList().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        cell.backgroundColor = .secondarySystemBackground
        cell.textLabel?.text = schoolList[indexPath.row].schoolName
        cell.detailTextLabel?.text = schoolList[indexPath.row].schoolAddress
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.setSelectedSchool(withIndex: indexPath.row)
        viewModel.updateSchoolList(withQuery: "") { return }
        viewModel.saveSchoolInfo()
        
        navigationController?.dismiss(animated: true)
        
        NotificationCenter.default.post(name: .schoolDidUpdate, object: nil)
    }
}

// MARK: - UISearchResultsUpdating

extension SchoolSearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        viewModel.updateSchoolList(withQuery: searchText) {
            _ = self.schoolList
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}
