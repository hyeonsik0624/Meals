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
    
    private let schoolNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "횡성고등학교"
        label.textColor = .gray
        return label
    }()
    
    private lazy var mealView = MealView()
    
    private lazy var goToTodayButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("오늘 급식 보기", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleGoToTodayButtonTapped), for: .touchUpInside)
        button.clipsToBounds = true
        button.isHidden = true
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureUI()
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
    
    @objc func showNextDayMeal() {
        guard let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: viewModel.currentDate) else { return }
        viewModel.currentDate = nextDay
        updateDateLabel()
        updateGoToTodayButton()
        getMeal(nextDay)
    }
    
    @objc func showPreviousDayMeal() {
        guard let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: viewModel.currentDate) else { return }
        viewModel.currentDate = previousDay
        updateDateLabel()
        updateGoToTodayButton()
        getMeal(previousDay)
    }
    
    @objc func handleGoToTodayButtonTapped() {
        viewModel.currentDate = .now
        updateDateLabel()
        goToTodayButton.isHidden = viewModel.shouldHideGoToTodayButton
        getMeal()
    }
    
    // MARK: - API
    
    private func getMeal(_ date: Date = Date()) {
        guard let school = school else { return }
        
        MealService.shared.fetchMeal(withSchoolInfo: school, date: date) { meal in
            self.meal = meal
        }
    }
    
    private func loadSavedSchoolInfo() {
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
    
    private func configureUI() {
        view.backgroundColor = .secondarySystemBackground
        
        view.addSubview(mealView)
        mealView.centerX(inView: view)
        mealView.centerY(inView: view)
        
        view.addSubview(schoolNameLabel)
        schoolNameLabel.anchor(bottom: mealView.topAnchor, right: mealView.rightAnchor)
        
        view.addSubview(goToTodayButton)
        goToTodayButton.setDimension(width: 120, height: 46)
        goToTodayButton.layer.cornerRadius = 6
        goToTodayButton.anchor(top: mealView.bottomAnchor, paddingTop: 24)
        goToTodayButton.centerX(inView: view)
        
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(showNextDayMeal))
        leftSwipeGesture.direction = .left
        view.addGestureRecognizer(leftSwipeGesture)
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(showPreviousDayMeal))
        rightSwipeGesture.direction = .right
        view.addGestureRecognizer(rightSwipeGesture)
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingsButtonTapped))
    }
    
    func updateHome() {
        getMeal()
        updateDateLabel()
    }
    
    func updateDateLabel() {
        navigationItem.title = self.viewModel.getCurrentDateString()
    }
    
    func updateGoToTodayButton() {
        let currentIsHidden = goToTodayButton.isHidden
        let shouldHide = viewModel.shouldHideGoToTodayButton
        guard currentIsHidden != shouldHide else { return }
        
        UIView.animate(withDuration: 0.2) {
            self.goToTodayButton.alpha = 0
            self.goToTodayButton.isHidden = shouldHide
            self.goToTodayButton.alpha = 1
        }
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
