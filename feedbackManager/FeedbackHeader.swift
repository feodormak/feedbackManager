//
//  FeedbackHeader.swift
//  feedbackManager
//
//  Created by feodor on 22/2/18.
//  Copyright © 2018 feodor. All rights reserved.
//

import UIKit

class FeedbackHeader: UITableViewHeaderFooterView{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var requiredLabel: UILabel!
    
    static var identifier: String { return String(describing: self) }
    static var nib:UINib { return UINib(nibName: identifier, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
