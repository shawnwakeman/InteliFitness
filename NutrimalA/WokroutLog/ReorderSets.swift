//
//  ReorderSets.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/24/23.
//

import SwiftUI

struct ReorderSets: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: WorkoutLogViewModel

    @State var editMode: EditMode = .active
    
    @State private var showingAlert = false
    @State private var itemToDelete: ExersiseLogModule? = nil
    var body: some View {
        // Add a blur effect to the background

           
        ZStack {
            VStack(spacing: 0) {
                    
                   
                    HStack {
                        
                        
                        TextHelvetica(content: "Reorder Exercises", size: 27)
                            .foregroundColor(Color("WhiteFontOne"))
                        
                        Spacer()
                        
                        Button {
                            HapticManager.instance.impact(style: .rigid)
                            withAnimation(.spring()) {
                                viewModel.setPopUpState(state: false, popUpId: "ReorderSets")
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
                        
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    
                    Divider()
                    
                        .frame(height: borderWeight)
                        .overlay(Color("BorderGray"))
            
                    if viewModel.exersiseModules.count > 0 {
                        ZStack {
                            Color.red.edgesIgnoringSafeArea(.all) // Add this line to make the background red

                            NavigationView {
                                ZStack {
                                    
                                    List {
                                        ForEach(viewModel.exersiseModules) { workoutModule in
                                            if workoutModule.isRemoved == false {
                                                Text(workoutModule.exersiseName)
                                            }
                                        }
                                        .onMove(perform: relocate)
          
                                    }
                                    .environment(\.editMode, $editMode)
                                }
                            }
                        }
                        
                    } else {
                        Spacer()
                        TextHelvetica(content: "Exercises Will Apear Here", size: 25)
                            .offset(y: -20)
                        Spacer()
                        
                    }
          
                    
                    
                    
                }
                .frame(width: getScreenBounds().width * 0.95, height: getScreenBounds().height * 0.4)
                .background(Color("DBblack"))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("BorderGray"), lineWidth: borderWeight))
        }

        
       
            
    }
    
    func relocate(from source: IndexSet, to destination: Int) {
        let _ = print(source, destination)
        viewModel.relocate(from: source, to: destination)
    }
    


}



