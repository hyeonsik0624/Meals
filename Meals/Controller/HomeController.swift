//
//  HomeController.swift
//  Meals
//
//  Created by 진현식 on 3/15/24.
//

import UIKit

class HomeController: UIViewController {
    
    // MARK: - Properties
    
    var viewModel = HomeViewModel()
    
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
    
    // MARK: - Actions
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(mealView)
        mealView.centerX(inView: view)
        mealView.centerY(inView: view)
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = viewModel.getCurrentDateString()
    }
}
