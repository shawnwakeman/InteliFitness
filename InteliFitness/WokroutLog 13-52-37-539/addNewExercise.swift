//
//  addNewExercise.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/28/23.
//

import SwiftUI

struct CategorySelectionMenu: View {
    @Binding var selectedCategory: String
    let categories = ["Barbell", "Bodyweight", "Dumbell", "Machine", "Other", "Weighted Bodyweight", "Assisted Bodyweight", "Reps Only", "Cardio", "Duration"]

    var body: some View {
        Menu {
            ForEach(categories, id: \.self) { category in
                Button(action: {
                    selectedCategory = category
                }) {
                    Text(category)
                }
            }
        } label: {
            Text(selectedCategory)
                .foregroundColor(.blue)
        }
    }
}



struct BodyPartSelectionMenu: View {
    @Binding var selectedBodyPart: String
    
    let categories = [
    
        "Shoulders",
        "Upper Back",
        "Chest",
        "Biceps",
        "Triceps",
    
        "Lower Back",
        "Abs",
   
        "Glutes",
  
        "Quadriceps",
        "Hamstrings",

        "Other",
        "Full Body",
        "Cardio"
    ]

    var body: some View {
        Menu {
            ForEach(categories, id: \.self) { category in
                Button(action: {
                    selectedBodyPart = category
                }) {
                    Text(category)
                }
            }
        } label: {
            Text(selectedBodyPart)
                .foregroundColor(.blue)
        }
    }
}

struct NameAndCategoryView: View {
    @ObservedObject var viewModel: HomePageViewModel
    @State private var name: String = ""
    @State private var selectedCategory: String = "Not Selected"
    @State private var selectedBodyPart: String = "Not Selected"

    @Binding var showingNew: Bool



    var body: some View {
        VStack {
            Rectangle()
                .frame(height: getScreenBounds().height * 0.00)
                .foregroundColor(.clear)
            HStack {
                Button {
                    HapticManager.instance.impact(style: .rigid)
                    withAnimation(.spring()) {
                        showingNew = false
                    }


               
                    name = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                   
                    
                }
                label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color("BorderGray"), lineWidth: borderWeight))
                            .foregroundColor(Color("MainGray"))
                        Image(systemName: "xmark")
                            .bold()
                            .foregroundColor(Color("LinkBlue"))
                    }
                    
                        
                }.frame(width: 50, height: 30)
                
                
                Spacer()
                TextHelvetica(content: "Add Exercise", size: 20)
                    .foregroundColor(Color("WhiteFontOne"))
                
                Spacer()
                Button {
                    if name.count > 0 && selectedCategory != "Not Selected" && selectedBodyPart != "Not Selected" {
                        withAnimation(.spring()) {
                            showingNew = false
                        }
                        var exercisesToBeSaved = viewModel.exersises
               
                        if selectedCategory == "Reps Only" {
                            exercisesToBeSaved.append(HomePageModel.Exersise(exerciseName: name, exerciseCategory: [selectedBodyPart], exerciseEquipment: selectedCategory, id: exercisesToBeSaved.count, restTime: 120, instructions: [], moduleType: WorkoutLogModel.moduleType.reps))
                        }
                        else if selectedCategory == "Bodyweight" {
                            exercisesToBeSaved.append(HomePageModel.Exersise(exerciseName: name, exerciseCategory: [selectedBodyPart], exerciseEquipment: selectedCategory, id: exercisesToBeSaved.count, restTime: 120, instructions: [], moduleType: WorkoutLogModel.moduleType.reps))
                        }
                        else if selectedCategory == "Weighted Bodyweight" {
                            exercisesToBeSaved.append(HomePageModel.Exersise(exerciseName: name, exerciseCategory: [selectedBodyPart], exerciseEquipment: selectedCategory, id: exercisesToBeSaved.count, restTime: 120, instructions: [], moduleType: WorkoutLogModel.moduleType.weightedReps))
                        }
                        else if selectedCategory == "Assisted Bodyweight" {
                            exercisesToBeSaved.append(HomePageModel.Exersise(exerciseName: name, exerciseCategory: [selectedBodyPart], exerciseEquipment: selectedCategory, id: exercisesToBeSaved.count, restTime: 120, instructions: [], moduleType: WorkoutLogModel.moduleType.assistedReps))
                        }
                        else if selectedCategory == "Duration" {
                            exercisesToBeSaved.append(HomePageModel.Exersise(exerciseName: name, exerciseCategory: [selectedBodyPart], exerciseEquipment: selectedCategory, id: exercisesToBeSaved.count, restTime: 120, instructions: [], moduleType: WorkoutLogModel.moduleType.duration))
                        }
                        else if selectedCategory == "Cardio" {
                            exercisesToBeSaved.append(HomePageModel.Exersise(exerciseName: name, exerciseCategory: [selectedBodyPart], exerciseEquipment: selectedCategory, id: exercisesToBeSaved.count, restTime: 120, instructions: [], moduleType: WorkoutLogModel.moduleType.cardio))
                        }
                        else {
                            exercisesToBeSaved.append(HomePageModel.Exersise(exerciseName: name, exerciseCategory: [selectedBodyPart], exerciseEquipment: selectedCategory, id: exercisesToBeSaved.count, restTime: 120, instructions: [], moduleType: WorkoutLogModel.moduleType.weightReps))
                        }
                        
                        viewModel.saveExercisesToUserDefaults(exercisesToBeSaved)
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        name = ""
                    }
            
                    
                    
                }
                label: {
                    TextHelvetica(content: "Save", size: 18)
                        .foregroundColor(Color("LinkBlue"))
                }
               
                
                
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
           
            Rectangle()
                .frame(height: getScreenBounds().height * 0.01)
                .foregroundColor(.clear)
            TextField("Exercise Name", text: $name)
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal, 15)

            HStack {
       
                TextHelvetica(content: "Category", size: 20)
                    .foregroundColor(Color("WhiteFontOne"))
                Spacer()
                CategorySelectionMenu(selectedCategory: $selectedCategory)
            }
            .padding()

            HStack {
            
                TextHelvetica(content: "Muscle Group:", size: 20)
                    .foregroundColor(Color("WhiteFontOne"))
                Spacer()
                BodyPartSelectionMenu(selectedBodyPart: $selectedBodyPart)
            }
            .padding()

            Spacer()
        }
        .frame(width: getScreenBounds().width * 0.95, height: getScreenBounds().height * 0.3)
        .background(Color("DBblack"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("BorderGray"), lineWidth: borderWeight))


    }
}
