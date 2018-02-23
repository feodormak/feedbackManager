//
//  feedbackCell.swift
//  feedbackManager
//
//  Created by feodor on 1/2/18.
//  Copyright © 2018 feodor. All rights reserved.
//

import UIKit

protocol FeedbackSummaryCellDelegate{
    func editButtonTapped(cell: UITableViewCell)
}

class FeedbackSummaryCell: UITableViewCell {
    
    var item : FeedbackItem? {
        didSet{
            if item != nil {
                self.editLabel.setImage(UIImage(named: "edit"), for: .normal)
                self.editLabel.setTitleColor(.lightGray, for: .normal)
                if let type = item!.pageType, let refID = item!.refID{
                    self.categoryLabel.text = FeedbackMangerConstants.categoryType[type]
                    switch type {
                    case .stations: self.pageLabel.text = item!.refID
                    case .reference: self.pageLabel.text = FeedbackMangerConstants.referenceID[refID]
                    }
                }
                else {
                    self.categoryLabel.text = nil
                    self.pageLabel.text = nil
                }
                self.sectionLabel.text = item!.section
                self.feedbackTypeLabel.text = FeedbackMangerConstants.typeLabel[item!.feedbackType]
            }
        }
    }
    
    var delegate: FeedbackSummaryCellDelegate?
    
    
    @IBOutlet weak var itemNumberLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var pageLabel: UILabel!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var feedbackTypeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var editLabel: UIButton!
    //@IBOutlet weak var checkMark: UIButton!
    
    @IBOutlet weak var leftEdgeConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemNumberLabelLeftConstraint: NSLayoutConstraint!
    
    @IBAction func editButton(_ sender: UIButton){ self.delegate?.editButtonTapped(cell: self) }
    
    //@IBAction func checkButton(_ sender: UIButton) {
        //self.delegate?.selectButtonTapped(cell: self)
    //}
    
    static var identifier: String { return String(describing: self) }
    static var nib:UINib { return UINib(nibName: identifier, bundle: nil) }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        //checkMark.layer.cornerRadius = FeedbackMangerConstants.checkMarkRadius
        //checkMark.layer.borderWidth = FeedbackMangerConstants.checkMarkBorderWidth
        //checkMark.layer.borderColor = UIColor.lightGray.cgColor
        
        self.leftEdgeConstraint.constant = FeedbackMangerConstants.mainTableRowOffset * -1
        self.itemNumberLabelLeftConstraint.constant = FeedbackMangerConstants.mainTableRowOffset + 8
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        self.editLabel.isEnabled = self.isEditing ? false : true
    
    }
    
   
}
