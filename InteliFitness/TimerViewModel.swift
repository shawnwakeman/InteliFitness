//
//  WorkoutLogViewModel.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 3/29/23.
//

import SwiftUI


class TimeViewModel: ObservableObject {
    

    @Published var timeViewModel = TimerModel()
    var workoutTime: TimerModel.WorkoutTime {
        return timeViewModel.workoutTime
    
    }
    
    var restTime: TimerModel.WorkoutTime {
        return timeViewModel.restTime
    
    }
    
  
    
    // MARK: - Intent(s)
    
    func setTimeStep(step: Int) {
        timeViewModel.setTimeStep(step: step)
    }
    
    func setRestTime(time: Int) {
        
        timeViewModel.setRestTime(time: time)
    }


    func setWorkoutTime(time: Int) {
        timeViewModel.setWorkoutTime(time: time)
    }
 
    
    func restAddToTime(step: Int, time: Int? = nil) {
        if let time = time {
            
            timeViewModel.setRestTime(time: time)
            
        } else {
            // Toggle the current display status if no custom value was provided
            timeViewModel.restAddToTime(step: step)
        }
        
    }
    func setTimePreset(time: Int) {
        timeViewModel.setTimePreset(time: time)
    }
    

    
    func toggleTime(){
        timeViewModel.toggleTime()
    }
    func addToTime(step: Int){

        timeViewModel.addToTime(step: step)
    }
    
    

    

    func editRestTime(time: Int) {
        timeViewModel.editRestTime(time: time)
    }
    

    func saveTimers() {
        timeViewModel.saveTimers()

    }
    
    func loadTimers(isInitialViewLoad: Bool) {
        if timeViewModel.workoutTime.timeStep > 0 {
            timeViewModel.loadTimers(isInitialViewLoad: isInitialViewLoad)
        }
      
    }
    

    

}
