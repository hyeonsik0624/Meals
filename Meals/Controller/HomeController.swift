//
//  HomeController.swift
//  Meals
//
//  Created by 진현식 on 3/15/24.
//

import UIKit

class HomeController: UIViewController {
    
    // MARK: - Properties
    
    private var viewModel = HomeViewModel()
    
    private var school: School? {
        didSet { getMeal() }
    }
    
    private var meal: Meal? {
        didSet {
            mealView.meal = meal
        }
    }
    
    private lazy var mealView: MealView = {
        let frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        let mv = MealView(frame: frame)
        return mv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadSavedSchoolInfo()
    }
    
    // MARK: - Actions
    
    @objc func settingsButtonTapped() {
        let controller = SettingsController()
        controller.delegate = self
        controller.school = self.school
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        
        present(nav, animated: true)
    }
    
    // MARK: - API
    
    func getMeal() {
        guard let school = school else { return }
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        let today = dateFormatter.string(from: date)
        
        MealService.shared.getMeal(withSchoolInfo: school, date: today) { meal in
            self.meal = meal
        }
    }
    
    func loadSavedSchoolInfo() {
        guard let schoolCode = UserDefaults.standard.string(forKey: "schoolCode") else {
            let controller = SchoolSettingsController()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true)
            
            return
        }
    
        SchoolInfoService.shared.getSchool(withSchoolCode: schoolCode) { school in
            self.school = school
        }
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(mealView)
        mealView.centerX(inView: view)
        mealView.centerY(inView: view)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = viewModel.getCurrentDateString()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingsButtonTapped))
    }
}

// MARK: - SettingsControllerDelegate

extension HomeController: SettingsControllerDelegate {
    func handleDismissal(_ controller: SettingsController) {
        controller.dismiss(animated: true)
        self.school = controller.school
    }
}

extension HomeController: SchoolSettingsControllerDelegate {
    func didSetUpSchool(withSchool school: School) {
        self.school = school
    }
}
