//
//  WorkLogContentTableViewCell.swift
//  Project Butler
//
//  Created by Neal on 2020/2/17.
//  Copyright © 2020 neal812220. All rights reserved.
//

import UIKit

class WorkLogContentTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var workItemTextField: UITextField!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var startTimeTextField: UITextField!
    
    @IBOutlet weak var endTimeTextField: UITextField!
    
    @IBOutlet weak var problemTextView: UITextView!
    
    @IBOutlet weak var workContentTextView: UITextView!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var problemHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var workContentHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var saveButton: UIButton!
    
    var didChangeTextViewHeight:((Bool) -> Void)?
    
    var textViewDidEdit: ((String, String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupTextView()
        
        textViewDidChange(problemTextView)
        
        textViewDidChange(workContentTextView)
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func setupTextView() {
        
        problemTextView.translatesAutoresizingMaskIntoConstraints = false
        
        problemTextView.isScrollEnabled = false
        
        problemTextView.delegate = self
        
        workContentTextView.translatesAutoresizingMaskIntoConstraints = false
        
        workContentTextView.isScrollEnabled = false
        
        workContentTextView.delegate = self
    }
    
}

extension WorkLogContentTableViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
            
        if textView == workContentTextView {
            
        }
        
        let size = CGSize(width: 354, height: .zero)
        
        let estimatedSize = textView.sizeThatFits(size)
        
        problemHeightConstraint.constant = estimatedSize.height
        
        workContentHeightConstraint.constant = estimatedSize.height
        
        textViewDidEdit?(problemTextView.text, workContentTextView.text)
        
        if textView.frame.size.height != estimatedSize.height {
            
            didChangeTextViewHeight?(true)
            
        }
    }
    
}

