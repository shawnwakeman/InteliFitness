import Foundation
import SwiftUI
import Combine

struct HomePageModel {
        var displayingWorkoutLogView: Bool

        var exercises: [Exersise]

        private(set) var history: [Workout] = []
    
        private(set) var myExercises: [Workout] = []
        private(set) var myExercisesRecent: [Workout] = []
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
        var id: UUID
        var WorkoutName: String
        var notes: String = ""
        var exercises: [WorkoutLogModel.ExersiseLogModule]
        var category: String
        var competionDate: Date
        var workoutTime: Int = 0
        
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
        var isDeleted: Bool = false
        var restTime: Int
        var notes: String = ""
        var instructions: [String]
        var exerciseHistory: [WorkoutLogModel.ExersiseLogModule] = []
        
        var moduleType: WorkoutLogModel.moduleType
      
        
        
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
    

    mutating func addToHistory(workoutName: String, exersiseModules: [WorkoutLogModel.ExersiseLogModule], workoutTime: Int, workoutNotes: String) {
        

        // needs to be cleaned
        let filterExerciseModules =  exersiseModules.filter { !$0.isLast }
        let removedBlankRows = removeIncompleteSets(from: filterExerciseModules)
        let oldID = UUID()
        for exercise in removedBlankRows {
            let exerciseID = exercise.ExersiseID
            var updatedExercise = exercise
            updatedExercise.DateCompleted = Date()
            updatedExercise.id = UUID()
            updatedExercise.oldWorkoutId = oldID
            exercises[exerciseID].exerciseHistory.append(updatedExercise)
        }
        if !removedBlankRows.isEmpty {
            history.append(Workout(id: oldID, WorkoutName: workoutName, notes: workoutNotes, exercises: removedBlankRows, category: "", competionDate: Date(), workoutTime: workoutTime))
        }
        
    }
    
    mutating func addToMyExercises(workoutName: String, exersiseModules: [WorkoutLogModel.ExersiseLogModule]) {
        

        // needs to be cleaned
        let filterExerciseModules =  exersiseModules.filter { !$0.isLast }
        
        
        if myExercisesRecent.count >= 15 {
            myExercisesRecent.removeFirst()
        }
   
        
        
        myExercises.append(Workout(id: UUID(), WorkoutName: workoutName, exercises: filterExerciseModules, category: "", competionDate: Date()))
    }
    mutating func editMyWorkouts(workoutName: String, exerciseModules: [WorkoutLogModel.ExersiseLogModule], id: UUID) {
        // Filter the exercise modules
        let filteredExerciseModules = exerciseModules.filter { !$0.isLast }
        
        // Create new workout
        let newWorkout = Workout(id: id, WorkoutName: workoutName, exercises: filteredExerciseModules, category: "", competionDate: Date())
        
        // Try to find the existing workout by id
        if let index = myExercises.firstIndex(where: { $0.id == id }) {
            // If the workout is found, replace it
            myExercises[index] = newWorkout
        }
    }
    

    
    mutating func addToMyExercisesRecent(workoutName: String, exersiseModules: [WorkoutLogModel.ExersiseLogModule]) {
        // needs to be cleaned
        var filterExerciseModules =  exersiseModules.filter { !$0.isLast }
        let removedBlankRows = removeIncompleteSets(from: filterExerciseModules)
        


        for index in removedBlankRows.indices {
            for rowIndex in filterExerciseModules[index].setRows.indices {
                filterExerciseModules[index].setRows[rowIndex].reset()
            }
        }

        // If the list is at maximum capacity, remove the first (oldest) element
        if myExercisesRecent.count >= 8 {
            myExercisesRecent.removeFirst()
        }

        myExercisesRecent.append(Workout(id: UUID(), WorkoutName: workoutName, exercises: filterExerciseModules, category: "", competionDate: Date()))
    }
    
    mutating func deleteFromHistory(workoutID: UUID) {
        if let index = history.firstIndex(where: { $0.id == workoutID }) {
            let workout = history[index]
            
            print(workout)
            for exercise in workout.exercises {
                let exerciseID = exercise.ExersiseID
                let exerciseLogModuleUUID = exercise.DateCompleted // bad
                for exerciseIteration in exercises[exerciseID].exerciseHistory {
                    if exerciseIteration.oldWorkoutId == workout.id {
                        
                        
                        if let index = exercises[exerciseID].exerciseHistory.firstIndex(where: { $0.oldWorkoutId == workout.id }) {
                            print("module to be deleted")
                            print(exercises[exerciseID].exerciseHistory[index])
                            
                            exercises[exerciseID].exerciseHistory.remove(at: index)
                          
                        } else {
                            print("did not save")
                        }
                    } else {
                        
                        print("save 2.0")
                        
                    }
                }
            }
            history.remove(at: index)
        }
    }
    
