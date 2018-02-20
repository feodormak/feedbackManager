//
//  FeedbackTypes.swift
//  feedbackManager
//
//  Created by feodor on 20/2/18.
//  Copyright © 2018 feodor. All rights reserved.
//

import Foundation

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
//end of redef

enum FeedbackMangerConstants {
    static let categoryType:[String:SideMenuPageType] = ["Stations":.stations,"Reference":.reference]
    static let stationSectionLabels = ["Details", "Warning", "Caution", "Notes", "Pre-flight", "Enroute", "Arrival", "Approach", "Ground Ops", "Departure", "Terrain", "Weather", "Diversion"]
    static let typeLabel:[FeedbackType:String] = [ .new:"New",.exisitng: "Existing"]
    
    
    //test data
    static let stationsID = ["WSSS", " WAAA", "WIPP", "RPVM", "ZUUU", "VTSP", "ZUCK", "VECC", "VOMM", "VOHS", "WMKK"]
    static let referenceSection = ["CTAF Ops", "ADS-B", "TCAS Requirements", "FANS - Using CPDLC to Relay Messages"]
    static let referenceSubSections = [ ["CTAF Procedures", "Pilot Activated Lighting(PAL)","Non-towered Aerodromes"],
                                        ["Procedure","Flight Planning","Emergency","System Malfunction"],
                                        ["Requirements"],
                                        ["Areas of Operations"]]
}


enum FeedbackType {
    case new
    case exisitng
}

class FeedbackItem {
    let feedbackType: FeedbackType
    let page: Page
    let section: String
    let contentID: String?
    let comments: String = ""
    
    init(feedbackType: FeedbackType, pageType: SideMenuPageType, pageID: String, section: String, contentID: String? = nil){
        self.feedbackType = feedbackType
        self.page = Page(pageID: pageID, pageType: pageType)
        self.section = section
        self.contentID = contentID
    }
}
