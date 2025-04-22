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
    
    enum Tab {
        
    }
    
    enum Load {
        static let recommended = "load_recommended"
        static let theme = "load_theme"
        
        static let searchResult = "load_search_result"
    }
}
