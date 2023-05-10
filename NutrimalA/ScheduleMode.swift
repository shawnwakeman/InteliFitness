//
//  ScheduleMode.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 5/6/23.
//

import Foundation

struct ScheduleWorkout: Identifiable {
    var id: Int
    var name: String
    var exercises: [WorkoutLogModel.ExersiseLogModule]
    var recurringID: Int?
}

struct Schedule {
    private(set) var workouts = [Date: [ScheduleWorkout]]()
    
    private(set) var workoutQueue: HomePageModel.Workout?

  
    enum ReminderOption: String, CaseIterable, Identifiable {
        var id: String { self.rawValue }
        case none = "None"
        case fiveMinutes = "5 mins"
        case fifteenMinutes = "15 mins"
        case thirtyMinutes = "30 mins"
    }
    enum RecurringOption: String, CaseIterable, Identifiable {
        var id: String { self.rawValue }
        case none, daily, weekly
    }
    
    mutating func addToWorkoutQueue(workout: HomePageModel.Workout) {
        workoutQueue = workout
    }
    mutating func clearWorkoutQueue() {
        workoutQueue = nil
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
