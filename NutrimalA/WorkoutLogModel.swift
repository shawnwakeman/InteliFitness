//
//  WorkoutLogModel.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 3/29/23.
//

import Foundation


struct WorkoutLogModel {
    private(set) var exersiseModules: Array<ExersiseLogModule> = []
    
    init() {
        self.exersiseModules.append(ExersiseLogModule(exersiseName: "Back Squat", id: 0))
    }
    mutating func addEmptySet(moduleID: Int){
        let lastRowIndex = exersiseModules[moduleID].setRows.count
        exersiseModules[moduleID].setRows.append(addEmptySetHelper(lastRowID: lastRowIndex))
 
        
        
    }
    
    mutating func addEmptyWorkoutModule(){
    
        let index = exersiseModules.count
        exersiseModules.append(ExersiseLogModule(exersiseName: "Back Squat", id: index))
        
    }
    mutating func toggleCompletedSet(ExersiseModuleID: Int, RowID: Int){
        
        exersiseModules[ExersiseModuleID].setRows[(RowID)].setCompleted.toggle()
    }
                                                  
    func addEmptySetHelper(lastRowID: Int) -> ExersiseSetRow {
          return ExersiseSetRow(setIndex: (lastRowID + 1), previousSet: "0", weight: 0, reps: 0, weightPlacholder: "", repsPlacholder: "", setCompleted: false, rowSelected: false, repMetric: 2, id: (lastRowID))
        
    }
        
    struct ExersiseLogModule: Identifiable {
        var exersiseName: String
        var setRows: Array<ExersiseSetRow> = [ExersiseSetRow(setIndex: 1, previousSet: "0", weight: 0, reps: 0, weightPlacholder: "", repsPlacholder: "99", setCompleted: false, rowSelected: false, repMetric: 7, id: 0)]
        var id: Int
    
        
            
    }
        
    struct ExersiseSetRow: Identifiable {
        var setIndex: Int
        var previousSet: String
        var weight: Float
        var reps: Int
        var weightPlacholder: String
        var repsPlacholder: String
        var setCompleted: Bool
        var rowSelected: Bool
        var repMetric: Int
        let id: Int
        
        
        
    }
    
}
