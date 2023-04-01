//
//  ContentView.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 3/25/23.
//

import SwiftUI
let borderWeight: CGFloat = 1.7

struct WorkoutLogView: View {
    static let borderWeight: CGFloat = 1.7
    @StateObject var workoutLogViewModel = WorkoutLogViewModel()
    @State var progressValue: Float = 0.5
    
    var body: some View {
        let _ = print(workoutLogViewModel.exersiseModules)
        ScrollView(.vertical){
            
            
            DropDownHeaderView()
            
            
            
            VStack(spacing: -20){
                if workoutLogViewModel.exersiseModules.count > 0 {
                    let _ = print(workoutLogViewModel.exersiseModules.count)
                    ForEach(workoutLogViewModel.exersiseModules){
                        workoutModule in
                        ExersiseLogModule(workoutLogViewModel: workoutLogViewModel, parentModuleID: workoutModule.id)
                    }
                }

                FullWidthButton().onTapGesture {
                    workoutLogViewModel.addEmptyWorkoutModule()
                }
                

                

                
            }
            
            
        }.background(Color("DBblack"))
        
    }
    
//    init() {
//        for famliyName in UIFont.familyNames {
//            print(famliyName)
//            for fontName in UIFont.fontNames(forFamilyName: famliyName){
//                print(fontName)
//            }
//
//        }
//    }
    
}
struct ExersiseLogModule: View {
    @ObservedObject var workoutLogViewModel: WorkoutLogViewModel

    var parentModuleID: Int
    var body: some View {
      
        LogModuleHeader(viewModel: workoutLogViewModel, parentModuleID: parentModuleID).onTapGesture {
            workoutLogViewModel.addEmptySet(moduleID: 0)
        }
        CoreLogModule(viewModel: workoutLogViewModel, ModuleID: parentModuleID)
    }
}
struct DropDownHeaderView: View {
    var body: some View {
        ZStack{
            
            
            
           
            ZStack{
                RoundedRectangle(cornerRadius: 18)
                    .foregroundColor(Color("MainGray"))
                    .padding(.vertical, -4.0)
                    .padding(.horizontal, -1)
                    .frame(height: 40)
                    .shadow(color: .black, radius: 10, x: 0, y: 0)
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color("BorderGray"), lineWidth: borderWeight)
                    .padding(.vertical, -4.0)
                    .padding(.horizontal, -1)
                    .frame(height: 40)
            }

            
            Rectangle()
            
                .size(width:430, height: 1000)
                .offset(y:-950)
                .foregroundColor(Color("MainGray"))
            
//                )
                

            


            HStack(alignment: .top){
                Spacer()
                ZStack{
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 6)
                            .foregroundColor(Color("DBblack"))
                        
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(Color("BorderGray"), lineWidth: borderWeight)
                        
                    }
                    
                    
                    
                    HStack{
                        Image(systemName: "clock")
                            .foregroundColor(Color("LinkBlue"))
                            .imageScale(.large)
                            .bold()
                        TextHelvetica(content: "1:23", size: 20)
                            .foregroundColor(Color("WhiteFontOne"))
                    }
                    
                    
                }
                .padding(.bottom)
                .frame(maxWidth: 110, maxHeight: 55)
                
                Divider().frame(width: 120)
                    .opacity(0)
                
                
                
                
                
                
                
                VStack(alignment: .center) {
                    ProgressBar().frame(height: 20)
                    Spacer()
                }
                .padding([.top, .leading, .bottom])
                .padding(.trailing, 4)
                .offset(y:-5)
                .frame(maxWidth: 150)
                
            }
            .padding(.all, 21.0)
            
            TextHelvetica(content: "0:12", size: 20)
                .padding(.bottom, 17.0)
                .foregroundColor(Color("GrayFontOne"))
        }.offset(x:0, y: -19)
    }
}

struct ProgressBar: View {

    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {

                    
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .foregroundColor(Color("DBblack"))
                    .cornerRadius(45.0)
                    
                
                Rectangle().frame(width: min(CGFloat(0.5)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(UIColor.systemBlue))
                    .cornerRadius(45)
                
                Capsule()
                    .stroke(Color("BorderGray"), lineWidth: borderWeight)
            }
        }
    }
}

