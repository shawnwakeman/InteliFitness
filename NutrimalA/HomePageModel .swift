import Foundation
import SwiftUI
struct HomePageModel {
    var displayingWorkoutLogView: Bool = false
    
    private(set) var exercises: [Exersise] = Bundle.main.decode("Exercises.json")
    
    private(set) var history: [Workout] = []
    
    
    struct Workout: Identifiable, Codable {
        let id: UUID
        let WorkoutName: String
        let notes: String = ""
        var exercises: [WorkoutLogModel.ExersiseLogModule]
    }

    
    struct Exersise: Identifiable, Decodable {
        var exerciseName: String
        var exerciseCategory: [String]
        var exerciseEquipment: String
        let id: Int
        var selected: Bool = false
    }
    
    mutating func setWorkoutLogModuleStatus(state: Bool) {
        displayingWorkoutLogView = state
    }
    

    func checkLetter(letter: String) -> Bool {
        for exercise in exercises {
            if let firstLetter = exercise.exerciseName.first {
                if String(firstLetter).uppercased() == letter.uppercased() {
                    return true
                }
            }
        }
        return false
    }
    

    mutating func addToHistory(workoutName: String, exersiseModules: [WorkoutLogModel.ExersiseLogModule]) {
        // needs to be cleaned
        let filterExerciseModules =  exersiseModules.filter { !$0.isLast }
        let removedBlankRows = removeIncompleteSets(from: filterExerciseModules)
        history.append(Workout(id: UUID(), WorkoutName: workoutName, exercises: removedBlankRows))
    }
    
    mutating func deleteFromHistory(workoutID: UUID) {
        if let index = history.firstIndex(where: { $0.id == workoutID }) {
            history.remove(at: index)
        }
    }
    
    func removeIncompleteSets(from exerciseLogModules: [WorkoutLogModel.ExersiseLogModule]) -> [WorkoutLogModel.ExersiseLogModule] {
        var updatedExerciseLogModules: [WorkoutLogModel.ExersiseLogModule] = []
        
        print(exerciseLogModules)
        
        for exerciseLogModule in exerciseLogModules {
            var updatedExerciseLogModule = exerciseLogModule
            updatedExerciseLogModule.setRows = exerciseLogModule.setRows.filter { $0.setCompleted }
            
            // Only append the updatedExerciseLogModule if its setRows is not empty
            if !updatedExerciseLogModule.setRows.isEmpty {
                updatedExerciseLogModules.append(updatedExerciseLogModule)
            }
        }
        
        print(updatedExerciseLogModules)
        
        return updatedExerciseLogModules
    }

    
    func saveExersiseHistory() {
        let defaults = UserDefaults.standard

        do {
          
            let encodedData = try JSONEncoder().encode(history)
            defaults.set(encodedData, forKey: "history")
        } catch {
            print("Failed to encode exersiseModules: \(error.localizedDescription)")
        }
    }

    
    
    mutating func loadHistory() {
        let defaults = UserDefaults.standard

        if let savedData = defaults.object(forKey: "history") as? Data {
            do {
                history = try JSONDecoder().decode([HomePageModel.Workout].self, from: savedData)
            } catch {
                print("Failed to decode exersiseModules: \(error.localizedDescription)")
            }
        }
    }

}
