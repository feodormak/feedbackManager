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
    private let navigationBar = UINavigationBar(frame: .zero)
    private let toolBar = UIToolbar(frame: .zero)
    
    private var feedbackItems:[[FeedbackItem]] = [[],[]]
    private var selectedIndexPaths = [IndexPath]() {
        didSet{ self.deleteButton.isEnabled = self.selectedIndexPaths.isEmpty ? false : true } }
    private var editingIndexPath: IndexPath?
    
    private lazy var addButton  = UIBarButtonItem(barButtonSystemItem: .add, target: nil, action: #selector(self.addFeedback))
    private lazy var closeButton = UIBarButtonItem(title: "╳", style: .done, target: nil, action: #selector(self.closeManager))
    private lazy var deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: nil, action: #selector(self.deleteFeedback))
    private lazy var editButton =  UIBarButtonItem(title: "Edit", style: .plain, target: nil, action: #selector(self.editFeedback))
    private lazy var selectAllButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: #selector(self.selectAllRows))
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigationBar()
        self.setupToolbar()
        self.tableViewSetup()
        self.feedbackEditorViewController.delegate = self
        self.selectedIndexPaths.removeAll()
        self.selectAllButton.isEnabled = false
        
        //print(addBut, deleteButton.width, editButton.width, closeButton.width)
        
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
    @objc private func deleteFeedback() {
        if self.tableView.isEditing == true {
            self.deleteFeedbackWithAlert {
                //self.tableView.setEditing(false, animated: true)
                self.addButton.isEnabled = true
                self.closeButton.isEnabled = true
                if self.selectedIndexPaths.isEmpty != true {
                    //var tempItems = self.feedbackItems
                    var itemsToDelete: [[FeedbackItem]] = [[],[]]
                    
                    self.selectedIndexPaths.forEach{ itemsToDelete[$0.section].append(self.feedbackItems[$0.section][$0.row]) }
                    self.tableView.beginUpdates()
                    itemsToDelete.enumerated().forEach{
                        let index = $0.offset
                        $0.element.forEach{
                            let item = $0
                            self.feedbackItems[index] = self.feedbackItems[index].filter{ $0 != item }
                        }
                        self.tableView.reloadSections(IndexSet(integer: index), with: .fade)
                    }
                    self.tableView.endUpdates()
                    
                    self.editFeedback()
                }
            }
        }
    }
    @objc private func editFeedback() {
        self.selectedIndexPaths.removeAll()
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
        self.editButton.title = self.tableView.isEditing ? FeedbackMangerConstants.cancelText : FeedbackMangerConstants.editText
        self.selectAllButton.title = self.tableView.isEditing ? FeedbackMangerConstants.selectAllText : nil
        self.selectAllButton.isEnabled = self.tableView.isEditing ? true : false
        self.addButton.isEnabled = self.tableView.isEditing ? false : true
        self.closeButton.isEnabled = self.tableView.isEditing ? false : true
    }
    @objc private func selectAllRows() {
        if tableView.isEditing == true {
            var allIndexPaths = [IndexPath]()
            for section in 0..<self.tableView.numberOfSections {
                for row in 0..<self.tableView.numberOfRows(inSection: section) { allIndexPaths.append(IndexPath(row: row, section: section)) }
            }
            allIndexPaths.forEach{
                self.tableView.selectRow(at: $0, animated: false, scrollPosition: .none)
                self.selectedIndexPaths.append($0)
            }
        }
    }
    @objc private func closeManager() {
        //to be implemented on merge
    }
    
    
    private func setupNavigationBar() {
        self.navigationBar.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.navigationBar)
        
        NSLayoutConstraint(item: self.navigationBar, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.navigationBar, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.navigationBar, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.navigationBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: FeedbackMangerConstants.navigationBarHeight).isActive = true
        
        let navigationItem = UINavigationItem(title: FeedbackMangerConstants.title)

        navigationItem.leftBarButtonItems = [self.addButton, self.selectAllButton]
        navigationItem.rightBarButtonItems = [self.closeButton, self.editButton, self.deleteButton]
        self.navigationBar.setItems([navigationItem], animated: false)
        
        self.navigationBar.barTintColor = UIColor.baseColor
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.titleTextAttributes = FeedbackMangerConstants.titleAttributes
    }
    
    private func setupToolbar() {
        self.view.addSubview(self.toolBar)
        self.toolBar.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint(item: self.toolBar, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.toolBar, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.toolBar, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.toolBar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: FeedbackMangerConstants.toolbarHeight).isActive = true
        
        self.toolBar.barTintColor = UIColor.baseColor
        self.toolBar.setItems(nil, animated: false)
    }
    
    private func tableViewSetup(){
        self.view.addSubview(self.tableView)
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint(item: self.tableView, attribute: .top, relatedBy: .equal, toItem: self.navigationBar, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.tableView, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1, constant: 8).isActive = true
        NSLayoutConstraint(item: self.tableView, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1, constant: -8).isActive = true
        NSLayoutConstraint(item: self.tableView, attribute: .bottom, relatedBy: .equal, toItem: self.toolBar, attribute: .top, multiplier: 1, constant: 0).isActive = true
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(FeedbackSummaryHeader.nib, forHeaderFooterViewReuseIdentifier: FeedbackSummaryHeader.identifier)
        self.tableView.register(FeedbackSummaryCell.nib, forCellReuseIdentifier: FeedbackSummaryCell.identifier)
        
        self.tableView.backgroundColor = .lightGray
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView()
        self.tableView.allowsMultipleSelectionDuringEditing = true
        self.tableView.cellLayoutMarginsFollowReadableWidth = false
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FeedbackSummaryHeader.identifier) as? FeedbackSummaryHeader {
            switch section {
            case 0: header.headerLabel.text = FeedbackMangerConstants.typeLabel[.exisitng]
            case 1: header.headerLabel.text = FeedbackMangerConstants.typeLabel[.suggestion]
            default: break
            }
            header.headerLabel.textColor = .white
            header.categoryLabel.textColor = .white
            header.sectionLabel.textColor = .white
            header.pageLabel.textColor = .white
            return header
        }
        else { return UIView() }
    }
    
    //UITableViewDelegate stuff
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return FeedbackMangerConstants.mainTableHeaderHeight }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return FeedbackMangerConstants.mainTableRowHeight }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.isEditing == true {
            if self.selectedIndexPaths.contains(indexPath) == false { self.selectedIndexPaths.append(indexPath) }
        }
        else { tableView.deselectRow(at: indexPath, animated: true) }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing == true && self.selectedIndexPaths.contains(indexPath) == true { self.selectedIndexPaths = self.selectedIndexPaths.filter{ $0 != indexPath } }
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool { return true }
    
    
    /*
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete { }
    }
    */
 
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: FeedbackMangerConstants.deleteText) { _, _ in
            self.deleteFeedbackWithAlert {
                self.feedbackItems[indexPath.section].remove(at: indexPath.row)
                self.tableView.reloadSections(IndexSet(integer:indexPath.section), with: .fade)
            }
        }
        return [delete]
    }
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
            else {  self.tableView.reloadSections(IndexSet(integer: editingIndexPath!.section), with: .fade) }
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
    
    private func deleteFeedbackWithAlert(deleteCodeBlock: @escaping () -> Void) {
        let alert = UIAlertController(title: FeedbackMangerConstants.deleteWarningTitle , message: FeedbackMangerConstants.deleteWarningText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: FeedbackMangerConstants.cancelText, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: FeedbackMangerConstants.deleteText, style: .destructive, handler: { _ in
            deleteCodeBlock()
        }))
        self.managePresentingViewControllers(toPresent: alert)
    }
    
    private func managePresentingViewControllers(toPresent: UIViewController) {
        if let _ = self.presentedViewController { self.dismiss(animated: true, completion: nil) }
        if let presentedVC = self.presentedViewController, presentedVC == toPresent {
            toPresent.dismiss(animated: false, completion: nil)
        }
        else { self.present(toPresent, animated: true, completion: nil ) }
    }
}



