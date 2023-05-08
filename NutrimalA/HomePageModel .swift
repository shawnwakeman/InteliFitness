import Foundation
import SwiftUI
struct HomePageModel {
        var displayingWorkoutLogView: Bool

        var exercises: [Exersise]

        private(set) var history: [Workout] = []
    
        private(set) var myExercises: [Workout] = []
    
        private(set) var exerciseQueue: [Exersise] = []
    
        private(set) var workouts = [Date: [ScheduleWorkout]]()

        var currentExervice: Exersise?
    
        var ongoingWorkout: Bool


    init(displayingWorkoutLogView: Bool = false, ongoingWorkout: Bool = false) {
            self.displayingWorkoutLogView = displayingWorkoutLogView
            self.ongoingWorkout = ongoingWorkout
  
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
    

    
    func saveOngoingWorkoutStatus(status: Bool) {
        UserDefaults.standard.set(status, forKey: "ongoingWorkout")
    }
    
    mutating func loadOngoingWorkoutStatus() {
        ongoingWorkout = UserDefaults.standard.bool(forKey: "ongoingWorkout")
   
    }
    
    mutating func setCurrentExercise(execise: Exersise) {
        currentExervice = execise
    }
    
    struct Workout: Identifiable, Codable {
        let id: UUID
        let WorkoutName: String
        var notes: String = ""
        var exercises: [WorkoutLogModel.ExersiseLogModule]
        var category: String
    }
    
    
    mutating func setOngoingWorkoutState(state: Bool) {
        ongoingWorkout = state
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
        

        // needs to be cleaned
        let filterExerciseModules =  exersiseModules.filter { !$0.isLast }
        let removedBlankRows = removeIncompleteSets(from: filterExerciseModules)
        
        for exercise in removedBlankRows {
            let exerciseID = exercise.ExersiseID
            exercises[exerciseID].exerciseHistory.append(exercise)
        }
        history.append(Workout(id: UUID(), WorkoutName: workoutName, exercises: removedBlankRows, category: ""))
    }
    
    mutating func addToMyExercises(workoutName: String, exersiseModules: [WorkoutLogModel.ExersiseLogModule]) {
        

        // needs to be cleaned
        let filterExerciseModules =  exersiseModules.filter { !$0.isLast }
   
        
        
        myExercises.append(Workout(id: UUID(), WorkoutName: workoutName, exercises: filterExerciseModules, category: ""))
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
    
    mutating func saveMyWorkouts() {
        saveExercisesToUserDefaults(exercises)
        let defaults = UserDefaults.standard

        do {
          
            let encodedData = try JSONEncoder().encode(myExercises)
            defaults.set(encodedData, forKey: "myExercises")
        } catch {
            print("Failed to encode exersiseModules: \(error.localizedDescription)")
        }
    }
    
    mutating func loadMyExercises() {
        let defaults = UserDefaults.standard

        if let savedData = defaults.object(forKey: "myExercises") as? Data {
            do {
                history = try JSONDecoder().decode([HomePageModel.Workout].self, from: savedData)
            } catch {
                print("Failed to decode exersiseModules: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Schedule
    
    struct ScheduleWorkout: Identifiable {
        var id: Int
        var name: String
        var exercises: [String]
        var duration: Int
        var recurringID: Int?
    }

    
    enum RecurringOption: String, CaseIterable, Identifiable {
        var id: String { self.rawValue }
        case none, daily, weekly
    }

    private func startOfDay(for date: Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: components) ?? date
    }

    mutating func addWorkout(to date: Date, workout: ScheduleWorkout, recurringOption: RecurringOption) {
        let dateKey = startOfDay(for: date)

        switch recurringOption {
        case .none:
            addWorkout(to: dateKey, workout: workout)
        case .daily:
            for i in 0..<30 {
                if let newDate = Calendar.current.date(byAdding: .day, value: i, to: dateKey) {
                    addWorkout(to: newDate, workout: workout)
                }
            }
        case .weekly:
            for i in 0..<12 {
                if let newDate = Calendar.current.date(byAdding: .weekOfYear, value: i, to: dateKey) {
                    addWorkout(to: newDate, workout: workout)
                }
            }
        }
    }
    
    mutating func removeRecurringWorkouts(workoutID: Int, recurringID: Int) {
        for (date, workoutList) in workouts {
            let filteredWorkoutList = workoutList.filter { $0.id != workoutID || $0.recurringID != recurringID }
            workouts[date] = filteredWorkoutList
            
        }
    }

    private mutating func addWorkout(to date: Date, workout: ScheduleWorkout) {
        if var workoutList = workouts[date] {
            workoutList.append(workout)
            workouts[date] = workoutList
        } else {
            workouts[date] = [workout]
        }
    }

    mutating func removeWorkout(from date: Date, workoutID: Int) {
        let dateKey = startOfDay(for: date)
        if var workoutList = workouts[dateKey] {
            workoutList.removeAll { $0.id == workoutID }
            workouts[dateKey] = workoutList
        }
    }

    func getWorkouts(for date: Date) -> [ScheduleWorkout]? {
        let dateKey = startOfDay(for: date)
        return workouts[dateKey]
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
