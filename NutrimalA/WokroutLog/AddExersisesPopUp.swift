//
//  AddExersisesPopUp.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/13/23.
//

import SwiftUI



struct AddExersisesPopUp: View {
    @ObservedObject var viewModel: WorkoutLogViewModel
    @ObservedObject var homePageViewModel: HomePageViewModel
    @State private var search: String = ""
    @State private var searchText = ""
    @State private var selectedType: String? = nil
    @State private var selectedColor: String? = nil
    @State private var showingNew: Bool = false

    private var filteredExercises: [HomePageModel.Exersise] {
        var filtered = homePageViewModel.exersises

            if !searchText.isEmpty {
                filtered = filtered.filter { $0.exerciseName.localizedCaseInsensitiveContains(searchText) }
            }

            if let type = selectedType {
                filtered = filtered.filter { $0.exerciseEquipment == type }
            }

            if let color = selectedColor {
                filtered = filtered.filter { $0.exerciseCategory.contains(color) }
            }

            return filtered
        }
    
    private var sectionedExercises: [String: [HomePageModel.Exersise]] {
            Dictionary(grouping: filteredExercises) { $0.exerciseName.prefix(1).uppercased() }
        }

        private func uniqueValues<T: Hashable>(for keyPath: KeyPath<HomePageModel.Exersise, T>) -> [T] {
            Set(homePageViewModel.exersises.map { $0[keyPath: keyPath] }).sorted { "\($0)" < "\($1)" }
        }
    
