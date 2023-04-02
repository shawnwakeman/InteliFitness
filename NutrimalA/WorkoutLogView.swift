//
//  ContentView.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 3/25/23.
//

import SwiftUI


let borderWeight: CGFloat = 1.7

class HapticManager {
    static let instance = HapticManager()
    
    func notification(type: UINotificationFeedbackGenerator.FeedbackType) {
        let genorator = UINotificationFeedbackGenerator()
        genorator.notificationOccurred(type)
    }
        
    func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let genorator = UIImpactFeedbackGenerator(style: style)
        genorator.impactOccurred()
    }
        
    
}




struct WorkoutLogView: View {
    static let borderWeight: CGFloat = 1.7
    @StateObject var workoutLogViewModel = WorkoutLogViewModel()
    @State var progressValue: Float = 0.5
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {


    
        ScrollView(.vertical){
            
            
            DropDownHeaderView(viewModel: workoutLogViewModel)
            
            
            
            VStack(spacing: 20){
                if workoutLogViewModel.exersiseModules.count > 0 {
                    
                    ForEach(workoutLogViewModel.exersiseModules){
                        workoutModule in
                        ExersiseLogModule(workoutLogViewModel: workoutLogViewModel, parentModuleID: workoutModule.id)
                    }
                }
                
                FullWidthButton().padding(.top, -40.0).onTapGesture {
                    workoutLogViewModel.addEmptyWorkoutModule()
                    
                }
                


                
            }
            
            
        }.background(Color("DBblack"))
            .onChange(of: scenePhase) { newScenePhase in
                switch newScenePhase {
                case .active:
                    workoutLogViewModel.updateTimeToCurrent()
                case .inactive:
                    print("App is inactive")
                case .background:
                    workoutLogViewModel.saveBackgroundTime()
                @unknown default:
                    fatalError("Unknown scene phase")
                }
            }
        
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

//struct SoundTester: View{
//    var body: some View{
//        Button("1") {HapticManager.instance.notification(type: .success)}
//        Button("2") {HapticManager.instance.notification(type: .warning)}
//        Button("3") {HapticManager.instance.notification(type: .error)}
//        Button("4") {HapticManager.instance.impact(style: .heavy)}
//        Button("5") {HapticManager.instance.impact(style: .light)}
//        Button("6") {HapticManager.instance.impact(style: .medium)}
//        Button("7") {HapticManager.instance.impact(style: .rigid)}
//        Button("8") {HapticManager.instance.impact(style: .soft)}
//    }
//
//}

struct WorkoutTimer : View {
    @ObservedObject var viewModel: WorkoutLogViewModel
    var fontSize: CGFloat
    var body: some View{
        ZStack{
        

            let hours = viewModel.workoutTime.timeElapsed / 3600
            let minutes = (viewModel.workoutTime.timeElapsed / 60) - (hours * 60)
            let seconds = viewModel.workoutTime.timeElapsed % 60


            if hours < 1 {
                TextHelvetica(content: "\(minutes):\(String(format: "%02d", seconds))", size: fontSize)
                
            }
            else{
                TextHelvetica(content: "\(String(hours)):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))", size: fontSize)
              
            }
                    
           
            
        }
        
        .onReceive(viewModel.workoutTime.time) { (_) in
            
            if viewModel.workoutTime.timeRunning{
             
    
                
                viewModel.addToTime()
                    
     
            }
                    
               

        }
            
    }
}

struct ExersiseLogModule: View {
    @ObservedObject var workoutLogViewModel: WorkoutLogViewModel

    var parentModuleID: Int
    var body: some View {
        VStack(spacing: -20){
            LogModuleHeader(viewModel: workoutLogViewModel, parentModuleID: parentModuleID)
            CoreLogModule(viewModel: workoutLogViewModel, ModuleID: parentModuleID)
        }

    }
}
struct DropDownHeaderView: View {
    @ObservedObject var viewModel: WorkoutLogViewModel
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
            WorkoutTimer(viewModel: viewModel, fontSize: 20)
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
                TextHelvetica(content: viewModel.exersiseModules[parentModuleID].exersiseName, size: 28)
                    .foregroundColor(Color("LinkBlue"))
            }

            Spacer()
            
            addSetButton(parentModuleID: parentModuleID, viewModel: viewModel).onTapGesture {
                viewModel.addEmptySet(moduleID: 0)
            }
            
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
    var rowObject: WorkoutLogModel.ExersiseSetRow
    var moduleID: Int
    @State private var givenName: String = ""
    @State private var familyName: String = ""

    var body: some View{

        
        HStack(spacing: 0){
            TextHelvetica(content: String(rowObject.setIndex), size: 21)
                       .padding()
                       .frame(width: 55, height: 40)
                       .foregroundColor(Color("LinkBlue"))
                       .background(.clear)
                   Divider()
                       .frame(width: borderWeight)
                       .overlay(Color("BorderGray"))
            
            
            
            if rowObject.previousSet == "0" {
                Capsule()
                    .padding(.horizontal, 50.0)
                    .padding(.vertical, 18)
                    .frame(width: 145, height: 40)
                    .foregroundColor(Color("GrayFontOne"))
            }
            else
            {
                TextHelvetica(content: rowObject.previousSet, size: 21)
                                .frame(width: 145, height: 40)
                                .foregroundColor(Color("GrayFontOne"))
                                .background(.clear)
            }

            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
            
            
   


            
         
            
            TextField("", text: $givenName, prompt: Text(rowObject.weightPlaceholder).foregroundColor(Color("GrayFontTwo")))
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
                

               
                TextField("", text: $familyName, prompt: Text(rowObject.repsPlaceholder).foregroundColor(Color("GrayFontTwo")))
                        .font(.custom("SpaceGrotesk-Medium", size: 21))
                        .foregroundColor(Color("WhiteFontOne"))
                        .frame(minWidth: 40, minHeight: 40)
                        .background(.clear)
                        .multilineTextAlignment(.center)
                        .background(Color("DDB"))

//                    .keyboardType(.numberPad)


                    
                if !rowObject.repsPlaceholder.isEmpty {
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
                        
                        TextHelvetica(content: String(rowObject.repMetric), size: 13)
                            .foregroundColor(Color.white)
                            
                    }.padding(.leading, -8)
                        .padding(.trailing, 5)
                }
               

                    
            }.frame(width: 80, height: 40)
            .background(Color("DDB"))


            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
            
            
            
            ZStack {

                
                Image("checkMark")
                    .resizable()
                    .padding(9.0)
                    .opacity(rowObject.setCompleted ? 100.0: 0.0)
                    .aspectRatio(40/37, contentMode: .fit)
                
                ZStack{
                    
                    Rectangle().foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.01))
                    
                    
                }
                .onTapGesture {
                    viewModel.toggleCompletedSet(ExersiseModuleID: moduleID, RowID: rowObject.id)
                    HapticManager.instance.impact(style: .heavy)
                    
                }
                .frame(width: 40, height: 40)
            }


                
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
            WorkoutSetRowView(viewModel: viewModel, rowObject: row, moduleID: ModuleID)
            
            
      
            if (row.id != module.setRows.indices.last){
                Divider()
                    
                    .frame(height: borderWeight)
                    .overlay(Color("BorderGray"))
            }
            

                



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
