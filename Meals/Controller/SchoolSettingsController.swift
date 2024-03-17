//
//  SchoolSettingsController.swift
//  Meals
//
//  Created by 진현식 on 3/16/24.
//

import UIKit

protocol SchoolSettingsControllerDelegate: AnyObject {
    func didSetUpSchool(withSchool school: School)
}

class SchoolSettingsController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: SchoolSettingsControllerDelegate?
    
    private let greetingLabel: UILabel = {
        let label = UILabel()
        label.text = "안녕하세요!\n먼저 학교를 설정해 주세요"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.boldSystemFont(ofSize: 30)
        return label
    }()
    
    private lazy var settingsSchoolButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("학교 설정하기", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(settingsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Actions
    
    @objc func settingsButtonTapped() {
        let controller = SchoolSearchController()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(greetingLabel)
        greetingLabel.centerY(inView: view, left: view.leftAnchor, paddingLeft: 16)
        
        view.addSubview(settingsSchoolButton)
        settingsSchoolButton.centerX(inView: view)
        settingsSchoolButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                                   paddingLeft: 20, paddingRight: 20,
                                   height: 56)
    }
    
}

// MARK: - SchoolSearchDelegate

extension SchoolSettingsController: SchoolSearchDelegate {
    func didSetUpSchool(_ controller: SchoolSearchController) {
        guard let school = controller.selectedSchool else { return }
        delegate?.didSetUpSchool(withSchool: school)
        self.dismiss(animated: true)
    }
}
