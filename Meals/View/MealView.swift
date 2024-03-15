//
//  MealView.swift
//  Meals
//
//  Created by 진현식 on 3/15/24.
//

import UIKit

class MealView: UIView {
    
    // MARK: - Properties
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColor(white: 0.8, alpha: 1)
        view.layer.cornerRadius = 12
        
        view.addSubview(dishesLabel)
        dishesLabel.anchor(left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 10, paddingRight: 10)
        dishesLabel.centerY(inView: view)
        
        return view
    }()
    
    private lazy var dishesLabel: UILabel = {
        let label = UILabel()
        
        label.text = "고등어조림\n된장국\n스팸마요덮밥\n제육볶음\n요구르트\n사과"
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.textColor = .black
        
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(backgroundView)
        backgroundView.setDimension(width: 320, height: 320)
        backgroundView.centerX(inView: self)
        backgroundView.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
