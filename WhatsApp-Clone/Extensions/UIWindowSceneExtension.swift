//
//  UIWindowSceneExtension.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 15/8/24.
//

import UIKit

extension UIWindowScene {
    static var current: UIWindowScene? {
        return UIApplication.shared.connectedScenes.first { $0 is UIWindowScene } as? UIWindowScene
    }
    
    var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
}
