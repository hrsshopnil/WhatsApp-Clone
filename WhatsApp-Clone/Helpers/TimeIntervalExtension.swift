//
//  TimeIntervalExtension.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 13/8/24.
//

import Foundation

extension TimeInterval {
    var formattedElapsedTime: String {
        let minutes = Int(self) / 60
        let seconds = Int(self) % 60
        
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    static var stubTimeInterval: TimeInterval {
        return TimeInterval()
    }
}
