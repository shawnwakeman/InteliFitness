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
    
    @Published var hidingPopUps = false
    
    @Published var popUpStates = ["3DotsPopUp": false, "DataMetricsPopUp": false, "key3": true]
    
    

    var exersiseModules: Array<WorkoutLogModel.ExersiseLogModule> {
        return workoutLogModel.exersiseModules
    }
    
    var workoutTime: WorkoutLogModel.WorkoutTime {
        return workoutLogModel.workoutTime
    
    }
    

    
    
    
    var RPEPopUp: WorkoutLogModel.PopUpRPE {
        return workoutLogModel.popUpRPE
    
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
    
    func saveBackgroundTime(){
        workoutLogModel.saveBackgroundTime()
    }
    func updateTimeToCurrent(){
        workoutLogModel.updateTimeToCurrent()
    }
    func setPopUpState(state: Bool) {
        workoutLogModel.setPopUpState(state: state)
    }
    func setPopUpCurrentRow(exersiseModuleID : Int, RowID: Int) {
        workoutLogModel.setPopUpCurrentRow(exersiseModuleID: exersiseModuleID, RowID: RowID)
    }
    func setRepMetric(exersiseModuleID : Int, RowID: Int, RPE: Float) {
        workoutLogModel.setRepMetric(exersiseModuleID: exersiseModuleID, RowID: RowID, RPE: RPE)
    }
        
}
