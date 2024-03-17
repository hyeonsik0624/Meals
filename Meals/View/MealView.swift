//
//  MealView.swift
//  Meals
//
//  Created by 진현식 on 3/15/24.
//

import UIKit

class MealView: UIView {
    
    // MARK: - Properties
    
    var meal: Meal? {
        didSet { updateDishes() }
    }
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(named: "MealViewBackgroundColor")
        view.layer.cornerRadius = 12
        
        view.addSubview(dishesLabel)
        dishesLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor,
                           paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        dishesLabel.centerY(inView: view)
        
        return view
    }()
    
    private lazy var dishesLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.textColor = UIColor(named: "DishesLabelColor")
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        updateDishes()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        addSubview(backgroundView)
        backgroundView.setDimension(width: 320, height: 320)
        backgroundView.centerX(inView: self)
        backgroundView.centerY(inView: self)
    }
    
    func updateDishes() {
        guard let dishes = meal?.dishes else {
            DispatchQueue.main.async {
                self.dishesLabel.text = "급식 정보가 없습니다."
            }
            return
        }
        
        DispatchQueue.main.async {
            self.dishesLabel.text = dishes
        }
    }
}
