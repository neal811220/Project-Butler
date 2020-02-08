//
//  ViewController.swift
//  Project Butler
//
//  Created by Neal on 2020/1/22.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class PersonalViewController: UIViewController {

    let searchButton: UIButton = {
        let searchImage = UIImage.asset(.Icons_32px_SearchProjectButton)
        let bt = UIButton()
        bt.setImage(searchImage, for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        return bt
    }()
    
    let addButton: UIButton = {
        let addrProjectImage = UIImage.asset(.Icons_32px_AddProjectButton)
        let bt = UIButton()
        bt.setImage(addrProjectImage, for: .normal)
        bt.translatesAutoresizingMaskIntoConstraints = false
        return bt
    }()
    
    let titleStackView: UIStackView = {
        let st = UIStackView()
        st.axis = NSLayoutConstraint.Axis.horizontal
        st.distribution = UIStackView.Distribution.fillEqually
        st.translatesAutoresizingMaskIntoConstraints = false
        st.backgroundColor = UIColor.red
        return st
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationItem.title = LargeTitle.personalProject.rawValue
        
        settingStackView()
    }
    
    @objc func didTapSearchButton(sender: UIBarButtonItem) {
                
    }
    
    @objc func didTapAddProjtButton(sender: UIBarButtonItem) {
        
    }
    
    func settingStackView() {
        
        guard let navigationbar = navigationController?.navigationBar else { return }
        
        navigationController?.navigationBar.addSubview(titleStackView)
        
        titleStackView.addArrangedSubview(searchButton)
        
        titleStackView.addArrangedSubview(addButton)
        
        NSLayoutConstraint.activate([
            titleStackView.bottomAnchor.constraint(equalTo: navigationbar.bottomAnchor, constant: -10),
            titleStackView.rightAnchor.constraint(equalTo: navigationbar.rightAnchor, constant: -15),
            titleStackView.widthAnchor.constraint(equalToConstant: navigationbar.frame.width / 5),
            titleStackView.heightAnchor.constraint(equalToConstant: navigationbar.frame.height / 3)
        ])
        
        
    }

}