struct FullWidthButton: View{
    var body: some View{
        ZStack{
            ZStack{
                
                RoundedRectangle(cornerRadius: 5)
                    .foregroundColor(Color("BlueOverlay"))
                    .padding(.all)
                    .aspectRatio(7/1, contentMode: .fill)
                
                RoundedRectangle(cornerRadius: 5)
                    .strokeBorder(Color("BlueOverlayBorder"), lineWidth: borderWeight)

                    .padding(.all)
                    .aspectRatio(7/1, contentMode: .fill)
                
            }


            TextHelvetica(content: "add exersise", size: 20)
                .foregroundColor(Color(.white))
        }.padding(.top,-2)
    }
    
}





struct addSetButton: View {
    var parentModuleID: Int
    @ObservedObject var viewModel: WorkoutLogViewModel
    var body: some View{
        Button {viewModel.addEmptySet(moduleID: parentModuleID)}
        
        label: {
            ZStack{
                RoundedRectangle(cornerRadius: 4)
                    .foregroundColor(Color("ClearBlueBorder"))
                

                TextHelvetica(content: "add set", size: 20)
                    .foregroundColor(Color(.white))
            }

            
            
        }.frame(maxWidth: 100, maxHeight: 28)
    }
}








struct LogModuleHeader: View{
    @ObservedObject var viewModel: WorkoutLogViewModel
    var parentModuleID: Int
    var body: some View{
        
        HStack{
            
            Button {print("Button pressed")}
            label: {
                TextHelvetica(content: "Back Squat", size: 28)
                    .foregroundColor(Color("LinkBlue"))
            }

            Spacer()
            
            addSetButton(parentModuleID: parentModuleID, viewModel: viewModel)
            
            ZStack{
                Image("dataIcon")
                    .resizable()
                    .frame(width: 39.4, height: 28)
                
                RoundedRectangle(cornerRadius: 3)
                    .stroke(Color("BorderGray"), lineWidth: borderWeight)
                    .frame(width: 39.4, height: 28)
            }

            ZStack{
                
                Image("meatBalls")
                    .resizable()
                    .frame(width: 39.4, height: 28)
                RoundedRectangle(cornerRadius: 3)
                
                    .stroke(Color("BorderGray"), lineWidth: borderWeight)
                    .frame(width: 39.4, height: 28)
            }

                
            
        }
        .padding(/*@START_MENU_TOKEN@*/[.top, .leading, .trailing]/*@END_MENU_TOKEN@*/)
        .padding(.bottom, 9)
    }
}

struct CoreLogModule: View {
    @ObservedObject var viewModel: WorkoutLogViewModel
    var ModuleID: Int
    var body: some View{
        ZStack(){
            
            RoundedRectangle(cornerRadius: 7)
                .stroke(Color("BorderGray"), lineWidth: borderWeight)
                .background(Color.clear)
                .zIndex(1)
            
            
            
            
            VStack(alignment: .leading, spacing: 0){
                Header()
                ContentGrid(viewModel: viewModel, ModuleID: ModuleID)
                
            }
            
        }
        .padding(.all)
    }
}

struct TextHelvetica: View{
    var content: String
    var size: CGFloat
    var body: some View
    {
        Text(content).font(.custom("SpaceGrotesk-Medium", size: size)).multilineTextAlignment(.center)
    }
}


