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
            WorkoutLogView(workoutLogViewModel: workoutLogView)
        }
    }
}
