//
//  ViewController.swift
//  feedbackManager
//
//  Created by feodor on 1/2/18.
//  Copyright © 2018 feodor. All rights reserved.
//

import UIKit

class FeedbackManagerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FeedbackSummaryCellDelegate {
    
    private var tableView = UITableView()
    private let listTableView = UITableViewController()
    private let navigationBar = UINavigationBar(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.tableViewSetup()
    }
    
    @objc private func addFeedback() { }
    @objc private func deleteFeedback() {}
    @objc private func editFeedback() { }
    @objc private func closeManager() { }
    

    private func setupNavigationBar() {
        self.navigationBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.navigationBar)
        
        NSLayoutConstraint(item: self.navigationBar, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.navigationBar, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.navigationBar, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.navigationBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 64).isActive = true
        
        let navigationItem = UINavigationItem(title: "Feedback")
        let addButton  = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: #selector(self.addFeedback))
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: nil, action: #selector(self.deleteFeedback))
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: nil, action: #selector(self.editFeedback))
        let closeButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(self.closeManager))
        navigationItem.leftBarButtonItem = addButton
        navigationItem.rightBarButtonItems = [closeButton, editButton, deleteButton]
        self.navigationBar.setItems([navigationItem], animated: false)
    }

    private func tableViewSetup(){
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: self.tableView, attribute: .top, relatedBy: .equal, toItem: self.navigationBar, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.tableView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: self.tableView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: -8).isActive = true
        NSLayoutConstraint(item: self.tableView, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
     
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(FeedbackCommentCell.nib, forCellReuseIdentifier: FeedbackCommentCell.identifier)
        self.tableView.register(FeedbackSummaryCell.nib, forHeaderFooterViewReuseIdentifier: FeedbackSummaryCell.identifier)
        
        self.tableView.backgroundColor = .lightGray
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
    }
    
    
    //UITableViewDataSource stuff
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        return UITableViewCell()
    }
    
    //UITableViewDelegate stuff
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FeedbackSummaryCell.identifier) as? FeedbackSummaryCell {
            header.itemNumberLabel.text = String(section + 1)
            header.delegate = self
            return header
        }
        else { return UIView() }
    }
    
    
    //FeedbackSummaryCellDelegate conformance
    func buttonTapped(sender: UIButton) {
        self.listTableView.modalPresentationStyle = .popover
        self.listTableView.popoverPresentationController?.sourceView = self.view
        self.listTableView.popoverPresentationController?.barButtonItem = UIBarButtonItem(customView: sender)
        self.listTableView.popoverPresentationController?.permittedArrowDirections = .up
        print(self.listTableView.popoverPresentationController?.passthroughViews)
        self.managePresentingViewControllers(toPresent: self.listTableView)
    }
    
    private func managePresentingViewControllers(toPresent: UIViewController) {
        if let _ = self.presentedViewController { self.dismiss(animated: true, completion: nil) }
        self.present(toPresent, animated: true, completion: nil)
    }
}

