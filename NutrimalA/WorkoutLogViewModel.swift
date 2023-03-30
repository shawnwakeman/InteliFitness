//
//  WorkoutLogViewModel.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 3/29/23.
//

import SwiftUI


class WorkoutLogViewModel: ObservableObject {
    
    private static func createWorkoutLogModel() -> WorkoutLogModel{
        WorkoutLogModel()
    }
    
    @Published var workoutLogModel = createWorkoutLogModel()
    
    
    
    // MARK: - Intent(s)
    
    func addEmptySet(workoutModule: WorkoutLogModel.ExersiseLogModule){
        
    }
}
