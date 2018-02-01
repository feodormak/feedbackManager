//
//  ViewController.swift
//  feedbackManager
//
//  Created by feodor on 1/2/18.
//  Copyright © 2018 feodor. All rights reserved.
//

import UIKit

class FeedbackManagerViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
    }
    
    @objc private func addFeedback() { }
    @objc private func deleteFeedback() {}
    @objc private func editFeedback() { }
    @objc private func closeManager() { }
    

    private func setupNavigationBar() {
        let navigationBar = UINavigationBar(frame: CGRect.zero)
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(navigationBar)
        
        NSLayoutConstraint(item: navigationBar, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: navigationBar, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: navigationBar, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: navigationBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 64).isActive = true
        
        let navigationItem = UINavigationItem(title: "Feedback")
        let addButton  = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: #selector(self.addFeedback))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: nil, action: #selector(self.deleteFeedback))
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: #selector(self.editFeedback))
        let closeButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.closeManager))
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItems = [closeButton, editButton, deleteButton]
        navigationBar.setItems([navigationItem], animated: false)
    }


}

