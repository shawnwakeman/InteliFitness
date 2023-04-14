//
//  WorkoutSetRowView.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/7/23.
//

import SwiftUI
import Combine
struct WorkoutSetRowView: View{
    @ObservedObject var viewModel: WorkoutLogViewModel
    var rowObject: WorkoutLogModel.ExersiseSetRow
    var moduleID: Int
    @State private var lbsTextField: String = ""
    @State private var familyName: String = ""
    @State private var RPEpopUpDisplayed = false

    
    var body: some View{

        
        HStack(spacing: 0){

            
            setIndexView(rowObject: rowObject)
            
            previousSetView(rowObject: rowObject)
            
            lbsTextFieldView(rowObject: rowObject, moduleID: moduleID, viewModel: viewModel)
            
            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
                .zIndex(1)
            
            HStack{

                repTextFieldView(rowObject: rowObject, moduleID: moduleID, viewModel: viewModel)
                if viewModel.exersiseModules[moduleID].displayingRPE == true {
                    repMetricView(rowObject: rowObject, viewModel: viewModel, moduleID: moduleID)
                }
            
                
                
            }
            .frame(width: getScreenBounds().width * 0.2, height: getScreenBounds().height * 0.045)

            .background(Color("DDB"))
            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))

            
                
            
            checkBoxView(rowObject: rowObject, moduleID: moduleID, viewModel: viewModel)
            
        }
        
    }
    
    
    
    // MARK: - SubStructs(s)
    struct setIndexView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow
        
        var body: some View {
            TextHelvetica(content: String(rowObject.setIndex), size: 18)
                       .padding()
                       .frame(width: getScreenBounds().width * 0.137, height: getScreenBounds().height * 0.03)
                       .foregroundColor(Color("LinkBlue"))
                       .background(.clear)
                   Divider()
                       .frame(width: borderWeight)
                       .overlay(Color("BorderGray"))
        }
    }
    
    struct previousSetView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow
        
        var body: some View {
            Group {
                if rowObject.previousSet == "0" {
                    Capsule()
                        .frame(width: getScreenBounds().width * 0.1, height: getScreenBounds().height * 0.005)
                        .foregroundColor(Color("GrayFontOne"))
                }
                else
                {
                    TextHelvetica(content: rowObject.previousSet, size: 20)
                                    .foregroundColor(Color("GrayFontOne"))
                                    .background(.clear)
                }
            }
            .frame(width: getScreenBounds().width * 0.31, height: getScreenBounds().height * 0.03)


            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
            
            
        }
    }
    
    struct lbsTextFieldView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow
        var moduleID: Int
        @ObservedObject var viewModel: WorkoutLogViewModel
        @State private var lbsTextField: String = ""
        var body: some View {
            TextField("", text: $lbsTextField, prompt: Text(rowObject.weightPlaceholder).foregroundColor(Color("GrayFontTwo")))
                .keyboardType(.decimalPad)
                .autocorrectionDisabled(true)
                .font(.custom("SpaceGrotesk-Medium", size: 20))
                .foregroundColor(Color("WhiteFontOne"))
                .frame(width: getScreenBounds().width * 0.18, height: getScreenBounds().height * 0.045)
                .background(.clear)
                .multilineTextAlignment(.center)
                .background(Color("DDB"))
                .onReceive(Just(lbsTextField)) { newValue in
                    var filtered = newValue.filter { "0123456789.".contains($0) }
                        if filtered.filter({$0 == "."}).count > 1 {
                            // If the filtered string contains more than one decimal point, remove all but the first one.
                            let firstDecimalPointIndex = filtered.firstIndex(of: ".")!
                            filtered = filtered.prefix(upTo: firstDecimalPointIndex) + filtered.suffix(from: filtered.index(after: firstDecimalPointIndex)).filter({$0 != "."})
                        } else if filtered.contains(".") {
                            // If the filtered string contains a single decimal point, ensure that it appears only once.
                            let parts = filtered.split(separator: ".", maxSplits: 1, omittingEmptySubsequences: false)
                            filtered = String(parts[0].prefix(3)) + "." + String(parts[1].prefix(2))
                        } else {
                            // If the filtered string does not contain a decimal point, limit it to a maximum of 3 characters.
                            filtered = String(filtered.prefix(3))
                        }
                        if let number = Float(filtered), number > 999.99 {
                            // If the filtered string can be converted to a Float and is greater than 999.9, set it to "999.9".
                            filtered = "999.99"
                        }
                        lbsTextField = filtered
                }


                .onChange(of: lbsTextField) { newValue in
                    viewModel.setWeightValue(exersiseModuleID: moduleID, RowID: rowObject.id, value: Float(lbsTextField) ?? 0)
                    viewModel.setLastModule(index: moduleID)
                    viewModel.setLastRow(index: rowObject.id)
                }
            
            
        }
    }
    
    struct repTextFieldView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow
        var moduleID: Int
        @ObservedObject var viewModel: WorkoutLogViewModel
        @State private var repsTextField: String = ""
        var body: some View {
            TextField("", text: $repsTextField, prompt: Text(rowObject.repsPlaceholder).foregroundColor(Color("GrayFontTwo")))
                    .keyboardType(.numberPad)
                    .autocorrectionDisabled(true)
                    .font(.custom("SpaceGrotesk-Medium", size: 20))
                    .foregroundColor(Color("WhiteFontOne"))
                    .frame(width: getScreenBounds().width * 0.1, height: getScreenBounds().height * 0.045)
                    .background(.clear)
                    .multilineTextAlignment(.center)
                    .background(Color("DDB"))
                    .onReceive(
                        Just(repsTextField)) { newValue in
                        var filtered = newValue.filter { "0123456789".contains($0) }

                        if filtered.count > 2 {
                            // If the filtered string contains more than two digits, limit it to the first two.
                            filtered = String(filtered.prefix(2))
                        }
                        repsTextField = filtered
          
                    }
                       
             

                    .onChange(of: repsTextField) { newValue in
                        viewModel.setRepValue(exersiseModuleID: moduleID, RowID: rowObject.id, value: Int(repsTextField) ?? 0)
                        viewModel.setLastModule(index: moduleID)
                        viewModel.setLastRow(index: rowObject.id)
                    }
            
        }
    }
    
    struct repMetricView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow
        @ObservedObject var viewModel: WorkoutLogViewModel
        var moduleID: Int
        var body: some View {
            if rowObject.repMetric != 0 {
                ZStack{
                    
                    ZStack{
                        Capsule()
                            .padding(.vertical, 9.0)
                            .foregroundColor(Color("MainGray"))
                            .frame(width: getScreenBounds().width * 0.08)
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                HapticManager.instance.impact(style: .rigid)
                                viewModel.setPopUpState(state: true, popUpId: "popUpRPE")
                                viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id, popUpId: "popUpRPE")
                                viewModel.setLastRow(index: rowObject.id)
                                viewModel.setLastModule(index: moduleID)

                            }}, label: {
                                Capsule()
                                    .strokeBorder(Color("BorderGray"), lineWidth: borderWeight)
                                    .padding(.vertical, 9.0)
                                .frame(width: getScreenBounds().width * 0.08)})
                        
                    }
                    
                    TextHelvetica(content: String(rowObject.repMetric.clean), size: 13)
                        .foregroundColor(Color.white)
                    
                }
                .padding(.leading, -8)
                .padding(.trailing, 5)
                
            } else {
                ZStack{
                    
                    ZStack{
                        Capsule()
                            .padding(.vertical, 9.0)
                            .foregroundColor(Color("MainGray"))
                            .frame(width: getScreenBounds().width * 0.08)
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                HapticManager.instance.impact(style: .rigid)
                                viewModel.setPopUpState(state: true, popUpId: "popUpRPE")
                                viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id, popUpId: "popUpRPE")
                                viewModel.setLastRow(index: rowObject.id)
                                viewModel.setLastModule(index: moduleID)
                            }}, label: {
                                Capsule()
                                    .strokeBorder(Color("BorderGray"), lineWidth: borderWeight)
                                    .padding(.vertical, 9.0)
                                .frame(width: getScreenBounds().width * 0.08)})
                        
                    }
                    
                    TextHelvetica(content: "", size: 13)
                        .foregroundColor(Color.white)
                    
                }
                .onTapGesture {
                    
                    
                    
                }
                .padding(.leading, -8)
                .padding(.trailing, 5)
            }
        }
    }

        
    struct checkBoxView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow
        var moduleID: Int
        @ObservedObject var viewModel: WorkoutLogViewModel
        var body: some View {
            ZStack {

                Image(systemName: "checkmark")
                    .resizable()
                    .padding(9.0)
                    .bold()
                    .foregroundColor(rowObject.setCompleted ? Color(.systemGreen) : Color("GrayFontOne"))
                    .aspectRatio(40/37, contentMode: .fit)
                    .scaleEffect(rowObject.setCompleted ? 0.9 : 0.7)
              

                ZStack{
                    
                    Rectangle().foregroundColor(Color(red: 0, green: 0, blue: 0, opacity: 0.01))
                    
                    
                }
                .onTapGesture {
    
                    withAnimation(.easeInOut(duration: 0.1)) {
                        viewModel.toggleCompletedSet(ExersiseModuleID: moduleID, RowID: rowObject.id)
                        
                        if viewModel.exersiseModules[moduleID].setRows[rowObject.id].prevouslyChecked == false {
                            
                            viewModel.restAddToTime(step: 1, time: 120)
                        }
                        viewModel.setPrevouslyChecked(exersiseModuleID: moduleID, RowID: rowObject.id, state: true)
                    }

   

                    HapticManager.instance.impact(style: .heavy)
                    
                }
                .frame(width: getScreenBounds().width * 0.1, height: getScreenBounds().height * 0.045)
            }


            
            
        }
    }
}




