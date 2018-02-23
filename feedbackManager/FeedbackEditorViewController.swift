//
//  FeedbackEditorViewController.swift
//  feedbackManager
//
//  Created by feodor on 21/2/18.
//  Copyright © 2018 feodor. All rights reserved.
//

import UIKit

protocol FeedbackEditorViewControllerDelegate{
    func updateFeedback(newFeedbackItem: FeedbackItem?)
}

enum FeedbackEditorMode {
    case new
    case edit
}

class FeedbackEditorViewController: UITableViewController, UITextViewDelegate, ListTableViewDelegate {
    
    var item: FeedbackItem? { didSet{ self.tableView.reloadData() } }
    var editorMode: FeedbackEditorMode = .new {
        didSet{
            if self.editorMode == .new {
                self.item = FeedbackItem(feedbackType: .suggestion)
                self.deleteButton.isEnabled = false
                self.title = "New suggestion"
            }
            else {
                self.deleteButton.isEnabled = true
                self.title = "Edit"
            }
        }
    }
    var delegate: FeedbackEditorViewControllerDelegate?
    
    private var listTableView = ListTableView()
    private var selectedIndexPath:IndexPath?
    
    private lazy var  doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissEditor(sender:)))
    private lazy var deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteFeedback))
    private lazy var cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissEditor(sender:)))
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .lightGray
        
        self.tableView.register(FeedbackHeader.nib, forHeaderFooterViewReuseIdentifier: FeedbackHeader.identifier)
        self.tableView.register(FeedbackEntryCell.nib, forCellReuseIdentifier: FeedbackEntryCell.identifier)
        self.tableView.register(FeedbackTextCell.nib, forCellReuseIdentifier: FeedbackTextCell.identifier)
        self.tableView.tableFooterView = UIView()
        
        self.navigationItem.leftBarButtonItems = [cancelButton]
        self.navigationItem.rightBarButtonItems = [doneButton, deleteButton]
        
        
        self.listTableView.delegate = self
        
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(disMissKeyboard))
        
    }
 
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if item != nil { return item!.feedbackType == .suggestion ? 2 : 3 }
        else { return 0 }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 3
        default: return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if item != nil {
            switch indexPath.section {
            case 0:
                if let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackEntryCell.identifier) as? FeedbackEntryCell {
                    switch indexPath.row {
                    case 0:
                        cell.titleLabel?.text = "Category"
                        if let type = item!.pageType { cell.entryLabel?.text = FeedbackMangerConstants.categoryType[type] }
                        else { cell.entryLabel?.text = nil }
                    case 1:
                        cell.titleLabel?.text = "Page"
                        if let refID = item!.refID, let type = item!.pageType  {
                            switch type{
                            case .stations: cell.entryLabel?.text = refID
                            case .reference: cell.entryLabel?.text = FeedbackMangerConstants.referenceID[refID]
                            }
                        }
                        else { cell.entryLabel?.text = nil }
                    case 2:
                        cell.titleLabel?.text = "Section"
                        cell.entryLabel?.text = item!.section
                    default: break
                    }
                    
                    cell.requiredLabel.isHidden = cell.entryLabel.text == nil ? false : true
                    
                    cell.titleLabel.font = FeedbackMangerConstants.titleLabelFont
                    cell.requiredLabel.font = FeedbackMangerConstants.requiredLabelFont
                    cell.entryLabel.font = FeedbackMangerConstants.entryLabelFont
                    
                    cell.requiredLabel.textColor = FeedbackMangerConstants.requiredLabelFontColor
                    cell.entryLabel.textColor = FeedbackMangerConstants.entryLabelFontColor
                    return cell
                }
                else { return UITableViewCell() }
            
            case 1:
                if let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackTextCell.identifier) as? FeedbackTextCell {
                    if item!.feedbackType == .suggestion {
                        cell.textView.delegate = self
                        cell.textView.text = self.item!.comments
                        cell.textView.isEditable = true
                    }
                    else {
                        //display current content
                        cell.textView.isEditable = false
                    }
                    return cell
                }
                else { return UITableViewCell()}
            case 2:
                if let cell = tableView.dequeueReusableCell(withIdentifier: FeedbackTextCell.identifier) as? FeedbackTextCell {
                    cell.textView.delegate = self
                    cell.textView.text = self.item!.comments
                    cell.textView.isEditable = true
                    return cell
                }
                else { return UITableViewCell() }
            default: return UITableViewCell()
                
            }
        }
        else { return UITableViewCell() }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.item != nil, let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: FeedbackHeader.identifier) as? FeedbackHeader {
            
            switch section{
            case 1:
                header.titleLabel.text = self.item!.feedbackType == .suggestion ?FeedbackMangerConstants.commentHeaderText : FeedbackMangerConstants.contentHeaderText
                if item!.feedbackType == .suggestion && item!.comments == nil { header.requiredLabel.isHidden = false }
                else { header.requiredLabel.isHidden = true }
            case 2:
                header.titleLabel.text = FeedbackMangerConstants.commentHeaderText
                header.requiredLabel.isHidden = item!.comments == nil ? false : true
            default: return UIView()
            }
            
            header.titleLabel.textColor = FeedbackMangerConstants.headerTitleLabelFontColor
            header.requiredLabel.textColor = FeedbackMangerConstants.requiredLabelFontColor
            return header
        }
        else { return UIView() }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { return 30 }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.item != nil {
            switch indexPath.section {
            case 1: return self.item!.feedbackType == .suggestion ? 150 : 80
            case 2: return 150
            default: return 40
            }
        }
        else { return 34 }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        self.disMissKeyboard()
        
        if let item = self.item, let cell = tableView.cellForRow(at: indexPath) as? FeedbackEntryCell, item.feedbackType == .suggestion {
            var displayItems = [String]()
            if indexPath.section == 0 {
                switch indexPath.row{
                case 0: FeedbackMangerConstants.categoryType.forEach{ displayItems.append($0.value) }
                case 1:
                    if item.pageType != nil {
                        switch self.item!.pageType!{
                        case .stations: FeedbackMangerConstants.stationsID.forEach{ displayItems.append($0) }
                        case .reference: FeedbackMangerConstants.referenceID.forEach{ displayItems.append($0.value) }
                        }
                    }
                case 2:
                    if let type = item.pageType, let refID = item.refID {
                        switch type{
                        case .stations: FeedbackMangerConstants.stationSectionLabels.forEach{ displayItems.append($0) }
                        case .reference:
                            FeedbackMangerConstants.referenceSection[refID]?.forEach{ displayItems.append($0)
                            }
                        }
                    }
                default: break
                }
            }
            if displayItems.isEmpty != true {
                self.listTableView.displayItems = displayItems
                self.listTableView.currentSelection = cell.entryLabel.text
                self.selectedIndexPath = indexPath
                self.navigationController?.pushViewController(self.listTableView, animated: true)
            }
            else {
                self.listTableView.displayItems.removeAll()
                self.listTableView.currentSelection = nil
                self.selectedIndexPath = nil
            }
            
        }
    }
    
    
    
    //UITextViewDelegate
    func textViewDidEndEditing(_ textView: UITextView) {
        let processedText = textView.text.filter{ $0 != " " }
        if processedText.isEmpty || processedText == "\n" || textView.text == "\n" || textView.text == FeedbackMangerConstants.textViewPlaceholder { item?.comments = nil }
        else { item?.comments = textView.text }
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        else {
            // Combine the textView text and the replacement text to
            // create the updated text string
            let currentText:String = textView.text
            let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
            
            // If updated text view will be empty, add the placeholder
            // and set the cursor to the beginning of the text view
            if updatedText.isEmpty {
                textView.text = FeedbackMangerConstants.textViewPlaceholder
                textView.textColor = UIColor.lightGray
                
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
                return false
            }
                // Else if the text view's placeholder is showing and the
                // length of the replacement string is greater than 0, clear
                // the text view and set its color to black to prepare for
                // the user's entry
            else if textView.textColor == UIColor.lightGray && !text.isEmpty {
                textView.text = nil
                textView.textColor = UIColor.black
            }

            return true
        }
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == UIColor.lightGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    
    //ListTableViewDelegate
    func selectedText(text: String?) {
        if self.selectedIndexPath != nil {
            self.updateFeedbackItem(indexPath: selectedIndexPath!, newData: text)
            self.selectedIndexPath = nil
            self.tableView.reloadData()
        }
    }
    
    //private methods
    private func updateFeedbackItem(indexPath: IndexPath, newData: String?){
        guard indexPath.section == 0 && self.item != nil else { return }
        switch indexPath.row {
        case 0:
            let element = FeedbackMangerConstants.categoryType.filter{ $0.value == newData }
            if element.count == 1 && self.item!.pageType != element.first?.key {
                self.item!.pageType = element.first?.key
                self.item!.refID = nil
                self.item!.section = nil
            }
        case 1:
            if let type = self.item!.pageType {
                switch type {
                case .stations:
                    if self.item!.refID != newData{
                        self.item!.refID = newData
                        self.item!.section = nil
                    }
                case .reference:
                    let element = FeedbackMangerConstants.referenceID.filter{ $0.value == newData }
                    if element.count == 1 && self.item!.refID != element.first?.key{
                        self.item!.refID = element.first?.key
                        self.item!.section = nil
                    }
                }
            }
        case 2:
            if self.item!.section != newData { self.item!.section = newData }
        default: return
        }
    }
    
    @objc private func dismissEditor(sender: UIBarButtonItem){
        switch sender {
        case self.doneButton:
            self.disMissKeyboard()
            if self.validateEntries() == true && self.item != nil{
                self.dismiss(animated: true, completion: nil)
                self.delegate?.updateFeedback(newFeedbackItem: self.item!)
            }
            else { self.view.shake() }
            
        case self.cancelButton: self.dismiss(animated: true, completion: nil)
        case self.deleteButton:
            self.dismiss(animated: true, completion: nil)
            self.delegate?.updateFeedback(newFeedbackItem: self.item)
        default: return
        }
    }
    
    @objc private func deleteFeedback(){
        let alert = UIAlertController(title: FeedbackMangerConstants.deleteWarningTitle , message: FeedbackMangerConstants.deleteWarningText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: FeedbackMangerConstants.cancelText, style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: FeedbackMangerConstants.deleteText, style: .destructive, handler: { _ in
            self.item = nil
            self.dismissEditor(sender: self.deleteButton)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    ///if entries are valid, will return true
    private func validateEntries() -> Bool{
        if self.item == nil { return false }
        else if self.item!.pageType != nil && self.item!.refID != nil && self.item!.section != nil && self.item!.comments != nil{ return true }
        else { return false }
    }
    
    private func disMissKeyboard() { self.view.endEditing(true) }
}
