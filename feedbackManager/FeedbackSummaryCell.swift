//
//  feedbackCell.swift
//  feedbackManager
//
//  Created by feodor on 1/2/18.
//  Copyright © 2018 feodor. All rights reserved.
//

import UIKit

protocol FeedbackSummaryCellDelegate{
    func buttonTapped(sender: UIButton)
}

class FeedbackSummaryCell: UITableViewHeaderFooterView {
    
    var delegate: FeedbackSummaryCellDelegate?
    
    
    @IBOutlet weak var itemNumberLabel: UILabel!
    @IBOutlet weak var categoryLabel: UIButton!
    @IBOutlet weak var pageLabel: UIButton!
    @IBOutlet weak var sectionLabel: UIButton!
    @IBOutlet weak var feedbackTypeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var cellActionLabel: UIButton!
    
    @IBAction func categoryButton(_ sender: UIButton) {
        print("cat")
        self.delegate?.buttonTapped(sender: sender)
    }
    @IBAction func pageButton(_ sender: UIButton) {
        print("page")
    }
    @IBAction func sectionButton(_ sender: UIButton) {
        print("section")
    }
    @IBAction func actionButton(_ sender: UIButton) {
        print("action")
    }
    
    
    static var identifier: String { return String(describing: self) }
    static var nib:UINib { return UINib(nibName: identifier, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
