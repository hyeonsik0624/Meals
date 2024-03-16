//
//  SchoolSearchController.swift
//  Meals
//
//  Created by 진현식 on 3/16/24.
//

import UIKit

protocol SchoolSearchDelegate: AnyObject {
    func didSetUpSchool(_ controller: SchoolSearchController)
}

private let reuseIdentifier = "SchoolCell"

class SchoolSearchController: UITableViewController {
    
    // MARK: - Properties
    
    weak var delegate: SchoolSearchDelegate?
    
    private var schools = [School]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    var selectedSchool: School?
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureSearchController()
    }
    
    // MARK: - Actions
    
    // MARK: - API
    
    // MARK: - Helpers
    
    func configureTableView() {
        tableView.rowHeight = 60
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "검색"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

// MARK: - UITableViewDataSource / Delegate

extension SchoolSearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return schools.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
        cell.textLabel?.text = schools[indexPath.row].schoolName
        cell.detailTextLabel?.text = schools[indexPath.row].schoolAddress
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSchool = schools[indexPath.row]
        delegate?.didSetUpSchool(self)
    }
}

// MARK: - UISearchResultsUpdating

extension SchoolSearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        
        SchoolInfoService.shared.getSchools(withSchoolName: searchText) { schools in
            self.schools = schools
        }
    }
}