    var body: some View {
        
        ZStack {
            VStack(spacing: 0) {
              
                HStack {
                                    
                    Button {
                        
                        HapticManager.instance.impact(style: .rigid)

                        withAnimation(.spring()) {
                            viewModel.setPopUpState(state: false, popUpId: "ExersisesPopUp")
                        }
                        homePageViewModel.clearToExersiseQueue()
                    }
                    label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color("BorderGray"), lineWidth: borderWeight))
                                .foregroundColor(Color("MainGray"))
                            
                            Image(systemName: "xmark")
                                .resizable()
                                .bold()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 15, height: 15)
                                .foregroundColor(Color("LinkBlue"))
                            
                        }
                        
                    }
                    .frame(width: 60, height: 40)
                    
              
                    Spacer()
                    if homePageViewModel.exersiseQueue.count > 0 {
                        TextHelvetica(content: String(homePageViewModel.exersiseQueue.count), size: 25)
                            .foregroundColor(Color("WhiteFontOne"))
                    }
         
                    Spacer()
                    
                    
                    
                    Button {
                        HapticManager.instance.impact(style: .rigid)

                        withAnimation(.spring()) {
                            viewModel.setPopUpState(state: false, popUpId: "ExersisesPopUp")
                        }
                       
                        viewModel.addExercisesFromQueue(exercises: homePageViewModel.exersiseQueue)
                        homePageViewModel.clearToExersiseQueue()
        


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
                        
                    }
                    .frame(width: 60, height: 40)
                                
                                            
                                    }
                .padding(16)
                HStack {
                    TextField("", text: $searchText, prompt: Text("Search").foregroundColor(Color("GrayFontOne")))  .font(.custom("SpaceGrotesk-Medium", size: 18))
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .background(Color("DBblack"))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                    
                    Button {
                        withAnimation(.spring()) {
                            showingNew = true
                        }
                        
                    }
                    label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 4)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(Color("BorderGray"), lineWidth: borderWeight))
                                .foregroundColor(Color("MainGray"))
                            
                            Image(systemName: "plus")
                                .resizable()
                                .bold()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 17, height: 17)
                                .foregroundColor(Color("LinkBlue"))

                            
                        }
                        
                    }.frame(width: 40, height: 36)
                    
                }.padding(.horizontal, 15)
                    
                
                
                Rectangle()
                    .frame(height: getScreenBounds().height * 0.01)
                    .foregroundColor(.clear)
                HStack {
                    Menu {
                        // Add a default option to clear the selection
                        Button(action: {
                            selectedType = nil
                        }) {
                            Text("Any Body Part")
                        }
                        
                        // Add a separator
                        Divider()
                        
                        Picker(selection: $selectedType) {
                            ForEach(uniqueValues(for: \.exerciseEquipment), id: \.self) { equipment in
                                if !equipment.isEmpty {
                                    Text(equipment).tag(String?.some(equipment))
                                }
                                
                            }
                      
                        } label: {}
                    } label: {
                        TextHelvetica(content: selectedType ?? "Any Body Part", size: 18)
                            .font(.largeTitle)
                            .frame(width: getScreenBounds().width / 2.165)
                    }
                    .frame(height: getScreenBounds().height * 0.04)
                    .background(Color("MainGray"))
            
                    Menu {
                        // Add a default option to clear the selection
                        Button(action: {
                            selectedColor = nil
                        }) {
                            Text("Any Category")
                        }
                        
                        // Add a separator
                        Divider()
                        Picker(selection: $selectedColor) {
                            ForEach(uniqueValues(for: \.exerciseCategory[0]), id: \.self) { category in
                                 
                                    Text(category).tag(String?.some(category))
                                
                               
                            }
                        } label: {}
                        
                    } label: {
                        TextHelvetica(content: selectedColor ?? "Any Category", size: 18)
                            .font(.largeTitle)
                            .frame(width: getScreenBounds().width / 2.165)
                    }
                    .frame(height: getScreenBounds().height * 0.04)
                    .background(Color("MainGray"))
                }
                
                
                
                Rectangle()
                    .frame(height: getScreenBounds().height * 0.02)
                    .foregroundColor(.clear)
                
                
               
                Divider()
                    
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                if filteredExercises.isEmpty {
                    VStack {
                        Text("No exercises found")
                            .font(.title)
                            .padding(.top, 40)
                        
                        Text("Please add an exercise")
                            .font(.subheadline)
                            .padding(.top, 10)
                        
                        Spacer()
                    }
                    .frame(width: 1000)
                    .background(Color("DBblack"))
                    
                } else {
                    List {
                        if searchText.isEmpty {
                            
                        
                            ForEach(sectionedExercises.keys.sorted(), id: \.self) { key in
                                    Section(header: TextHelvetica(content: key, size: 22)) {
                                        ForEach(sectionedExercises[key]!, id: \.id) { exercise in
                                            ZStack {
                                                Button(action: {
                                                                    // action to perform when the button is tapped
                                                if homePageViewModel.exersises[exercise.id].selected == false {
                                                    homePageViewModel.addToExersiseQueue(ExersiseID: exercise.id)
                                                   } else {
                                                       homePageViewModel.removeExersiseFromQueue(ExersiseID: exercise.id)
                                                   }
                                                    withAnimation(.spring()) {
                                                        homePageViewModel.setSelectionState(ExersiseID: exercise.id)
                                                    }
                                                   
                                                }, label: {
                                                    Rectangle()
                                                        .opacity(0.0001)
                                                        .foregroundColor(.black)
                                                }).buttonStyle(.plain)
                                                HStack {
                                                    VStack(alignment: .leading) {
                                                        if homePageViewModel.exersises[exercise.id].selected == false {
                                                            TextHelvetica(content: exercise.exerciseName, size: 18)
                                                                .foregroundColor(Color("WhiteFontOne"))
                                                            TextHelvetica(content: exercise.exerciseCategory[0], size: 18)
                                                                .foregroundColor(Color("GrayFontOne"))
                                                        }
                                                        else {
                                                            TextHelvetica(content: exercise.exerciseName, size: 18)
                                                                .foregroundColor(Color("LinkBlue"))
                                                            TextHelvetica(content: exercise.exerciseCategory[0], size: 18)
                                                                .foregroundColor(Color("GrayFontOne"))
                                                        }
                                                        
                                                    }
                                                    Spacer()
                                                    
                                                    Button {}
                                                   label: {
                                                       ZStack {
                                                           if homePageViewModel.exersises[exercise.id].selected == false {
                                                               
                                                               TextHelvetica(content: "?", size: 23)
                                                                   .bold()
                                                                   .foregroundColor(Color("LinkBlue"))
                                                           } else {
                                                               
                                                                 Image("checkMark")
                                                                     .resizable()
                                                                     .aspectRatio(contentMode: .fit)
                                                                     .frame(width: 17, height: 17)
                                                                     
                                                           }
                                                         
                                                         
                                                           
                                                       }
                                                   }
                                                   .frame(width: getScreenBounds().width * 0.12, height: getScreenBounds().height * 0.04)
                                                    
                                                    
                                                }
                                               
                                         
                                                
                                            }
                                            
                                          
                                   
                                            .listRowBackground(Color("MainGray"))
                                            .listStyle(GroupedListStyle())
                                          
                                        }
                                    }
                                }
                           
                        } else {
                            ForEach(filteredExercises, id: \.id) { exercise in
                                VStack(alignment: .leading) {
                                    TextHelvetica(content: exercise.exerciseName, size: 18)
                                    .foregroundColor(Color("WhiteFontOne"))
                                    TextHelvetica(content: exercise.exerciseCategory[0], size: 18)
                                        .foregroundColor(Color("GrayFontOne"))
                                }
                            }
                            .listRowBackground(Color("MainGray"))
                            .listStyle(GroupedListStyle())
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .background(Color("DBblack").edgesIgnoringSafeArea(.all))
   
                    .environment(\.defaultMinListRowHeight, 80)
                   
                }
                 
               
               
                                                                     
                         
                

            }
  
            .background(Color("MainGray"))
            .frame(height: getScreenBounds().height * 0.86)
            .background(Color("DBblack"))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
            
            NameAndCategoryView(viewModel: homePageViewModel, showingNew: $showingNew)
                .position(x: getScreenBounds().width/2, y: showingNew ? getScreenBounds().height * 0.5 : getScreenBounds().height * 1.3)
        }
           
            
//            HStack {
//                ExersiseBodyPartButton()
//                ExersiseBodyPartButton()
//            }
//            .frame(width: getScreenBounds().width * 0.94, height: getScreenBounds().height * 0.045)
     
        
       

       
    }
}



 

