//
//  MyExercisesPage.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/20/23.
//

import Foundation
//
//  AddExersisesPopUp.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/13/23.
//

import SwiftUI



struct MyExercisesPage: View {
    @ObservedObject var viewModel: HomePageViewModel

    @State private var searchText = ""
    @State private var selectedType: String? = nil
    @State private var selectedColor: String? = nil
    
    @State private var showingNew: Bool = false
    @State private var displayingExerciseView: Bool = false
    init(viewModel: HomePageViewModel, searchText: String = "", selectedType: String? = nil, selectedColor: String? = nil) {
        
        
               
               
               
       UINavigationBar.appearance().barTintColor = .clear
       UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
       UINavigationBar.appearance().barTintColor = UIColor(Color("MainGray"))
        
          
       // Set font color for NavigationBarTitle with displayMode = .inline
       UINavigationBar.appearance().titleTextAttributes = [
           .font : UIFont(name: "SpaceGrotesk-Bold", size: 20)!,
           .foregroundColor: UIColor(Color("WhiteFontOne"))
       ]

       // Set font color for NavigationBarTitle with Large Font
       UINavigationBar.appearance().largeTitleTextAttributes = [
           .font : UIFont(name: "SpaceGrotesk-Bold", size: 40)!,
           .foregroundColor: UIColor(Color("WhiteFontOne")) // Replace UIColor.red with your desired color
       ]
        
        self.viewModel = viewModel
        _searchText = State(initialValue: searchText)
        _selectedType = State(initialValue: selectedType)
        _selectedColor = State(initialValue: selectedColor)
    }

    
    

    
    private var filteredExercises: [HomePageModel.Exersise] {
        var filtered = viewModel.exersises

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
            Set(viewModel.exersises.map { $0[keyPath: keyPath] }).sorted { "\($0)" < "\($1)" }
        }
    
  
    
