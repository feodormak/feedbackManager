//
//  ListTableView.swift
//  feedbackManager
//
//  Created by feodor on 20/2/18.
//  Copyright © 2018 feodor. All rights reserved.
//

import UIKit

protocol ListTableViewDelegate {
    func selectedText(text:String?)
}

class ListTableView: UITableViewController {
    
    var displayItems = [String]() {
        didSet{ self.tableView.reloadData() }
    }
    var currentSelection: String?
    
    var delegate: ListTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .lightGray
        self.tableView.tableFooterView = UIView()
        let button = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editmode))
        self.navigationItem.rightBarButtonItems = [button]
    }
    
    @objc private func editmode(){
        self.tableView.isEditing = self.tableView.isEditing ? false : true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return self.displayItems.count
        default: return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {return UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "cell" )}
            return cell
        }()
        if displayItems.isEmpty != true {
            cell.textLabel?.text = displayItems[indexPath.row]
            cell.detailTextLabel?.text = displayItems[indexPath.row] == currentSelection ? "✓" : ""
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.currentSelection = tableView.cellForRow(at: indexPath)?.textLabel?.text
        self.tableView.reloadData()
        self.delegate?.selectedText(text: tableView.cellForRow(at: indexPath)?.textLabel?.text)
        self.navigationController?.popViewController(animated: true)
        self.currentSelection = nil
    }
}
