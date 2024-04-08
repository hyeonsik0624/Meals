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
        setDimension(width: 320, height: 320)
        layer.cornerRadius = 12
        clipsToBounds = true
        
        addSubview(dishesLabel)
        dishesLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,
                           paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        
        backgroundColor = UIColor(named: "MealViewBackgroundColor")
    }
    
    func updateDishes() {
        guard let dishes = meal?.dishes else {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.2) {
                    self.dishesLabel.alpha = 0
                    self.dishesLabel.text = "급식 정보가 없습니다."
                    self.dishesLabel.alpha = 1
                }
            }
            
            return
        }
        
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.dishesLabel.alpha = 0
                self.dishesLabel.text = dishes
                self.dishesLabel.alpha = 1
            }
            
        }
    }
}
