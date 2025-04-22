//
//  Analytics.swift
//  Mucket
//
//  Created by 조우현 on 4/22/25.
//

import Foundation

enum Event {
    enum Navigate {
        static let search = "navigate_search"
    }
    
    enum Tap {
        static let addContentsCanceled = "tab_add_contents_canceled"
        static let addContentsSaved = "tab_add_contents_saved"
    }
    
    enum Enter {
        static let addContents = "enter_add_contents"
    }
    
    enum Load {
        static let recommended = "load_recommended"
        static let theme = "load_theme"
        
        static let searchResult = "load_search_result"
    }
}
