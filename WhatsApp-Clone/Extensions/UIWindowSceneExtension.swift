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
        return UIWindowScene.current?.screen.bounds.width ?? 0
    }
    
    var screenHeight: CGFloat {
        return UIWindowScene.current?.screen.bounds.height ?? 0
    }
}
