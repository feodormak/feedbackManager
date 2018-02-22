//
//  FeedbackTextCell.swift
//  feedbackManager
//
//  Created by feodor on 21/2/18.
//  Copyright © 2018 feodor. All rights reserved.
//

import UIKit

class FeedbackTextCell: UITableViewCell  {
    
    @IBOutlet weak var textView: UITextView!
    
    static var identifier: String { return String(describing: self) }
    static var nib:UINib { return UINib(nibName: identifier, bundle: nil) }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textView.text = FeedbackMangerConstants.textViewPlaceholder
        textView.textColor = UIColor.lightGray
        
        //textView.becomeFirstResponder()
        
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
