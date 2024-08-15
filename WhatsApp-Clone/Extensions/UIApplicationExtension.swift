//
//  UIApplicationExtension.swift
//  WhatsApp-Clone
//
//  Created by shopnil hasan on 15/8/24.
//

import UIKit

extension UIApplication {
    static func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
