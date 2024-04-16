//
//  HomeController.swift
//  Meals
//
//  Created by 진현식 on 3/15/24.
//

import UIKit

class HomeController: UIViewController {
    
    // MARK: - Properties
    
    private var mealViewModel = MealViewModel.shared
    private var schoolViewModel = SchoolViewModel.shared
    
    private let schoolNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
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
        setupViewModel()
        configureNavigationBar()
        configureUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(schoolDidUpdate), name: .schoolDidUpdate, object: nil)
    }
    
    // MARK: - API
    
    func getMeal() {
        guard let school = schoolViewModel.getSchoolData() else { return }
        
        mealViewModel.getMealData(school: school) { meal in
            self.mealView.meal = meal
        }
    }
    
    // MARK: - Actions
    
    @objc func schoolDidUpdate() {
        handleGoToTodayButtonTapped()
        schoolNameLabel.text = schoolViewModel.getSchoolName()
    }
    
    @objc func settingsButtonTapped() {
        let controller = SettingsController()
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        
        present(nav, animated: true)
    }
    
    @objc func showNextDayMeal() {
        guard let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: mealViewModel.currentDate) else { return }
        mealViewModel.currentDate = nextDay
        updateDateLabel()
        updateGoToTodayButton()
        getMeal()
    }
    
    @objc func showPreviousDayMeal() {
        guard let previousDay = Calendar.current.date(byAdding: .day, value: -1, to: mealViewModel.currentDate) else { return }
        mealViewModel.currentDate = previousDay
        updateDateLabel()
        updateGoToTodayButton()
        getMeal()
    }
    
    @objc func handleGoToTodayButtonTapped() {
        mealViewModel.currentDate = .now
        updateDateLabel()
        goToTodayButton.isHidden = mealViewModel.shouldHideGoToTodayButton
        getMeal()
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
        schoolNameLabel.text = schoolViewModel.getSchoolName()
    }
    
    func updateDateLabel() {
        navigationItem.title = self.mealViewModel.getCurrentDateString()
    }
    
    func updateGoToTodayButton() {
        let currentIsHidden = goToTodayButton.isHidden
        let shouldHide = mealViewModel.shouldHideGoToTodayButton
        guard currentIsHidden != shouldHide else { return }
        
        UIView.animate(withDuration: 0.2) {
            self.goToTodayButton.alpha = 0
            self.goToTodayButton.isHidden = shouldHide
            self.goToTodayButton.alpha = 1
        }
    }
    
    func updateSchoolNameLabel() {
        self.schoolNameLabel.text = schoolViewModel.getSelectedSchoolName()
    }
    
    func setupViewModel() {
        schoolViewModel.loadSavedSchool {
            DispatchQueue.main.async {
                self.updateHome()
            }
        }
    }
}
