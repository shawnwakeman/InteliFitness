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
            
            lbsTextFieldView(rowObject: rowObject)
            

            
            HStack{

                repTextFieldView(rowObject: rowObject)
                repMetricView(rowObject: rowObject, viewModel: viewModel, moduleID: moduleID)
                
                
            }
            .frame(width: 80, height: 40)
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
            TextHelvetica(content: String(rowObject.setIndex), size: 21)
                       .padding()
                       .frame(width: 55, height: 40)
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
                                .frame(width: 140, height: 40)
                                .foregroundColor(Color("GrayFontOne"))
                                .background(.clear)
            }

            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
            
            
        }
    }
    
    struct lbsTextFieldView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow

        @State private var lbsTextField: String = ""
        var body: some View {
            TextField("", text: $lbsTextField, prompt: Text(rowObject.weightPlaceholder).foregroundColor(Color("GrayFontTwo")))
                .keyboardType(.decimalPad)
                .autocorrectionDisabled(true)
                .font(.custom("SpaceGrotesk-Medium", size: 21))
                .foregroundColor(Color("WhiteFontOne"))
                .frame(width: 75, height: 40)
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
                .onTapGesture {
                    HapticManager.instance.impact(style: .rigid)
                }

            Divider()
                .frame(width: borderWeight)
                .overlay(Color("BorderGray"))
            
            
        }
    }
    
    struct repTextFieldView: View {
        var rowObject: WorkoutLogModel.ExersiseSetRow

        @State private var repsTextField: String = ""
        var body: some View {
            TextField("", text: $repsTextField, prompt: Text(rowObject.repsPlaceholder).foregroundColor(Color("GrayFontTwo")))
                    .keyboardType(.numberPad)
                    .autocorrectionDisabled(true)
                    .font(.custom("SpaceGrotesk-Medium", size: 21))
                    .foregroundColor(Color("WhiteFontOne"))
                    .frame(minWidth: 40, minHeight: 40)
                    .background(.clear)
                    .multilineTextAlignment(.center)
                    .background(Color("DDB"))
                    .onReceive(Just(repsTextField)) { newValue in
                        var filtered = newValue.filter { "0123456789".contains($0) }
                        if filtered.count > 2 {
                            // If the filtered string contains more than two digits, limit it to the first two.
                            filtered = String(filtered.prefix(2))
                        }
                        repsTextField = filtered
                    }
                    .onTapGesture {
                        HapticManager.instance.impact(style: .rigid)
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
                            .frame(width: 30)
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                HapticManager.instance.impact(style: .rigid)
                                viewModel.setPopUpState(state: true, popUpId: "popUpRPE")
                                viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id, popUpId: "popUpRPE")

                            }}, label: {
                                Capsule()
                                    .strokeBorder(Color("LinkBlue"), lineWidth: borderWeight)
                                    .padding(.vertical, 9.0)
                                .frame(width: 30)})
                        
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
                            .frame(width: 30)
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                HapticManager.instance.impact(style: .rigid)
                                viewModel.setPopUpState(state: true, popUpId: "popUpRPE")
                                viewModel.setPopUpCurrentRow(exersiseModuleID: moduleID, RowID: rowObject.id, popUpId: "popUpRPE")
                            }}, label: {
                                Capsule()
                                    .strokeBorder(Color("LinkBlue"), lineWidth: borderWeight)
                                    .padding(.vertical, 9.0)
                                .frame(width: 30)})
                        
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