    var body: some View {
        ZStack {
            NavigationStack{
                VStack(spacing: 0) {
                    Text("")
                    
                    
                        .navigationBarTitle(Text("Exercises").font(.subheadline), displayMode: .inline)
                        .navigationBarHidden(false)
                        .navigationBarItems(
                            
                            trailing: Button {
                                withAnimation(.spring()) {
                                    showingNew = true
                                }
                            } label: {
                                Text("new")
                            }
                        )
                    
                    TextField("", text: $searchText, prompt: Text("Search").foregroundColor(Color("GrayFontOne")))  .font(.custom("SpaceGrotesk-Medium", size: 18))
                    
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .background(Color("DBblack"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                        .padding(.horizontal, 15)
                        .onTapGesture {
                            selectedType = nil
                            selectedColor = nil
                            
                        }
                    
                    
                    Rectangle()
                        .frame(height: getScreenBounds().height * 0.01)
                        .foregroundColor(.clear)
                    HStack {
                        Menu {
                            // Add a default option to clear the selection
                            Button(action: {
                                selectedType = nil
                                searchText = ""
                            }) {
                                
                                Text("Any Equipment")
                                    
                               
                                
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
                      
                            TextHelvetica(content: selectedType ?? "Any Equipment", size: 18)
                                .font(.largeTitle)
                                .frame(width: getScreenBounds().width / 2.165)
                                
                       
                           
                        }
                        .frame(height: getScreenBounds().height * 0.04)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("BorderGray"), lineWidth: borderWeight))
                        .background(Color("MainGray"))
                
                        Menu {
                            // Add a default option to clear the selection
                            Button(action: {
                                selectedColor = nil
                                searchText = ""
                            }) {
                               
                                Text("Any Muscle Group")
                            }
                            
                            // Add a separator
                            Divider()
                            Picker(selection: $selectedColor) {
                                ForEach(uniqueValues(for: \.exerciseCategory[0]), id: \.self) { category in
                                     
                                        Text(category).tag(String?.some(category))
                                    
                                   
                                }
                            } label: {}
                            
                        } label: {
                            
                                TextHelvetica(content: selectedColor ?? "Any Muscle Group", size: 18)
                                    .font(.largeTitle)
                                .frame(width: getScreenBounds().width / 2.165)
                                
                           
                        }
                       
                        .frame(height: getScreenBounds().height * 0.04)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("BorderGray"), lineWidth: borderWeight))
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
     
                            
                              TextHelvetica(content: "No exercises found", size: 25)
                                  .foregroundColor(Color("WhiteFontOne"))
                                  .padding(.top, 40)
                             
                                 
                               
                              TextHelvetica(content: "Add a new exercise", size: 20)
                                  .foregroundColor(Color("GrayFontOne"))
                                  .padding(.top, 3)
                            
                            
                            Button {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                
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
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
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
                                                    viewModel.setCurrentExercise(exercise: exercise)
                                                    withAnimation(.spring()) {
                                                        displayingExerciseView = true
                                                    }
                                                    
                                                    
                                                   
                                                }, label: {
                                                    Rectangle()
                                                        .opacity(0.0001)
                                                        .foregroundColor(.black)
                                                }).buttonStyle(.plain)
                                                HStack {
                                                    VStack(alignment: .leading) {
                                                       
                                                        TextHelvetica(content: exercise.exerciseName, size: 18)
                                                            .foregroundColor(Color("WhiteFontOne"))
                                                        TextHelvetica(content: exercise.exerciseCategory[0], size: 18)
                                                            .foregroundColor(Color("GrayFontOne"))
                                                        
                                                       
                                                        
                                                    }
                                                    Spacer()
                                                    
                                                   
                                                    
                                                    
                                                }
                                               
                                         
                                                
                                            }
                                            .listRowBackground(Color("MainGray"))
                                            .listStyle(GroupedListStyle())
                                            .onTapGesture {
                                                print("asd123456")
                                            }
                                        }
                                    }
                                   
                                    
                                    
                                }
                                
                            } else {
                                ForEach(filteredExercises, id: \.id) { exercise in
                                    ZStack {
                                        Button(action: {
                                                            // action to perform when the button is tapped
                                            viewModel.setCurrentExercise(exercise: exercise)
                                            withAnimation(.spring()) {
                                                displayingExerciseView = true
                                            }
                                            
                                            
                                           
                                        }, label: {
                                            Rectangle()
                                                .opacity(0.0001)
                                                .foregroundColor(.black)
                                        }).buttonStyle(.plain)
                                        HStack {
                                            VStack(alignment: .leading) {
                                               
                                                TextHelvetica(content: exercise.exerciseName, size: 18)
                                                    .foregroundColor(Color("WhiteFontOne"))
                                                TextHelvetica(content: exercise.exerciseCategory[0], size: 18)
                                                    .foregroundColor(Color("GrayFontOne"))
                                                
                                               
                                                
                                            }
                                            Spacer()
                                            
                                           
                                            
                                            
                                        }
                                       
                                 
                                        
                                    }
                                    .listRowBackground(Color("MainGray"))
                                    .listStyle(GroupedListStyle())
                                    .onTapGesture {
                                        print("asd123456")
                                    }
                                }
                                
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .background(Color("DBblack").edgesIgnoringSafeArea(.all))
                        
                        .environment(\.defaultMinListRowHeight, 80)
                        
                    }
                    
                    
                    
                    
                    
                    
                    
                }

                
                .background(Color("MainGray"))
            }
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            
            let showing = showingNew || displayingExerciseView
            Rectangle()
                .edgesIgnoringSafeArea(.all)
                .foregroundColor(.black)
                .opacity(showing ? 0.4 : 0)
                .onTapGesture {
                    withAnimation(.spring()) {
                        showingNew = false
                        displayingExerciseView = false
                        
                    }
                }
            NameAndCategoryView(viewModel: viewModel, showingNew: $showingNew)
                .position(x: getScreenBounds().width/2, y: showingNew ? getScreenBounds().height * 0.35 : getScreenBounds().height * 1.3)
           
            ExercisePage(viewModel: viewModel, showingExrcisePage: $displayingExerciseView)
                .position(x: getScreenBounds().width/2, y: displayingExerciseView ? getScreenBounds().height * 0.4 : getScreenBounds().height * 1.3)
            
        }
        
    }
    struct ExerciseInfo: View {
        @Environment(\.presentationMode) var presentationMode
        @ObservedObject var viewModel: HomePageViewModel
        @Binding var displayingExerciseView: Bool

        var body: some View {
            // Add a blur effect to the background
            
            VStack {
                
                 
                HStack {

                    Button {
                        withAnimation(.spring()) {
                            displayingExerciseView = false
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
                    if let exercise = viewModel.homePageModel.currentExervice {
                        TextHelvetica(content: exercise.exerciseName, size: 20)
                            .foregroundColor(Color("WhiteFontOne"))
                    }
                    
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.spring()) {
                            displayingExerciseView = false
                        }
                        
                    }
                  
                    label: {
                        TextHelvetica(content: "Save", size: 18)
                            .foregroundColor(Color("LinkBlue"))
                            
                    }.frame(width: 50, height: 30)
                    
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                
                Divider()
                
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                
                VStack {
                    
                   
                    HStack {
                        TextHelvetica(content: "Body Part", size: 12)
                        Menu {
                            
                        }
                    label: {
                        
                    }
                        
                    }
                    HStack {
                        TextHelvetica(content: "Category", size: 12)
                    }

                }
                
              
               
                
            }
            .frame(maxWidth: getScreenBounds().width * 0.95)
            .background(Color("DBblack"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("BorderGray"), lineWidth: borderWeight))



                
        }
        
        struct DisplayRow: View {
            var metric: String
            var value: String
            var body: some View {
                HStack{
                   
                    TextHelvetica(content: metric, size: 18)
                        .foregroundColor(Color("WhiteFontOne"))
                    
                    Spacer()
                    
                    TextHelvetica(content: value, size: 18)
                        .foregroundColor(Color("WhiteFontOne"))
                }
                .padding(.horizontal)
                .frame(maxHeight: 22)
                
                Divider()
                
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
            }
        }
        


    }



}


struct DisplayOnOpenMenuViewModifier: ViewModifier {
    
    let isOpened: Bool
    let offset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .shadow(color: .black.opacity(isOpened ? 0.1 : 0.0), radius: 10, x: 0, y: 5)
            .offset(y: isOpened ? offset : 0)
            .opacity(isOpened ? 100 : 0)
            .animation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0.5), value: isOpened)
    }
}
 


extension View {
    func displayOnMenuOpen(_ isOpened: Bool, offset: CGFloat) -> some View {
        modifier(DisplayOnOpenMenuViewModifier(isOpened: isOpened, offset: offset))
    }
}

