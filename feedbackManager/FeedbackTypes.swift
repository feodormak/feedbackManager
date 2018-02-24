//
//  FeedbackTypes.swift
//  feedbackManager
//
//  Created by feodor on 20/2/18.
//  Copyright © 2018 feodor. All rights reserved.
//

import UIKit

//redef, to be deleted
enum SideMenuPageType {
    case stations
    case reference
}

class Page {
    let pageID: String
    let pageType: SideMenuPageType
    init(pageID:String, pageType: SideMenuPageType) {
        self.pageID = pageID
        self.pageType = pageType
    }
}

enum RouteItemType {
    case basics
    case wcn
    case body
    case hazards
    case diversion
    case sidemenu
}

enum wcnType {
    case warning
    case caution
    case note
}

enum BodyType {
    case preflight
    case enroute
    case arrival
    case approach
    case groundops
    case departure
    case terrain
    case weather
}

extension UIColor{
    static let baseColor = UIColor(netHex: 0x3b4656)
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}
//end of redef

enum FeedbackMangerConstants {
    static let categoryType:[SideMenuPageType:String] = [.stations:"Stations",.reference:"Reference"]
    static let stationSectionLabels = ["Details", "Warning", "Caution", "Notes", "Pre-flight", "Enroute", "Arrival", "Approach", "Ground Ops", "Departure", "Terrain", "Weather", "Diversion"]
    static let typeLabel:[FeedbackType:String] = [ .suggestion:"Suggestion",.exisitng: "Exisiting content"]
    static let textViewPlaceholder = "Enter comments"
    static let contentHeaderText = "Current Content"
    static let commentHeaderText = "Comments"
    static let deleteWarningTitle = "Deleting feedback"
    static let deleteWarningText = "Are you sure you want to delete?"
    static let deleteText = "Delete"
    static let cancelText = "Cancel"
    static let editText = "Edit"
    static let selectAllText = "Select all"
    static let title = "Feedback"
    static let sendText = "Send"
    
    static let headerTitleLabelFontColor = UIColor.white
    static let requiredLabelFontColor = UIColor.red.withAlphaComponent(0.7)
    static let entryLabelFontColor = UIColor.darkGray
    
    static let titleLabelFont = UIFont.systemFont(ofSize: 17)
    static let requiredLabelFont = UIFont.systemFont(ofSize: 16)
    static let entryLabelFont = UIFont.systemFont(ofSize: 16)
    static let titleAttributes:[NSAttributedStringKey:Any] = [.foregroundColor:UIColor.white, .font:UIFont.systemFont(ofSize: 24)]
    
    static let navigationBarHeight: CGFloat = 64
    static let toolbarHeight:CGFloat = 44
    static let mainTableHeaderHeight:CGFloat = 54
    static let mainTableRowHeight:CGFloat = 70
    static let checkMarkRadius: CGFloat = 11
    static let checkMarkBorderWidth: CGFloat = 1.5
    static let mainTableRowOffset: CGFloat = 40
    //test data
    static let stationsID = ["WSSS", "WAAA", "WIPP", "RPVM", "ZUUU", "VTSP", "ZUCK", "VECC", "VOMM", "VOHS", "WMKK"]
    
    static let referenceID = ["CTAFOPS":"CTAF Ops", "ADSBOPS":"ADS-B","TCASREQ":"TCAS Requirements","FANSOPS":"FANS - Using CPDLC to Relay Messages"]
    static let referenceSection: [String:[String] ] = ["CTAFOPS":["CTAF Procedures", "Pilot Activated Lighting(PAL)","Non-towered Aerodromes"], "ADSBOPS":["Procedure","Flight Planning","Emergency","System Malfunction"], "TCASREQ":["Requirements"], "FANSOPS":["Areas of Operations"]]
}


enum FeedbackType {
    case suggestion
    case exisitng
}

enum FeedbackButtons{
    case category
    case page
    case section
}

class FeedbackItem {
    var feedbackType: FeedbackType
    var pageType: SideMenuPageType?
    var refID: String?
    var section: String?
    let contentID: String?
    var comments: String?
    
    init(feedbackType: FeedbackType, pageType: SideMenuPageType? = nil, refID: String? = nil, section: String? = nil, contentID: String? = nil){
        self.feedbackType = feedbackType
        self.pageType = pageType
        self.refID = refID
        self.section = section
        self.contentID = contentID
    }
}

extension FeedbackItem: Equatable {
    static func == (lhs: FeedbackItem, rhs: FeedbackItem) -> Bool{
        return lhs.feedbackType == rhs.feedbackType &&
            lhs.pageType == rhs.pageType &&
            lhs.refID == rhs.refID &&
            lhs.section == rhs.section &&
            lhs.contentID == rhs.contentID &&
            lhs.comments == rhs.comments        
    }
}

extension UIView {
    
    func shake() {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x:self.center.x - 10, y:self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x:self.center.x + 10, y:self.center.y))
        self.layer.add(animation, forKey: "position")
    }
    
}