struct WorkoutSetRowView: View{
    @ObservedObject var viewModel: WorkoutLogViewModel
    var setNumber: Int
    var previousSet: String
    var setWeightPlaceHolder: String
    var SetRepsPlaceholder: String
    @State private var givenName: String = ""
    @State private var familyName: String = ""
    var colosr: Color = Color("WhiteFontOne")
    var body: some View{

        HStack(spacing: 0){
            TextHelvetica(content: String(setNumber), size: 21)
                .padding()
                .frame(width: 55, height: 40)
                .foregroundColor(Color("LinkBlue"))
                .background(.clear)
            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
           
            TextHelvetica(content: previousSet, size: 21)
                .frame(width: 145, height: 40)
                .foregroundColor(Color("GrayFontOne"))
                .background(.clear)
            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
            
            
   


            
         
            TextField("", text: $givenName, prompt: Text(setWeightPlaceHolder).foregroundColor(Color("GrayFontTwo")))
                .font(.custom("SpaceGrotesk-Medium", size: 21))
                .foregroundColor(Color("WhiteFontOne"))
                .frame(width: 70, height: 40)
                .background(.clear)
                .multilineTextAlignment(.center)
                .background(Color("DDB"))
//                .keyboardType(.numberPad)
                


//
//
            
            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
            
            HStack{
                

               
                TextField("", text: $familyName, prompt: Text(SetRepsPlaceholder).foregroundColor(Color("GrayFontTwo")))
                    .font(.custom("SpaceGrotesk-Medium", size: 21))
                    .foregroundColor(Color("WhiteFontOne"))
                    .frame(width: 40, height: 40)
                    .background(.clear)
                    .multilineTextAlignment(.center)
                    .background(Color("DDB"))
//                    .keyboardType(.numberPad)


                    
                    
                ZStack{
                    
                    ZStack{
                        Capsule()
                            .padding(.vertical, 9.0)
                            .foregroundColor(Color("MainGray"))
                            .frame(width: 30)
                        
                        Capsule()
                            .strokeBorder(Color("BorderGray"), lineWidth: borderWeight)
                            .padding(.vertical, 9.0)
                            
                            
                            .frame(width: 30)
                    }
                    
                    TextHelvetica(content: "10", size: 13)
                        .foregroundColor(Color.white)
                        
                }.padding(.leading, -8)
                    .padding(.trailing, 5)

                    
            }.frame(width: 80, height: 40)
            .background(Color("DDB"))


            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
            

            
            Image("checkMark")
                .resizable()
                .padding(9.0)
                .aspectRatio(40/37, contentMode: .fit)
                .background(.clear)
                
        }
        
    }
}

struct SuperTextField: View {
    
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool)->() = { _ in }
    var commit: ()->() = { }
    
    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}

struct ContentGrid: View {
    @ObservedObject var viewModel: WorkoutLogViewModel
    var ModuleID: Int
    var body: some View{
        
        let module = viewModel.exersiseModules[ModuleID]
        
        ForEach(module.setRows){
            row in
            WorkoutSetRowView(viewModel: viewModel ,setNumber: row.setIndex, previousSet: row.previousSet, setWeightPlaceHolder: row.weightPlacholder, SetRepsPlaceholder: row.repsPlacholder)
            

            Divider()
                
                .frame(height: borderWeight)
                .overlay(Color("BorderGray"))

        }
        
    }
}



struct Header: View {
    var body: some View{
        ZStack{
            Rectangle()
                .cornerRadius(4, corners: [.topLeft, .topRight])
                .foregroundColor(Color("MainGray"))
                .aspectRatio(7.3/1, contentMode: .fill)
            VStack{
                HStack{
                    Spacer()
                    TextHelvetica(content: "Set", size: 24)
                        .foregroundColor(Color("WhiteFontOne"))
                        .offset(x: -2)
                    Spacer()
              
                    TextHelvetica(content: "Previous", size: 24)
                        .foregroundColor(Color("WhiteFontOne"))
                    Spacer()
                    
                    TextHelvetica(content: "Lbs", size: 24)
                        .foregroundColor(Color("WhiteFontOne"))
                        .offset(x:5)
                    Spacer()

                    TextHelvetica(content: "Reps", size: 24)
                        .padding(.trailing)
                        .foregroundColor(Color("WhiteFontOne"))
                
                    Spacer()
                }.offset(x: -13,y: 0)
                
                
         
            }

        }
        Rectangle()
            .frame(height: borderWeight)
            .foregroundColor(Color("BorderGray"))
            
    }
}


























extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}


struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
    
}











struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let workoutLogViewModel = WorkoutLogViewModel()
        WorkoutLogView(workoutLogViewModel: workoutLogViewModel)
    }
}
