import Foundation
import SwiftUI
struct HomePageModel {
    var displayingWorkoutLogView: Bool

        var exercises: [Exersise]

        private(set) var history: [Workout] = []
    
        private(set) var exerciseQueue: [Exersise] = []

        var currentExervice: Exersise?

        init(displayingWorkoutLogView: Bool = false) {
            self.displayingWorkoutLogView = displayingWorkoutLogView

            // Set the default state for the exercises array
            let defaultExercises: [Exersise] = Bundle.main.decode("Exercises.json")

            // Load exercises from UserDefaults or use the default state
            self.exercises = {
                if let loadedExercises = UserDefaults.standard.object(forKey: "Exercises") as? Data {
                    let decoder = JSONDecoder()
                    do {
                        let exercises = try decoder.decode([Exersise].self, from: loadedExercises)
                        return exercises
                    } catch {
                        print("Error decoding exercises: \(error)")
                    }
                }
                return defaultExercises
            }()
        }
    
   
    

    
    mutating func setCurrentExercise(execise: Exersise) {
        currentExervice = execise
    }
    
    struct Workout: Identifiable, Codable {
        let id: UUID
        let WorkoutName: String
        let notes: String = ""
        var exercises: [WorkoutLogModel.ExersiseLogModule]
    }
    
    

    
    struct Exersise: Identifiable, Codable {
        var exerciseName: String
        var exerciseCategory: [String]
        var exerciseEquipment: String
        let id: Int
        var selected: Bool = false
        var restTime: Int
        var instructions: [String]
        var exerciseHistory: [WorkoutLogModel.ExersiseLogModule] = []
    }
    
    mutating func setWorkoutLogModuleStatus(state: Bool) {
        displayingWorkoutLogView = state
    }
    


    
    mutating func removeExersiseFromQueue(exersiseID: Int) {
        if let index = exerciseQueue.firstIndex(where: { $0.id == exersiseID }) {
            exerciseQueue.remove(at: index)
            print("Removed item")
        } else {
            print("No matching item found")
        }

    }
    

    mutating func addToHistory(workoutName: String, exersiseModules: [WorkoutLogModel.ExersiseLogModule]) {
        
        for exercise in exersiseModules {
            let exerciseID = exercise.ExersiseID
            exercises[exerciseID].exerciseHistory.append(exercise)
        }
        // needs to be cleaned
        let filterExerciseModules =  exersiseModules.filter { !$0.isLast }
        let removedBlankRows = removeIncompleteSets(from: filterExerciseModules)
        history.append(Workout(id: UUID(), WorkoutName: workoutName, exercises: removedBlankRows))
    }
    
    mutating func deleteFromHistory(workoutID: UUID) {
        if let index = history.firstIndex(where: { $0.id == workoutID }) {
            let workout = history[index]
            for exercise in workout.exercises {
                let exerciseID = exercise.ExersiseID
                let exerciseLogModuleUUID = exercise.id
                for exerciseIteration in exercises[exerciseID].exerciseHistory {
                    if exerciseIteration.id == exerciseLogModuleUUID {
                        if let index = exercises[exerciseID].exerciseHistory.firstIndex(where: { $0.id == exerciseIteration.id }) {
                            exercises[exerciseID].exerciseHistory.remove(at: index)
                        }
                    }
                }
            }
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
    
    
    
    mutating func saveExercisesToUserDefaults(_ exercises: [Exersise]) {
        self.exercises = exercises
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(exercises)
            UserDefaults.standard.set(data, forKey: "Exercises")
        } catch {
            print("Error encoding exercises: \(error)")
        }
    }
    
    

    func loadExercisesFromUserDefaults() -> [Exersise]? {
        if let data = UserDefaults.standard.data(forKey: "Exercises") {
            let decoder = JSONDecoder()
            do {
                let exercises = try decoder.decode([Exersise].self, from: data)
                return exercises
            } catch {
                print("Error decoding exercises: \(error)")
                return nil
            }
        }
        return nil
    }


    mutating func setSelectionState(ExersiseID: Int) {
        exercises[ExersiseID].selected.toggle()
    }

    
    mutating func addToExersiseQueue(exersiseID: Int) {
        exerciseQueue.append(exercises[exersiseID])
    }
    
    mutating func clearToExersiseQueue() {
        exerciseQueue = []
        for index in exercises.indices {
 
   
            exercises[index].selected = false
        }
    }
    
    
    mutating func saveExersiseHistory() {
        saveExercisesToUserDefaults(exercises)
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







extension Bundle {
    func decode<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
        guard let url = self.url(forResource: filename, withExtension: nil) else {
            fatalError("Failed to find \(filename) in bundle.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(filename) from bundle.")
        }

        let decoder = JSONDecoder()
        guard let decodedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(filename) from bundle.")
        }

        return decodedData
    }
}
