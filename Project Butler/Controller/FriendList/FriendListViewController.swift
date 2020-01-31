//
//  FriendListViewController.swift
//  
//
//  Created by Neal on 2020/1/31.
//
import Foundation
import UIKit

class FriendListViewController: UIViewController {

    var allFriendButton: UIButton = {
        
        let all = UIButton()
        
        all.setTitle("AllFriend", for: .normal)
        
        all.tag = 0
        
        return all
    }()
    
    var confirmButton: UIButton = {
        
        let confirm = UIButton()
       
        confirm.setTitle("Confirm", for: .normal)
        
        confirm.tag = 1
        
        return confirm
    }()
    
    var acceptButton: UIButton = {
        
        let accept = UIButton()
  
        accept.setTitle("Accept", for: .normal)
        
        accept.tag  = 2
        
        return accept
    }()
    
    var selectView: UIView = {
        
        let view = UIView()
        
        view.frame.size = CGSize(width: 110, height: 2)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = UIColor(red: 28/255, green: 61/255, blue: 160/255, alpha: 1.0)
        
        return view
    }()
    
    var buttonStackView: UIStackView = {
        
        let stack = UIStackView()
        
        stack.axis = NSLayoutConstraint.Axis.horizontal
        
        stack.distribution = UIStackView.Distribution.fillEqually
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    var selectCenterConstraint: NSLayoutConstraint?
    
    var buttons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "FriendList"
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(red: 23/255, green: 61/255, blue: 160/255, alpha: 1.0)]
        
        settingInfo()
    }

    func settingInfo() {
        
        view.addSubview(selectView)
        
        view.addSubview(buttonStackView)
        
        buttonStackView.addArrangedSubview(allFriendButton)
        
        buttonStackView.addArrangedSubview(confirmButton)
        
        buttonStackView.addArrangedSubview(acceptButton)
        
        settingButtonInfo(button: allFriendButton)
        
        settingButtonInfo(button: confirmButton)
        
        settingButtonInfo(button: acceptButton)
        
        selectCenterConstraint = selectView.centerXAnchor.constraint(equalTo: allFriendButton.centerXAnchor)
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            buttonStackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25),
            buttonStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
            buttonStackView.heightAnchor.constraint(equalToConstant: 25)
        ])
        
        NSLayoutConstraint.activate([
            selectView.topAnchor.constraint(equalTo: view.topAnchor, constant: 240),
            selectCenterConstraint!,
            selectView.heightAnchor.constraint(equalToConstant: 3),
            selectView.widthAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func settingButtonInfo(button: UIButton) {
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.frame.size = CGSize(width: 100, height: 24)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 25)
        
        button.setTitleColor(UIColor(red: 23/255, green: 61/255, blue: 160/255, alpha: 1.0), for: .selected)
        
        button.setTitleColor(UIColor(red: 109/255, green: 114/255, blue: 120/255, alpha: 1.0), for: .normal)
        
        button.addTarget(self, action: #selector(didSelectButton), for: .touchUpInside)
        
        buttons.append(button)
    }
    
    @objc func didSelectButton(sender: UIButton) {
        
        UIView.animate(withDuration: 0.5) {
            self.selectCenterConstraint?.isActive = false
            self.selectCenterConstraint = self.selectView.centerXAnchor.constraint(equalTo: self.buttons[sender.tag].centerXAnchor)
            self.selectCenterConstraint?.isActive = true
            self.view.layoutIfNeeded()
        }
    }
    
}
