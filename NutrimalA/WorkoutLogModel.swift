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
       
    }

    struct ExersiseLogModule {
        var exersiseName: String
        var setRows: Array<ExersiseSetRows> = []
        
        mutating func addEmptyView(workoutModule: ExersiseLogModule){
         
        }
        

    }

    struct ExersiseSetRows: Identifiable {
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
