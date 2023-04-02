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
    
    var exersiseModules: Array<WorkoutLogModel.ExersiseLogModule> {
        return workoutLogModel.exersiseModules
    }
    
    var workoutTime: WorkoutLogModel.WorkoutTime {
        return workoutLogModel.workoutTime
    
    }
    
    
    

    
    
    // MARK: - Intent(s)
    
    func addEmptySet(moduleID: Int){
        workoutLogModel.addEmptySet(moduleID: moduleID)
    }
    
    func addEmptyWorkoutModule() {
        workoutLogModel.addEmptyWorkoutModule()
    }
    
    func toggleCompletedSet(ExersiseModuleID: Int, RowID: Int) {
        workoutLogModel.toggleCompletedSet(ExersiseModuleID: ExersiseModuleID, RowID: RowID)
    }
    
    func toggleTime(){
        workoutLogModel.toggleTime()
    }
    func addToTime(){
        workoutLogModel.addToTime()
    }
        
}
