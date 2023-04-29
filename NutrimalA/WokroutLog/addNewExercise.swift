//
//  addNewExercise.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/28/23.
//

import SwiftUI

struct CategorySelectionMenu: View {
    @Binding var selectedCategory: String
    let categories = ["Category 1", "Category 2", "Category 3"]

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
    let categories = ["Category 5", "Catego2 2", "Catego3ry 3"]

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
                    }
                    
                        
                }.frame(width: 50, height: 30)
                
                
                Spacer()
                TextHelvetica(content: "Exersise Metrics", size: 20)
                    .foregroundColor(Color("WhiteFontOne"))
                
                Spacer()
                Button {
                    withAnimation(.spring()) {
                        showingNew = false
                    }
                    var exercisesToBeSaved = viewModel.exersises
                    print(exercisesToBeSaved)
                    exercisesToBeSaved.append(HomePageModel.Exersise(exerciseName: name, exerciseCategory: [selectedBodyPart], exerciseEquipment: selectedCategory, id: exercisesToBeSaved.count, restTime: 120))
                    print(exercisesToBeSaved)
                    viewModel.saveExercisesToUserDefaults(exercisesToBeSaved)
                }
                label: {
                    TextHelvetica(content: "Save", size: 21)
                        .foregroundColor(Color("LinkBlue"))
                }
               
                
                
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            Divider()
            
                .frame(height: borderWeight)
                .overlay(Color("BorderGray"))
            Rectangle()
                .frame(height: getScreenBounds().height * 0.01)
                .foregroundColor(.clear)
            TextField("Search", text: $name)
                .padding(.vertical, 8)
                .padding(.horizontal, 10)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .padding(.horizontal, 15)

            HStack {
                Text("Category:")
                Spacer()
                CategorySelectionMenu(selectedCategory: $selectedCategory)
            }
            .padding()

            HStack {
                Text("Body Part:")
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
