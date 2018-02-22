//
//  ViewController.swift
//  feedbackManager
//
//  Created by feodor on 1/2/18.
//  Copyright © 2018 feodor. All rights reserved.
//

import UIKit

class FeedbackManagerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPopoverPresentationControllerDelegate, FeedbackSummaryCellDelegate, FeedbackEditorViewControllerDelegate{
    
    private var tableView = UITableView()
    private var editorNavigationController = UINavigationController()
    private let feedbackEditorViewController = FeedbackEditorViewController()
    private let navigationBar = UINavigationBar(frame: CGRect.zero)
    
    private var feedbackItems:[[FeedbackItem]] = [[],[]]
    private var editingIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.tableViewSetup()
        self.feedbackEditorViewController.delegate = self
        
        //loaded with test data
        self.feedbackItems = [
            [FeedbackItem(feedbackType: .exisitng, pageType: .stations, refID: "VTCC", section: "Approach"),
             FeedbackItem(feedbackType: .exisitng, pageType: .stations, refID: "WAMM", section: "Terrain"),
             FeedbackItem(feedbackType: .exisitng, pageType: .reference, refID: "TCASREQ", section: "Requirements"),
             FeedbackItem(feedbackType: .exisitng, pageType: .stations, refID: "VOMM", section: "Caution"),
             FeedbackItem(feedbackType: .exisitng, pageType: .reference, refID: "ADSBOPS", section: "Emergency")],
            [FeedbackItem(feedbackType: .suggestion, pageType: .stations, refID: "WASS", section: "Ground Ops"),
             FeedbackItem(feedbackType: .suggestion, pageType: .reference, refID: "FANSOPS", section: "Areas of Operations"),
             FeedbackItem(feedbackType: .suggestion, pageType: .stations, refID: "WADD", section: "Arrival"),
             FeedbackItem(feedbackType: .suggestion, pageType: .stations, refID: "VOCI", section: "Departure"),
             FeedbackItem(feedbackType: .suggestion, pageType: .stations, refID: "VTSP", section: "Ground Ops")]]
    }
    
    @objc private func addFeedback() { self.launchFeedbackEditor(currentFeedbackItem: nil, mode: .new) }
    @objc private func deleteFeedback() {}
    @objc private func editFeedback() { self.tableView.isEditing = self.tableView.isEditing ? false : true }
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
        
        self.navigationBar.barTintColor = UIColor.baseColor
        self.navigationBar.tintColor = UIColor.white
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
        self.tableView.register(FeedbackSummaryCell.nib, forCellReuseIdentifier: FeedbackSummaryCell.identifier)
        
        self.tableView.backgroundColor = .lightGray
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
        
    }
    
    
    //UITableViewDataSource stuff
    func numberOfSections(in tableView: UITableView) -> Int { return self.feedbackItems.count }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return self.feedbackItems[section].count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackSummaryCell.identifier) as? FeedbackSummaryCell {
            cell.delegate = self
            cell.itemNumberLabel.text = String(indexPath.row + 1) + "."
            cell.item = feedbackItems[indexPath.section][indexPath.row]
            
            cell.isEditing = true
            return cell
        }
        return UITableViewCell()
    }
    
    //UITableViewDelegate stuff
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool { return true }
    
    
    
    //FeedbackSummaryCellDelegate conformance
    func editButtonTapped(cell: UITableViewCell) {
        if let indexPath = self.tableView.indexPath(for: cell){
            self.editingIndexPath = indexPath
            self.launchFeedbackEditor(currentFeedbackItem: self.feedbackItems[indexPath.section][indexPath.row], mode: .edit)
        }
    }
    
    //FeedbackEditorViewControllerDelegate conformance
    func updateFeedback(newFeedbackItem: FeedbackItem?) {
        if self.editingIndexPath != nil {
            self.feedbackItems[self.editingIndexPath!.section].remove(at: self.editingIndexPath!.row)
            if newFeedbackItem != nil {
                self.feedbackItems[self.editingIndexPath!.section].insert(newFeedbackItem!, at: self.editingIndexPath!.row)
                self.tableView.reloadRows(at: [self.editingIndexPath!], with: .fade)
            }
            else { self.tableView.reloadSections(IndexSet(integer: editingIndexPath!.section), with: .fade) }
            self.editingIndexPath = nil
        }
        else {
            if newFeedbackItem != nil {
                let index = newFeedbackItem!.feedbackType == .suggestion ? 1 : 0
                self.feedbackItems[index].append(newFeedbackItem!)
                self.tableView.reloadSections(IndexSet(integer: index), with: .fade)
            }
        }
    }
    
    //private methods
    private func launchFeedbackEditor(currentFeedbackItem: FeedbackItem?, mode: FeedbackEditorMode){
        self.editorNavigationController = UINavigationController(rootViewController: self.feedbackEditorViewController)
        self.editorNavigationController.modalPresentationStyle = .formSheet
        self.feedbackEditorViewController.item = currentFeedbackItem
        self.feedbackEditorViewController.editorMode = mode
        self.managePresentingViewControllers(toPresent: self.editorNavigationController)
    }
    
    
    private func managePresentingViewControllers(toPresent: UIViewController) {
        if let _ = self.presentedViewController { self.dismiss(animated: true, completion: nil) }
        if let presentedVC = self.presentedViewController, presentedVC == toPresent {
            toPresent.dismiss(animated: false, completion: nil)
        }
        else { self.present(toPresent, animated: true, completion: nil ) }
    }
    
}



