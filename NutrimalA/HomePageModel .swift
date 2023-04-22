import Foundation
import SwiftUI
struct HomePageModel {
    var displayingWorkoutLogView: Bool = false
    
    private(set) var exercises: [Exersise] = Bundle.main.decode("Exercises.json")
    
    private(set) var history: [[WorkoutLogModel.ExersiseLogModule]] = []
    
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
    

    mutating func addToHistory(exersiseModules: [WorkoutLogModel.ExersiseLogModule]) {

        history.append(exersiseModules)
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
                history = try JSONDecoder().decode([[WorkoutLogModel.ExersiseLogModule]].self, from: savedData)
            } catch {
                print("Failed to decode exersiseModules: \(error.localizedDescription)")
            }
        }
    }

}
