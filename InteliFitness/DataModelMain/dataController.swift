//
//  dataController.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/21/23.
//

//
//  dataController.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/21/23.
//

import Foundation
import CoreData


class DataController: ObservableObject {
    let container = NSPersistentContainer(name: "WorkoutLogDataModel")
    
    
    init() {
        container.loadPersistentStores { desc, error in
            if let error = error {
                print("errors are for pussys \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("data saved")
        } catch {
            print("data save fail")
        }
    }
    
    func addRowData(setIndex: Int, previousSet: String = "0", weight: Float = 0, reps: Int = 0, weightPlaceholder: String = "", repsPlaceholder: String = "", setCompleted: Bool = false, rowSelected: Bool = false, repMetric: Float = 0, prevouslyChecked: Bool = false, id: Int, context : NSManagedObjectContext) {
        let row = RowDataModel(context: context)
        row.setIndex = Int16(setIndex)
        row.previousSet = previousSet
        row.weight = weight
        row.reps = Int16(reps)
        row.weightPlaceholder = weightPlaceholder
        row.repsPlaceholder = repsPlaceholder
        row.setCompleted = setCompleted
        row.rowSelected = rowSelected
        row.repMetric = repMetric
        row.prevouslyChecked = prevouslyChecked
        row.id = Int16(id)

        save(context: context)
        
        
    }
}