    mutating func deleteMyWorkouts(workoutID: UUID) {
        if let index = myExercises.firstIndex(where: { $0.id == workoutID }) {
            
            
            myExercises.remove(at: index)
        }
    }
    mutating func deleteMyWorkoutRecent(workoutID: UUID) {
        if let index = myExercisesRecent.firstIndex(where: { $0.id == workoutID }) {
            
            myExercisesRecent.remove(at: index)
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
    
    mutating func resetID(workoutID: UUID) {
        if let index = myExercises.firstIndex(where: { $0.id == workoutID }) {
            // Use the index to access or modify the workout.
            // For example, to reset the workout you can do:
            myExercises[index].id = UUID() // This is just an example, replace `Workout()` with your initial state for a workout.
        }
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

    mutating func clearSelectionState(ExersiseID: Int) {
        exercises[ExersiseID].selected = false
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
    
    mutating func setNotes(notes: String, moduleID: Int) {
        if moduleID < exercises.count {
            exercises[moduleID].notes = notes
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
    
    mutating func setEditsForHistory(hours: Int, Minutes: Int, Name: String, workoutId: UUID) {
        if let foundItem = history.firstIndex(where: { $0.id == workoutId }) {
            history[foundItem].WorkoutName = Name
            history[foundItem].workoutTime = (hours * 3600) + (Minutes * 60)
        }
    }
    

    
    mutating func saveMyWorkouts() {
        let defaults = UserDefaults.standard

        // Limit myExercisesRecent array to 8 elements
        while myExercisesRecent.count > 8 {
            myExercisesRecent.removeFirst()
        }

        do {
            let encodedData = try JSONEncoder().encode(myExercises)
            defaults.set(encodedData, forKey: "myExercises")
            let encodedData2 = try JSONEncoder().encode(myExercisesRecent)
            defaults.set(encodedData2, forKey: "myExercisesRecent")
        } catch {
            print("Failed to encode exerciseModules: \(error.localizedDescription)")
        }
    }

    
    mutating func loadMyExercises() {
        let defaults = UserDefaults.standard

        if let savedData = defaults.object(forKey: "myExercises") as? Data {
            do {
                myExercises = try JSONDecoder().decode([HomePageModel.Workout].self, from: savedData)
            } catch {
                print("Failed to decode exersiseModules: \(error.localizedDescription)")
            }
        }
        if let savedData2 = defaults.object(forKey: "myExercisesRecent") as? Data {
            do {
                myExercisesRecent = try JSONDecoder().decode([HomePageModel.Workout].self, from: savedData2)
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
    
    mutating func setExerciseName(exerciseID: Int, newName: String) {
        exercises[exerciseID].exerciseName = newName
    }
    
    mutating func deleteExercise(exerciseID: Int) {
        exercises[exerciseID].isDeleted.toggle()
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


extension WorkoutLogModel.ExersiseSetRow {
    mutating func reset() {
        self.weight = 0
        self.reps = 0
        self.repMetric = 0
        self.setCompleted = false
        self.prevouslyChecked = false
    }
}





import StoreKit
class AppTimer: NSObject, ObservableObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    @Published var timeRemaining: Int
     let productID: String
     var cancellable: AnyCancellable?

     override init() {
         let lastSavedTime = UserDefaults.standard.double(forKey: "lastSavedTime")
         let elapsedTime = lastSavedTime > 0 ? Int(Date().timeIntervalSince1970 - lastSavedTime) : 0
         self.timeRemaining = UserDefaults.standard.integer(forKey: "timeRemaining") > elapsedTime ? UserDefaults.standard.integer(forKey: "timeRemaining") - elapsedTime : 3600 * 168

         self.productID = "your_product_id" // Set your product id here
         super.init()
         SKPaymentQueue.default().add(self)

         NotificationCenter.default.addObserver(self, selector: #selector(saveState), name: UIApplication.didEnterBackgroundNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(loadState), name: UIApplication.willEnterForegroundNotification, object: nil)

         startTimer()
     }

     func startTimer() {
         cancellable = Timer.publish(every: 1, on: .main, in: .common)
             .autoconnect()
             .sink { [weak self] _ in
                 self?.decreaseTimer()
             }
     }

     @objc private func saveState() {
         UserDefaults.standard.setValue(timeRemaining, forKey: "timeRemaining")
         UserDefaults.standard.setValue(Date().timeIntervalSince1970, forKey: "lastSavedTime")
     }

     @objc private func loadState() {
         let lastSavedTime = UserDefaults.standard.double(forKey: "lastSavedTime")
         let elapsedTime = lastSavedTime > 0 ? Int(Date().timeIntervalSince1970 - lastSavedTime) : 0
         timeRemaining -= elapsedTime
     }

     func decreaseTimer() {
         if timeRemaining > 0 {
             timeRemaining -= 1
             saveState()
         } else {
             // Timer is up, initiate purchase
             promptForPurchase()
         }
     }

    func promptForPurchase() {
        // Check if can make payments
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKProductsRequest(productIdentifiers: [productID])
            paymentRequest.delegate = self
            paymentRequest.start()
        }
    }

    func purchaseProduct(_ product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    // MARK: - SKProductsRequestDelegate

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let product = response.products.first {
            // We have the product, proceed to purchase
            purchaseProduct(product)
        }
    }
    
    // MARK: - SKPaymentTransactionObserver

    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased || transaction.transactionState == .restored {
                // Handle successful purchase or restore
                SKPaymentQueue.default().finishTransaction(transaction)
            } else if transaction.transactionState == .failed {
                // Handle failed transaction
                SKPaymentQueue.default().finishTransaction(transaction)
            }
        }
    }
}
