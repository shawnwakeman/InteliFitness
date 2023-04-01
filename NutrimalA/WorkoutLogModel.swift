//
//  WorkoutLogModel.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 3/29/23.
//

import Foundation


struct WorkoutLogModel {
    var exersiseModules: Array<ExersiseLogModule> = []
    
    init() {
        exersiseModules.append(ExersiseLogModule(exersiseName: "shawn", id: 0))
        exersiseModules[0].setRows.append(ExersiseSetRow(setIndex: 1, previousSet: "sad", weight: 123, reps: 12, setCompleted: false, rowSelected: false, repMetric: 2, id: 1))
    }
    
    mutating func addEmptySet(moduleID: Int){
        exersiseModules[0].setRows.append(ExersiseSetRow(setIndex: 1, previousSet: "sad", weight: 123, reps: 12, setCompleted: false, rowSelected: false, repMetric: 2, id: 1))
    }
    
    func addEmptySetHelper(lastRowID: Int) -> ExersiseSetRow {
        return ExersiseSetRow(setIndex: (lastRowID + 1), previousSet: "", weight: 0, reps: 0, setCompleted: false, rowSelected: false, repMetric: 0, id: (lastRowID + 1))
    }

    struct ExersiseLogModule: Identifiable {
        var exersiseName: String
        var setRows: Array<ExersiseSetRow> = []
        var id: Int
        mutating func addEmptyView(workoutModule: ExersiseLogModule){
         
        }
        

    }

    struct ExersiseSetRow: Identifiable {
        var setIndex: Int
        var previousSet: String
        var weight: Float
        var reps: Int
        var setCompleted: Bool
        var rowSelected: Bool
        var repMetric: Int
        
        let id: Int
        


    }
    
    
}
