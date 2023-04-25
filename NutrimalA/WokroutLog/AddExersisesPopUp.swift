//
//  AddExersisesPopUp.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/13/23.
//

import SwiftUI



struct AddExersisesPopUp: View {
    @ObservedObject var viewModel: WorkoutLogViewModel
    @State private var search: String = ""


    
    var body: some View {
        
        ZStack {
   
            VStack(spacing: 0) {
                HStack {
                    
                    Button {
                        
                        HapticManager.instance.impact(style: .rigid)

                        withAnimation(.spring()) {
                            viewModel.setPopUpState(state: false, popUpId: "ExersisesPopUp")
                        }
                        viewModel.clearToExersiseQueue()
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
                    if viewModel.exersiseQueue.count > 0 {
                        TextHelvetica(content: String(viewModel.exersiseQueue.count), size: 25)
                            .foregroundColor(Color("WhiteFontOne"))
                    }
         
                    Spacer()
                    
                    
                    
                    Button {
                        HapticManager.instance.impact(style: .rigid)

                        withAnimation(.spring()) {
                            viewModel.setPopUpState(state: false, popUpId: "ExersisesPopUp")
                        }
                       
                        viewModel.addExercisesFromQueue()
        


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
                .padding(.horizontal)
                .frame(width: getScreenBounds().width * 1, height: getScreenBounds().height * 0.1)
                .background(Color("MainGray"))
                
                Divider()
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
                
                ScrollView(.vertical) {
                    VStack {
                        Header()
                        let alphabet: [String] = (65...90).map { String(UnicodeScalar($0)!) }
  
                        ForEach(alphabet, id: \.self) { letter in
                            ExerciseGroup(viewModel: viewModel, letter: letter)
                        }
                
                   
                        
                    }
                }
              
            }
            .frame(height: getScreenBounds().height * 0.86)
            .background(Color("DBblack"))
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
            
//            HStack {
//                ExersiseBodyPartButton()
//                ExersiseBodyPartButton()
//            }
//            .frame(width: getScreenBounds().width * 0.94, height: getScreenBounds().height * 0.045)
     
        }
       

       
    }
    
    
    
    
    
    
    struct ExerciseGroup: View {
        @ObservedObject var viewModel: WorkoutLogViewModel
        var letter: String
        var borderColor = Color("LinkBlue")
        
        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                
                if viewModel.checkLetter(letter: letter){
                    TextHelvetica(content: letter, size: 25)
                        .padding(.horizontal)
                        .foregroundColor(Color("WhiteFontOne"))
                    
                    VStack(alignment: .leading, spacing: 0) {
                        
                        ForEach(viewModel.exersises.filter { workoutModule in
                            if let firstLetter = workoutModule.exerciseName.first {
                                return firstLetter.uppercased() == letter
                            } else {
                                return false
                            }
                        }) { workoutModule in
                            ExersiseRow(viewModel: viewModel, exersiseName: workoutModule.exerciseName, exersiseCatagory: workoutModule.exerciseCategory[0], exerciseEquipment: workoutModule.exerciseEquipment, exersiseID: workoutModule.id)
                           
                            Divider()
                                .frame(height: borderWeight)
                                .overlay(Color("BorderGray"))
                        }
                    
                        
                    }
                    .background(Color("DBblack"))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                    .padding(.horizontal)
                    
                    Rectangle()
                        .frame(height: getScreenBounds().height * 0.03)
                        .foregroundColor(.clear)
                    
                }
            }
        }
    }
    struct ExersiseRow: View {
        @ObservedObject var viewModel: WorkoutLogViewModel
        var exersiseName: String
        var exersiseCatagory: String
        var exerciseEquipment: String
        var exersiseID: Int

        var body: some View {
            HStack {
                Button {

                    if viewModel.exersises[exersiseID].selected == false {
                        viewModel.addToExersiseQueue(ExersiseID: exersiseID)
                    } else {
                        viewModel.removeExersiseFromQueue(ExersiseID: exersiseID)
                    }

                    viewModel.setSelectionState(ExersiseID: exersiseID)
                
                }
            label: {
                //                    Image("dataIcon")
                //                        .resizable()
                //                        .frame(width: getScreenBounds().width * 0.15, height: getScreenBounds().height * 0.05)
                VStack(alignment: .leading) {
                    HStack(spacing: 5) {
                        TextHelvetica(content: exersiseName, size: 18)
                            .foregroundColor(Color("WhiteFontOne"))
                        if exerciseEquipment != "" {
                            TextHelvetica(content: "(" + exerciseEquipment + ")", size: 18)
                                .foregroundColor(Color("WhiteFontOne"))
                        }
        
                        
                    }
                   
                    TextHelvetica(content: exersiseCatagory, size: 18)
                        .foregroundColor(Color("GrayFontTwo"))
                }
                
                Spacer()
                Button {}
            label: {
                ZStack {
                    if viewModel.exersises[exersiseID].selected == false {
                        RoundedRectangle(cornerRadius: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                       
                                    .stroke(Color("BorderGray"), lineWidth: borderWeight))
                          
                       
                            .foregroundColor(Color("MainGray"))
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
            .padding(.horizontal)
            .padding(.vertical, 7)
            }
            .background(viewModel.exersises[exersiseID].selected ? Color("LinkBlue").opacity(0.3) : Color("LinkBlue").opacity(0))
            
        }
        
    }
    struct Header: View {
        @State private var search: String = ""
        var body: some View {
            VStack {
                
                
                HStack {
                    TextHelvetica(content: "Add Exersises", size: 42)
                        .foregroundColor(Color("WhiteFontOne"))
                    Spacer()
                    
                    Button {}
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
                    }.frame(width: 40, height: 40)
                        
                    
                    
                }
                .frame(width: getScreenBounds().width * 0.94)
                .padding(.bottom, -8)
                
                ZStack {
                    TextField("", text: $search, prompt: Text("Search").foregroundColor(Color("GrayFontTwo")))
                    // not right font also probably wrong on other things.
                        .keyboardType(.decimalPad)
                        .padding(.leading)
                        .multilineTextAlignment(.leading)
                        .autocorrectionDisabled(true)
                        .font(.custom("SpaceGrotesk-Medium", size: 20))
                        .foregroundColor(Color("WhiteFontOne"))
                        .frame(width: getScreenBounds().width * 0.94, height: getScreenBounds().height * 0.045)
                        .background(.clear)
                        .background(Color("DDB"))
                }
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                
                
                HStack {
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color("MainGray"))
                            .frame( height: getScreenBounds().height * 0.045)
                            .background(.clear)
                            .background(Color("DDB"))
                        
                        TextHelvetica(content: "Any Body Part", size: 16)
                    }
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                    
                    ZStack {
                        Rectangle()
                            .foregroundColor(Color("MainGray"))
                            .frame( height: getScreenBounds().height * 0.045)
                            .background(.clear)
                            .background(Color("DDB"))
                        
                        TextHelvetica(content: "Any Category", size: 16)
                    }
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                }
                .frame(width: getScreenBounds().width * 0.94, height: getScreenBounds().height * 0.045)
                
            }.frame(height: getScreenBounds().height * 0.31)
            
        }
    }
    
    struct ExersiseBodyPartButton: View {
        
        @State var isMenuOpen = false
        
        var body: some View {
            ZStack {
                
                Row()
                .displayOnMenuOpen(isMenuOpen, offset: 150)
                
                
                Row()
                .displayOnMenuOpen(isMenuOpen, offset: 100)
                   
                
                Row()
                .frame( height: getScreenBounds().height * 0.045)
                .displayOnMenuOpen(isMenuOpen, offset: 45)

                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(Color("MainGray"))

                        .background(Color("DDB"))
                    Button {
                        isMenuOpen.toggle()
                    }
                    label : {
                        RoundedRectangle(cornerRadius: 6)
                                    .strokeBorder(Color("BorderGray"), lineWidth: borderWeight)
                   
                    }
                   
                    
                    TextHelvetica(content: "Any Body Part", size: 16)
                        .foregroundColor(Color("WhiteFontOne"))
                }
                .frame( height: getScreenBounds().height * 0.045)
               
            }
        }
        
        
        struct Row: View {
            var body: some View {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .foregroundColor(Color("MainGray"))

                        .background(Color("DDB"))
                    Button {
                     
                    }
                    label : {
                        RoundedRectangle(cornerRadius: 6)
                                    .strokeBorder(Color("BorderGray"), lineWidth: borderWeight)
                   
                    }
                   
                    
                    TextHelvetica(content: "Any Body Part", size: 16)
                        .foregroundColor(Color("WhiteFontOne"))
                }
                .frame( height: getScreenBounds().height * 0.045)
            }
        }
    }
    
    
    
}



 

