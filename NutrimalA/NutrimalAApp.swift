//
//  NutrimalAApp.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 3/25/23.
//

import SwiftUI

@main
struct NutrimalAApp: App {
    private let workoutLogView = WorkoutLogViewModel()
    var body: some Scene {
        WindowGroup {
            WorkoutLogView()
                .border(Color.blue, width: 2) // Add the border m
        }
    }
}
