//
//  FeedbackSummaryHeader.swift
//  feedbackManager
//
//  Created by feodor on 22/2/18.
//  Copyright © 2018 feodor. All rights reserved.
//

import UIKit

class FeedbackSummaryHeader: UITableViewHeaderFooterView {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var pageLabel: UILabel!
    
    static var identifier: String { return String(describing: self) }
    static var nib:UINib { return UINib(nibName: identifier, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
}
