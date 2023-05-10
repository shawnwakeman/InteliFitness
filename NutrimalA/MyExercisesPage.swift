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

    @Binding var isNavigationBarHidden: Bool

    var body: some View {
        GeometryReader { proxy in
            
            let topEdge = proxy.safeAreaInsets.top
            MyExercisesPageMain(viewModel: viewModel, topEdge: topEdge)
                .navigationBarTitle("back")
                .navigationBarHidden(self.isNavigationBarHidden)
                .onAppear {
                    self.isNavigationBarHidden = true
                }
                .ignoresSafeArea(.all, edges: .top)
        }
    }
}


struct MyExercisesPageMain: View {
    @ObservedObject var viewModel: HomePageViewModel
    
    @State private var searchText = ""
    @State private var selectedType: String? = nil
    @State private var selectedColor: String? = nil
    
    @State private var showingNew: Bool = false
    @State private var displayingExerciseView: Bool = false
    
    var topEdge: CGFloat
    let maxHeight = UIScreen.main.bounds.height / 3.5
    @Environment(\.presentationMode) var presentationMode
    @State var offset: CGFloat = 0
    
    
    
    
    
    
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
    

    
    
    func exerciseRow(viewModel: HomePageViewModel, exercise: HomePageModel.Exersise, displayingExerciseView: Binding<Bool>) -> some View {
        ZStack {
            Button(action: {
                HapticManager.instance.impact(style: .rigid)
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                viewModel.setCurrentExercise(exercise: exercise)
                withAnimation(.spring()) {
                    displayingExerciseView.wrappedValue = true
                }
            }, label: {
                Rectangle()
                    .opacity(0.0001)
                    .foregroundColor(.black)
            })
            .buttonStyle(.plain)

            HStack {
                VStack(alignment: .leading) {
                    TextHelvetica(content: "\(exercise.exerciseName) (\(exercise.exerciseEquipment))", size: 18)
                        .foregroundColor(Color("WhiteFontOne"))
                    TextHelvetica(content: exercise.exerciseCategory[0], size: 18)
                        .foregroundColor(Color("GrayFontOne"))
                }
                Spacer()
            }
            .padding()
            .padding(.leading, 15)
            .frame(minWidth: 0, maxWidth: .infinity)
        }
        .background(Color("MainGray"))
    }


