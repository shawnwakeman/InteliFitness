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
    @Binding var asdh: Bool
    @State private var search: String = ""


    struct ViewOffsetKey: PreferenceKey {
        static var defaultValue: CGFloat = 0

        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
    }
    
    var body: some View {
        NavigationStack {
          
            ZStack {
                Color("DBblack").ignoresSafeArea()
      
                ZStack {
                   
                    
                    ScrollView {
               
                        
                        LazyVStack {
                            Rectangle()
                                .frame(height: getScreenBounds().height * 0.2)
                                .foregroundColor(.clear)
                            let alphabet: [String] = (65...90).map { String(UnicodeScalar($0)!) }
      
                            ForEach(alphabet, id: \.self) { letter in
                                ExerciseGroup(viewModel: viewModel, letter: letter)
                            }
                        }
                    }
                    Rectangle()
                        .frame(height: getScreenBounds().height * 0.3)
                        .position(x: getScreenBounds().width/2, y: getScreenBounds().height * -0.02)
                        .foregroundColor(Color("MainGray"))
                    Header(asdh: $asdh)
                        
                        .position(x: getScreenBounds().width/2, y: getScreenBounds().height * 0.07)


                }
                       

                .navigationBarTitle("Exercises")
                .toolbarBackground( Color("MainGray"), for: .navigationBar)
                .navigationBarTitleDisplayMode(.automatic) // Use inline mode for the title
                .navigationBarItems(
                    leading: Button(action: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 1, blendDuration: 0)) {
                                  asdh.toggle()
                              }
                      }) {
                        Image(systemName: "arrow.left")
                    },
                    trailing: Button(action: {
                       
                      }) {
                        Image(systemName: "plus")
                    }
            )
            }
        }
        
//        ZStack {
//
//            VStack(spacing: 0) {
//                VStack {
//
//
//
//                    Header(asdh: $asdh)
//
//
//
//
//
//
//
//
//                }
//                .padding(.horizontal)
//                .frame(width: getScreenBounds().width * 1, height: getScreenBounds().height * 0.18)
//                .background(Color("MainGray"))
//
//                Divider()
//                    .frame(height: borderWeight)
//                    .overlay(Color("BorderGray"))
//
//                ScrollView(.vertical) {
//                    Rectangle()
//                        .frame(height: getScreenBounds().height * 0.025)
//                        .foregroundColor(.clear)
//                    VStack {
//
//                        let alphabet: [String] = (65...90).map { String(UnicodeScalar($0)!) }
//
//                        ForEach(alphabet, id: \.self) { letter in
//                            ExerciseGroup(viewModel: viewModel, letter: letter)
//                        }
//
//
//
//                    }
//                    Rectangle()
//                        .frame(height: getScreenBounds().height * 0.2)
//                        .foregroundColor(.clear)
//                }
//
//            }
//
//            .background(Color("DBblack"))
//
//
////            HStack {
////                ExersiseBodyPartButton()
////                ExersiseBodyPartButton()
////            }
////            .frame(width: getScreenBounds().width * 0.94, height: getScreenBounds().height * 0.045)
//
//        }
    }
    
    
    
    
    
    
    struct ExerciseGroup: View {
        @ObservedObject var viewModel: HomePageViewModel
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
                            .strokeBorder(borderColor, lineWidth: borderWeight))
                    .padding(.horizontal)
                    
                    Rectangle()
                        .frame(height: getScreenBounds().height * 0.03)
                        .foregroundColor(.clear)
                    
                }
            }
        }
    }
    struct ExersiseRow: View {
        @ObservedObject var viewModel: HomePageViewModel
        var exersiseName: String
        var exersiseCatagory: String
        var exerciseEquipment: String
        var exersiseID: Int

        var body: some View {
            HStack {
                Button {

                
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

                
            }
            .padding(.horizontal)
            .padding(.vertical, 7)
            }
            .background(viewModel.exersises[exersiseID].selected ? Color("LinkBlue").opacity(0.3) : Color("LinkBlue").opacity(0))
            
        }
        
    }
    struct Header: View {
        @State private var search: String = ""
        @Binding var asdh: Bool
        var body: some View {
            VStack {


                    
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
                
            }.frame(width: getScreenBounds().width * 1, height: getScreenBounds().height * 0.12)
                .offset(y: -5)
                .background(Color("MainGray"))

            
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
 
extension Bundle {
    func decode<T: Decodable>(_ file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in bundle.")
        }
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        let decoder = JSONDecoder()
        guard let result = try? decoder.decode(T.self, from: data) else {
            fatalError("Failed to decode \(file) from bundle.")
        }
        return result
    }
}


extension View {
    func displayOnMenuOpen(_ isOpened: Bool, offset: CGFloat) -> some View {
        modifier(DisplayOnOpenMenuViewModifier(isOpened: isOpened, offset: offset))
    }
}
