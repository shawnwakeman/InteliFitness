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
    @State private var progressValue: Float = 0.5
    @State private var blocked = false
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some View {
        
        
        ZStack {
            ScrollView(.vertical){
                
                
                DropDownHeaderView(viewModel: workoutLogViewModel)
                
                
                
                VStack(spacing: 20){
                    if workoutLogViewModel.exersiseModules.count > 0 {
                        
                        ForEach(workoutLogViewModel.exersiseModules){
                            workoutModule in
                            ExersiseLogModule(workoutLogViewModel: workoutLogViewModel, blocked: $blocked, parentModuleID: workoutModule.id)
                        }
                    }
                    
                    FullWidthButton().padding(.top, -40.0).onTapGesture {
                        workoutLogViewModel.addEmptyWorkoutModule()
                        
                    }
                    
                    
                    
                    
                }
                
                
            }
            if workoutLogViewModel.RPEPopUp.RPEpopUpState{
                VisualEffectView(effect: UIBlurEffect(style: .dark))
                                   .edgesIgnoringSafeArea(.all)

                PopupView(viewModel: workoutLogViewModel)
                    .shadow(radius: 10)
            }
            
        }
        .onTapGesture {
            withAnimation(.spring())
            {
                for key in workoutLogViewModel.popUpStates.keys {
                    workoutLogViewModel.popUpStates[key] = false
                }
               
            }

            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .background(Color("DBblack"))
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
}
    
struct VisualEffectView: UIViewRepresentable {
    let effect: UIVisualEffect?
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        UIVisualEffectView()
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = effect
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
    @Binding var blocked: Bool
    var parentModuleID: Int
    var body: some View {
        VStack(spacing: -20){
            LogModuleHeader(viewModel: workoutLogViewModel, blocked: $blocked, parentModuleID: parentModuleID)
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
    @Binding var blocked: Bool
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
                
                DataMetricsPopUp(viewModel: viewModel)
            }

            ZStack{
                
                Image("meatBalls")
                    .resizable()
                    .frame(width: 39.4, height: 28)
                DotsMenuView(viewModel: viewModel)
            }
//    


                
            
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
        Text(content).font(.custom("SpaceGrotesk-Medium", size: size))
    }
}

struct PopupView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: WorkoutLogViewModel
    @State private var isToggled = false
    var body: some View {
        // Add a blur effect to the background

        VStack {
            HStack {
                Button { viewModel.setPopUpState(state: false)}
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
                    
                        
                }.frame(maxWidth: 50)
                Spacer()
                TextHelvetica(content: "RPE", size: 25)
                    .foregroundColor(Color("WhiteFontOne"))
                Spacer()
                Button {print("Button pressed")}
                label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 4)
                            .overlay(
                                RoundedRectangle(cornerRadius: 4)
                                    .stroke(Color("BorderGray"), lineWidth: borderWeight))
                            .foregroundColor(Color("MainGray"))
                        TextHelvetica(content: "?", size: 23)
                    
                    }
                }.frame(maxWidth: 50)

                
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            
            HStack(spacing: 20) {
                


                

                Button(action: {viewModel.setRepMetric(exersiseModuleID: viewModel.RPEPopUp.popUpExersiseModuleIndex, RowID: viewModel.RPEPopUp.popUpRowIndex, RPE: 5); viewModel.setPopUpState(state: false)}) {
                    TextHelvetica(content: "5", size: 18)
                
                }
                
                Button(action: {viewModel.setRepMetric(exersiseModuleID: viewModel.RPEPopUp.popUpExersiseModuleIndex, RowID: viewModel.RPEPopUp.popUpRowIndex, RPE: 6); viewModel.setPopUpState(state: false)}) {
                    TextHelvetica(content: "6", size: 18)
                }
                
                Button(action: {viewModel.setRepMetric(exersiseModuleID: viewModel.RPEPopUp.popUpExersiseModuleIndex, RowID: viewModel.RPEPopUp.popUpRowIndex, RPE: 7); viewModel.setPopUpState(state: false)}) {
                    TextHelvetica(content: "7", size: 18)
                }
                
                Button(action: {viewModel.setRepMetric(exersiseModuleID: viewModel.RPEPopUp.popUpExersiseModuleIndex, RowID: viewModel.RPEPopUp.popUpRowIndex, RPE: 7.5); viewModel.setPopUpState(state: false)}) {
                    TextHelvetica(content: "7.5", size: 18)
                }
                
                Button(action: {viewModel.setRepMetric(exersiseModuleID: viewModel.RPEPopUp.popUpExersiseModuleIndex, RowID: viewModel.RPEPopUp.popUpRowIndex, RPE: 8); viewModel.setPopUpState(state: false)}) {
                    TextHelvetica(content: "8", size: 18)
                }
     
                Button(action: {viewModel.setRepMetric(exersiseModuleID: viewModel.RPEPopUp.popUpExersiseModuleIndex, RowID: viewModel.RPEPopUp.popUpRowIndex, RPE: 8.5); viewModel.setPopUpState(state: false)}) {
                    TextHelvetica(content: "8.5", size: 18)
                }
     
                    
                
                Button(action: {viewModel.setRepMetric(exersiseModuleID: viewModel.RPEPopUp.popUpExersiseModuleIndex, RowID: viewModel.RPEPopUp.popUpRowIndex, RPE: 9); viewModel.setPopUpState(state: false)}) {
                    TextHelvetica(content: "9", size: 18)
                }
                
                Button(action: {viewModel.setRepMetric(exersiseModuleID: viewModel.RPEPopUp.popUpExersiseModuleIndex, RowID: viewModel.RPEPopUp.popUpRowIndex, RPE: 9.5); viewModel.setPopUpState(state: false)}) {
                    
                    TextHelvetica(content: "9.5", size: 18)
                }
                
                Button(action: {viewModel.setRepMetric(exersiseModuleID: viewModel.RPEPopUp.popUpExersiseModuleIndex, RowID: viewModel.RPEPopUp.popUpRowIndex, RPE: 10); viewModel.setPopUpState(state: false)}) {
                    
                    TextHelvetica(content: "10", size: 18)
                }
                

                

            
            
            }
            
            .padding(.horizontal, 25)
            .padding(.vertical, 10)
            .background(Color("DDB"))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("BorderGray"), lineWidth: borderWeight))
            .padding()
            
            
            HStack {
                HStack() {
                
                    TextHelvetica(content: "Target", size: 19)
                        .foregroundColor(Color("GrayFontOne"))
                    Divider()
                        .frame(width: borderWeight)
                        .overlay(Color("BorderGray"))
                    TextHelvetica(content: "10.5", size: 18)
                        .foregroundColor(Color("GrayFontOne"))
                    
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(Color("DDB"))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("BorderGray"), lineWidth: borderWeight))
                
                .padding()
                
                HStack {
                    TextHelvetica(content: "Show RPE", size: 15)
                        .foregroundColor(Color("GrayFontOne"))
                    
                    Toggle("", isOn: $isToggled)
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                        .padding(.trailing,5)
                        
                    
                    
                    
                }
                
                .padding(.horizontal)
                .padding(.vertical, 7)
                .background(Color("DDB"))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("BorderGray"), lineWidth: borderWeight))
                .padding()
                

            }
            
        }
        .frame(maxWidth: 400, maxHeight: 220)
        .background(Color("DBblack"))
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("BorderGray"), lineWidth: borderWeight))
        .padding()


            
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




struct DividerView: View {
    var isHorizontal: Bool
    var body: some View {
        if isHorizontal {
            Divider()
                .frame(height: borderWeight)
                .overlay(Color("BorderGray"))
        } else {
            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
        }
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

extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}






struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let workoutLogViewModel = WorkoutLogViewModel()
        WorkoutLogView(workoutLogViewModel: workoutLogViewModel)
    }
}
