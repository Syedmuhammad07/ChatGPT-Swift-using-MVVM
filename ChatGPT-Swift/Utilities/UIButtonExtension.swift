//
//  UIButtonExtension.swift
//  ChatGPT-Swift
//
//  Created by Syed Muhammad on 26/03/2023.
//

import Foundation
import UIKit

extension UIButton {
    
    func disable() {
        self.layer.opacity = 0.5
        self.isUserInteractionEnabled = false
    }
    
    func enable() {
        self.layer.opacity = 1.0
        self.isUserInteractionEnabled = true
    }
}
