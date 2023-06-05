//
//  HapticManager.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/7/23.
//
import SwiftUI

class HapticManager {
    static let instance = HapticManager()
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let genorator = UINotificationFeedbackGenerator()
        genorator.notificationOccurred(type)
    }
        
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let genorator = UIImpactFeedbackGenerator(style: style)
        genorator.impactOccurred()
    }
        
    
}
