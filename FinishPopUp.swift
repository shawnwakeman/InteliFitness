//
//  FinishPopUp.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 5/10/23.
//

import SwiftUI

struct FinishPopUp: View {
    @State private var time: Double = 0
    @State private var isToggled = false
    @ObservedObject var homePageViewModel: HomePageViewModel
    @ObservedObject var timeViewModel: TimeViewModel
   
    @ObservedObject var viewModel: WorkoutLogViewModel
    @State private var radomeState = false
    var body: some View {
        VStack {
            
            HStack {

                
                
                TextHelvetica(content: "Workout Completed", size: 27)
                    .foregroundColor(Color("WhiteFontOne"))
                Spacer()
                Button {

                
                    HapticManager.instance.impact(style: .rigid)

                    timeViewModel.setWorkoutTime(time: 0)

                    withAnimation(.spring()) {
                        homePageViewModel.setOngoingState(state: false)
                        homePageViewModel.setWorkoutLogModuleStatus(state: false)

                    }

                    homePageViewModel.saveExersiseHistory()
                    viewModel.resetWorkoutModel()
                    cancelNotifications()
                   


                }
                label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color("BorderGray"), lineWidth: borderWeight))
                            .foregroundColor(Color("MainGray"))
                        Image("checkMark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 17, height: 17)
                    }
                    
                        
                }.frame(width: 50, height: 30)
                
            }
            .padding(.top, -2)
            .padding(.horizontal)
            .padding(.vertical, 10)
            Spacer()
            TextHelvetica(content: "Good Job", size: 20)
                .foregroundColor(Color(.clear))
            
            if let workout = homePageViewModel.history.last {
                ExpandedHistory(workout: workout, viewModel: homePageViewModel, showingExpandedExercise: $radomeState , isforFinish: true)
            }
            Spacer()
         

                        
           
   

        }


        .frame(height: getScreenBounds().height * 0.7)
        .background(Color("DBblack"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("BorderGray"), lineWidth: borderWeight))
        .padding(.all)
    }
}

