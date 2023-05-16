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
    @ObservedObject var viewModel: WorkoutLogViewModel
    var body: some View {
        VStack {
            
            HStack {

                
                
                TextHelvetica(content: "Workout Completed", size: 27)
                    .foregroundColor(Color("WhiteFontOne"))
                Spacer()
                Button {

                
                    
                    viewModel.setWorkoutTime(time: 0)

                    withAnimation(.spring()) {
                        homePageViewModel.setOngoingState(state: false)
                        homePageViewModel.setWorkoutLogModuleStatus(state: false)

                    }

                    homePageViewModel.saveExersiseHistory()
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
                .foregroundColor(Color("WhiteFontOne"))
            
            if let workout = homePageViewModel.history.last {
                VStack(spacing: 0) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading) {
                            TextHelvetica(content: workout.WorkoutName, size: 27)
                                .foregroundColor(Color("WhiteFontOne"))
                            TextHelvetica(content: "Tuesday Feb 12", size: 17)
                                .foregroundColor(Color("GrayFontOne"))
                        }
                        Spacer()

                       

                    }

                    .padding(.all, 12)
                    .background(Color("MainGray"))

                    Rectangle()
                        .frame(height: getScreenBounds().height * 0.006)
                        .foregroundColor(Color("MainGray"))

                    HStack {
                        TextHelvetica(content: "1 h 30 m", size: 16)
                            .foregroundColor(Color("GrayFontOne"))
                        Spacer()
                        TextHelvetica(content: "1000 lbs", size: 16)
                            .foregroundColor(Color("GrayFontOne"))
                        Spacer()
                        TextHelvetica(content: "14 sets", size: 16)
                            .foregroundColor(Color("GrayFontOne"))
                        Spacer()
                        TextHelvetica(content: "5 PRs", size: 16)
                            .foregroundColor(Color("GrayFontOne"))

                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 7)
                    .background(Color("MainGray"))

                    Divider()

                        .frame(height: borderWeight)
                        .overlay(Color("BorderGray"))

                    VStack {
                        HStack {
                            TextHelvetica(content: "Exercise", size: 22)
                                .foregroundColor(Color("WhiteFontOne"))
                            Spacer()
                            TextHelvetica(content: "Best Set", size: 22)
                                .foregroundColor(Color("WhiteFontOne"))
                                .offset(x: -10)
                            Spacer()
                        }
                        .padding(.top, 15)
                        .padding(.bottom, -20)
                        .padding(.leading, 20)


                            VStack(alignment: .leading) {
                                Rectangle()
                                    .frame(height: getScreenBounds().height * 0.006)
                                    .foregroundColor(.clear)

                                ForEach(workout.exercises) {exercise in




                                    HStack {


                                        HStack {
                                            TextHelvetica(content: "\(exercise.setRows.count) x \(exercise.exersiseName)", size: 16)
                                                .foregroundColor(Color("GrayFontOne"))
                                                .lineLimit(1)

                                                .padding(.leading, 10)
                                            Spacer()
                                        }.frame(width: getScreenBounds().width * 0.4)


                                        let rows = exercise.setRows
                                        if let bestRow = calculateBestSet(rows: rows) {
                                            HStack(spacing: 0){
                                                TextHelvetica(content: "\(bestRow.weight.clean) lbs x \(bestRow.reps)", size: 16)

                                                    .foregroundColor(Color("GrayFontOne"))
                                                if bestRow.repMetric != 0 {
                                                    TextHelvetica(content: " @ \(bestRow.repMetric.clean)", size: 16)
                                                        .foregroundColor(Color("GrayFontOne"))
                                                }
                                            }
                                            Spacer()
                                        }



                                    }
                                    Divider()
                                        .frame(height: borderWeight)
                                        .overlay(Color("BorderGray"))

                                }




                            }

                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                            .padding(.vertical, 20)
                        .padding(.horizontal, 15)



                    }

                }

                .background(Color("DBblack"))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))

                .padding(.vertical)
                .padding(.horizontal, 18)
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