    func getOpacity2() -> CGFloat {
        let progress = -offset / 70
        
        let opacity = 1 - progress
        
        return offset < 0 ? opacity : 1
    }





    
    var body: some View {

        
        ZStack {
            
           
            GeometryReader { g in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {

                      
                        GeometryReader { proxy in
                            ZStack {
                            Rectangle()
                                .frame(height: getScreenBounds().height * 0.3)
                                .position(x: getScreenBounds().width / 2, y: getScreenBounds().height * 0)
                                .foregroundColor(Color("MainGray"))
                                VStack(alignment: .leading, spacing: 15) {
                                    HStack {
                                        TextHelvetica(content: "My Exercises", size: 40)
                                            .foregroundColor(Color("WhiteFontOne"))
                                            .bold()
                                            .offset(y: 30)
                                  
                                        
                                        Spacer()
                                        
                                        Button {
                                            withAnimation(.spring()) {
                                                showingNew = true
                                            }
                                        } label: {
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
                                            .onTapGesture {
                                                HapticManager.instance.impact(style: .rigid)
                                            }
                                            .frame(width: 35, height: 35)
                                            .opacity(getOpacity2())
                                            .offset(y: 30)
                                        }
                                    }
                                    .opacity(getOpacity2())
                                    
                                    VStack {
                                        
                                        
                                        TextField("", text: $searchText, prompt: Text("Search").foregroundColor(Color("GrayFontOne")))
                                            .frame(width: getScreenBounds().width *  0.875)
                                            .font(.custom("SpaceGrotesk-Medium", size: 18))
                                        
                                            .padding(.vertical, 8)
                                            .padding(.horizontal, 10)
                                            .background(Color("DBblack"))
                                            .cornerRadius(10)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 10)
                                                    .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                                         
                                            .onTapGesture {
                                                selectedType = nil
                                                selectedColor = nil
                                                HapticManager.instance.impact(style: .rigid)
                                                
                                            }
                                            .offset(y: 20)
                                       
                                   
                                        
                                        
                                        
                                        HStack {
                                            Menu {
                                                // Add a default option to clear the selection
                                                Button(action: {
                                                    selectedType = nil
                                                    searchText = ""
                                                    HapticManager.instance.impact(style: .rigid)
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
                                                    .frame(width: getScreenBounds().width / 2.22)
                                                
                                                
                                                
                                            }
                                            .frame(height: getScreenBounds().height * 0.04)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(
                                                        selectedType != nil ? Color("LinkBlue"): Color("BorderGray"),
                                                        lineWidth: borderWeight
                                                    )
                                            )
                                            .background(Color("MainGray"))
                                            
                                            Menu {
                                                // Add a default option to clear the selection
                                                Button(action: {
                                                    selectedColor = nil
                                                    searchText = ""
                                                    HapticManager.instance.impact(style: .rigid)
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
                                                    .frame(width: getScreenBounds().width / 2.22)
                                                
                                                
                                            }
                                            
                                            .frame(height: getScreenBounds().height * 0.04)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 8)
                                                    .stroke(
                                                        selectedColor != nil ? Color("LinkBlue") : Color("BorderGray"),
                                                        lineWidth: borderWeight
                                                    )
                                            )
                                            .background(Color("MainGray"))
                                        }
                                            .offset(y: 20)
                                       
                                        
                                    }
                                    .opacity(getOpacity2())
                                    
                                }
                                .padding()
                                .padding(.bottom)
                       
                                    
                                        
                                
                                        
                                        
                                        
                                
                                        

                                
                                 
                                
                           
                     
                          
                        
                                
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: getHeaderHeight() - 20, alignment: .bottom)
                            .background(
                                Color("MainGray")
                                    
                                    .clipShape(CustomCorner(corners: [.bottomLeft, .bottomRight], radius: getCornerRadius()))
                                    .shadow(color: Color.black.opacity(topBarTitleOpacity() * 0.7), radius: 10, x: 0, y: 0)
                            )
                            
                            
                            .overlay(
                                GeometryReader { geoProxy in
                                    CustomCornerBorder(corners: [.bottomLeft, .bottomRight], radius: getCornerRadius(), lineWidth: borderWeight)
                                        .stroke(Color("BorderGray"), lineWidth: borderWeight)
                                        .clipShape(CustomCornerBorder(corners: [.bottomLeft, .bottomRight], radius: getCornerRadius(), lineWidth: 0))
                                        .frame(height: geoProxy.size.height + 100) // Increase the height by adding an arbitrary value, e.g., 10
                                        .offset(y: -100)
                                        .opacity((-1 * topBarTitleOpacityForBorder()))// Move the overlay up by the same value
                                }
                            )
                            .frame(maxWidth: .infinity)
                            .frame(height: getHeaderHeight() + 75, alignment: .bottom)
                           
                           
                           
                                   
                                    
                                    
                                    
                            
                                    

                                
                            
                        }
                        .frame(height: maxHeight)
                        .offset(y: -offset)
                        .zIndex(1)
                        

                        
                        
                        
                        
                        
                        
                      
                            
                        
                     
                        VStack(alignment: .leading) {
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
                                if searchText.isEmpty {
                                    ForEach(sectionedExercises.keys.sorted(), id: \.self) { key in
                                        TextHelvetica(content: key, size: 22)
                                            .foregroundColor(Color("WhiteFontOne"))
                                            .padding(.leading)

                                        VStack(spacing: 0) {
                                            ForEach(Array(sectionedExercises[key]!.indices), id: \.self) { index in
                                                let exercise = sectionedExercises[key]![index]
                                                exerciseRow(viewModel: viewModel, exercise: exercise, displayingExerciseView: $displayingExerciseView)

                                                if index < sectionedExercises[key]!.count - 1 {
                                                    Divider()
                                                        .padding(.leading, 30)
                                                }
                                            }
                                        }
                                        .background(Color("MainGray"))
                                        .cornerRadius(10)
                                        .padding([.horizontal, .bottom])
                                    }
                                } else {
                                    TextHelvetica(content: "Search Results", size: 16)
                                        .foregroundColor(Color("WhiteFontOne"))
                                        .padding(.leading)

                                    VStack {
                                        ForEach(Array(filteredExercises.indices), id: \.self) { index in
                                            let exercise = filteredExercises[index]
                                            exerciseRow(viewModel: viewModel, exercise: exercise, displayingExerciseView: $displayingExerciseView)

                                            if index < filteredExercises.count - 1 {
                                                Divider()
                                                    .padding(.leading, 30)
                                            }
                                        }
                                    }
                                    .listStyle(GroupedListStyle())
                                    .background(Color("MainGray"))
                                    .cornerRadius(10)
                                    .padding([.horizontal, .bottom])
                               
                                }
                            }
                          
                        }
                        .padding(.top, 100)
                        .padding(.bottom)
             
                    
                        .zIndex(0)
                      
                        
                        
                        
                        
                        
                        
                        
                    }
              
                    .modifier(OffsetModifier(modifierID: "SCROLL3", offset: $offset))
                }
                .background(Color("DBblack"))
                .coordinateSpace(name: "SCROLL3")
            }

