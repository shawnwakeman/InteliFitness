//
//  WorkoutLogModel.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 3/29/23.
//

import Foundation


struct WorkoutLogModel {
    private(set) var exersiseModules: Array<ExersiseLogModule> = []
    

    mutating func addEmptySet(moduleID: Int){
        let lastRowIndex = exersiseModules[moduleID].setRows.count
        exersiseModules[moduleID].setRows.append(addEmptySetHelper(lastRowID: lastRowIndex))
        
    }
    
    mutating func addEmptyWorkoutModule(){
    
        let index = exersiseModules.count
        exersiseModules.append(ExersiseLogModule(exersiseName: "sad", id: index))
        
    }
                                                  
    func addEmptySetHelper(lastRowID: Int) -> ExersiseSetRow {
          return ExersiseSetRow(setIndex: (lastRowID + 1), previousSet: "sad", weight: 123, reps: 12, weightPlacholder: "0", repsPlacholder: "0", setCompleted: false, rowSelected: false, repMetric: 2, id: (lastRowID + 1))
    }
        
    struct ExersiseLogModule: Identifiable {
        var exersiseName: String
        var setRows: Array<ExersiseSetRow> = []
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