            VStack {
                HStack() {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        HapticManager.instance.impact(style: .rigid)
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.body.bold())
                                .foregroundColor(Color("LinkBlue"))
                            TextHelvetica(content: "back", size: 17)
                                .foregroundColor(Color("LinkBlue"))
                            Spacer()
                        }
                        .frame(width: 80)
                    }

                    Spacer() // This spacer will push the text and buttons apart

                    TextHelvetica(content: "My Exercises", size: 20)
                        .foregroundColor(Color("WhiteFontOne"))
                        .bold()
                        .opacity(topBarTitleOpacity())

                    Spacer() // This spacer will push the text and buttons apart

                    Button {
                        withAnimation(.spring()) {
                            showingNew = true
                        }
                    } label: {
                        HStack {
                            Spacer()
                            Image(systemName: "plus")
                                .font(.body.bold())
                                .imageScale(.large)
                                .foregroundColor(Color("LinkBlue"))
                            
                        }
                        .opacity(topBarTitleOpacity())
                        .frame(width: 80)
                    }
                }
            
                .frame(height: 60)
                .padding(.top, topEdge)
                .padding(.horizontal)
                Spacer()
                
                VStack {
                    
                    
                    TextField("", text: $searchText, prompt: Text("Search").foregroundColor(Color("GrayFontOne")))
                        .frame(width: getScreenBounds().width *  0.875)
                        .font(.custom("SpaceGrotesk-Medium", size: 18))
                    
                        .padding(.vertical, 8)
                        .padding(.horizontal, 10)
                        .background(Color("DBblack"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                     
                        .onTapGesture {
                            selectedType = nil
                            selectedColor = nil
                            
                        }
                        .offset(y: 20)
                   
               
                    
                    
                    
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
                                .frame(width: getScreenBounds().width / 2.22)
                            
                            
                            
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
                                .frame(width: getScreenBounds().width / 2.22)
                            
                            
                        }
                        
                        .frame(height: getScreenBounds().height * 0.04)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("BorderGray"), lineWidth: borderWeight))
                        .background(Color("MainGray"))
                    }
                        .offset(y: 20)
                   
                    
                }
                .position(x: getScreenBounds().width / 2, y: getScreenBounds().height * 0.015)
                .opacity(topBarTitleOpacity())
            }
                ZStack {
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
                        .position(x: getScreenBounds().width/2, y: showingNew ? getScreenBounds().height * 0.45 : getScreenBounds().height * 1.3)
                   
                    ExercisePage(viewModel: viewModel, showingExrcisePage: $displayingExerciseView)
                        .position(x: getScreenBounds().width/2, y: displayingExerciseView ? getScreenBounds().height * 0.5 : getScreenBounds().height * 1.5)
                
           
            }
            
        }
        .onChange(of: selectedType) { newVaule in
            searchText = ""
        }
        .onChange(of: selectedColor) { newVaule in
            searchText = ""
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
      
        
    }
    
    func getHeaderHeight() -> CGFloat {
        let topHeight = maxHeight + offset
        
        return topHeight > (80 + topEdge) ? topHeight : (80 + topEdge)
    }
    
    func getCornerRadius() -> CGFloat {
        let progess = -offset / (maxHeight - (80 + topEdge))
        let value = 1 - progess
        let radius = value * 25
        
        return offset < 5 ? radius : 25
    }
    
    func topBarTitleOpacity() -> CGFloat {
        
        let progress = -(offset + 60) / (maxHeight - (80 + topEdge))
        

        
        return progress
    }
    
    func topBarTitleOpacityForBorder() -> CGFloat {
        
        let progress = -(offset + 150) / (maxHeight - (80 + topEdge))
        

        
        return progress
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
