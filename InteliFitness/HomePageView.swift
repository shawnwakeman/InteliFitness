//
//  HomePageView.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/20/23.
//

import SwiftUI
import ActivityKit
import StoreKit

enum PageToLoad {
    case history
    case myExercises
}

struct LeftRoundedRectangle: Shape {
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.minY + radius), radius: radius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 90), clockwise: true)
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
        path.addArc(center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius), radius: radius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: true)
        
        return path
    }
}




struct HomePageView: View {
    @State private var displayingWorkoutTHing = false
    @StateObject var homePageViewModel = HomePageViewModel()
    @StateObject var workoutLogViewModel = WorkoutLogViewModel()
    @StateObject private var viewModel = AppTimer()
    @StateObject var storeKit = StoreKitManager()
    @State private var showPurchaseModal = false
    @Environment(\.presentationMode) private var presentationMode
    @State private var isNavigationBarHidden = true
    @State private var loadedPage: PageToLoad = .myExercises
    

    var body: some View {
        ZStack {
           
            
            NavigationStack {
           
                ZStack {
                    
                    if homePageViewModel.workoutLogModuleStatus == false {
                        P1View(loadedPage: $loadedPage, isNavigationBarHidden: $isNavigationBarHidden, showPurchaseModal: $showPurchaseModal, workoutLogViewModel: workoutLogViewModel, homePageViewModel: homePageViewModel, viewModel: viewModel)
                    }
                   
                   
                          
                    
                        
                        
                    VStack {
                        
                    }
              
                    
                    let offset = homePageViewModel.ongoingWorkout ? 0: 0.5
                    if viewModel.timeRemaining > 0 {
                        let _ = print(viewModel.timeRemaining)
                        PurchaseView(onPurchaseCompleted: {
                            withAnimation {
                                showPurchaseModal = false
                            }
                        }, storeKit: storeKit, timesUp: false, hasPerchased: false)
                        .position(x: getScreenBounds().width/2, y: showPurchaseModal ? getScreenBounds().height * 0.47 : getScreenBounds().height * (1.49 + offset))
                    } else {
                        if storeKit.purchasedProduts.count > 0 {
                            PurchaseView(onPurchaseCompleted: {
                                withAnimation {
                                    showPurchaseModal = false
                                }
                            }, storeKit: storeKit, timesUp: false, hasPerchased: true)
                            .position(x: getScreenBounds().width/2, y: showPurchaseModal ? getScreenBounds().height * 0.47 : getScreenBounds().height * (1.49 + offset))
                        } else {
                            PurchaseView(onPurchaseCompleted: {
                                
                            }, storeKit: storeKit, timesUp: true, hasPerchased: false)
                            .position(x: getScreenBounds().width/2, y: showPurchaseModal ? getScreenBounds().height * 0.47 : getScreenBounds().height * (1.49 + offset))
                        }
                            
                       
                      
                        
                            
                        
                        
                    }
                    
                    
                       
                    
                                
                    
                }
              

                
            }
            let offset = homePageViewModel.ongoingWorkout ? 0: 0.5
            WorkoutLogView(homePageVeiwModel: homePageViewModel, workoutLogViewModel: workoutLogViewModel)
                .position(x: getScreenBounds().width/2, y: homePageViewModel.workoutLogModuleStatus ? getScreenBounds().height * 0.6 : getScreenBounds().height * (1.49 + offset))
                .ignoresSafeArea()

           
       
         
                


              

           
               
           
            

        }
        .onAppear {
         
           
       
  
           
            if viewModel.timeRemaining < 1 {
                if storeKit.purchasedProduts.count < 0 {
                    showPurchaseModal = true
                }
                else {
                    showPurchaseModal = false
                }
                
            }
            
        }
        
        .onChange(of: viewModel.timeRemaining) {newValue in
            print(newValue)
            if newValue == 0 {
                withAnimation(.spring()) {
                    showPurchaseModal = true
                }
               
            }
            
            if storeKit.purchasedProduts.count > 0 {
                viewModel.timeRemaining = 0
            }
        }


       

    }
    
   
    
}
struct PurchaseView: View {
    let onPurchaseCompleted: () -> Void
    @State private var selectedType: Int = 2
    @ObservedObject var storeKit: StoreKitManager

   
    var timesUp: Bool
    var hasPerchased: Bool
    
    var body: some View {
        VStack {
            if hasPerchased {
                HStack {
                    TextHelvetica(content: "restore purchases", size: 17)
                        .bold()
                        .foregroundColor(Color("LinkBlue"))
                        .onTapGesture {
                            Task {
                                try? await AppStore.sync()
                            }
                            
                        }
                    Spacer()
                    Button {
                        if !timesUp {
                            onPurchaseCompleted()
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
                                .foregroundColor(Color("LinkBlue"))
                        }
                        
                            
                    }.frame(width: 50, height: 30)
                   
                }
                .padding()
                VStack {
                    
                    TextHelvetica(content: "Thank you for your purchase!", size: 30)
                        .foregroundColor(Color("LinkBlue"))
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    
                    TextHelvetica(content: "You Have Full Acsess to InteliFitness", size: 18)
                        .foregroundColor(Color("GrayFontOne"))
                        .multilineTextAlignment(.center)
                        .padding()
                        .padding(.bottom, 60)
                }
                
                Spacer()
                
            } else {
                VStack(alignment: .center) {
                    HStack {
                        TextHelvetica(content: "restore purchases", size: 17)
                            .bold()
                            .foregroundColor(Color("LinkBlue"))
                        Spacer()
                        Button {
                            onPurchaseCompleted()
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
                                    .foregroundColor(Color("LinkBlue"))
                            }
                            
                                
                        }.frame(width: 50, height: 30)
                    }
                    .padding()
                    TextHelvetica(content: "Continue Your InteliFitness Experience.", size: 30)
                        .foregroundColor(Color("LinkBlue"))
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                    if timesUp {
                        TextHelvetica(content: "Your 7-day free trial has ended. Choose a plan and continue to benefit from unlimited tracking and fitness insights.", size: 18)
                            .foregroundColor(Color("GrayFontOne"))
                            .multilineTextAlignment(.center)
                            .padding()
                            .padding(.bottom, 60)
                        
                        
                    } else {
                        TextHelvetica(content: "Your 7-day free trial is still active! Don't wait for the trial to end, upgrade your experience and continue tracking your progress without any limits.", size: 18)
                            .foregroundColor(Color("GrayFontOne"))
                            .multilineTextAlignment(.center)
                            .padding()
                            .padding(.bottom, 60)
                    }
                    
                    
                    HStack {
                     
                        
                        
                        
                    
                        VStack {
                            TextHelvetica(content: "All Accses", size: 20)
                                .foregroundColor(Color("WhiteFontOne"))
                                .bold()
                                .padding(.vertical, 3)
                            TextHelvetica(content: "24.99", size: 28)
                                .foregroundColor(Color("LinkBlue"))
                                .bold()
                                .padding(.vertical, 5)
                            TextHelvetica(content: "Billed once", size: 13)
                                .foregroundColor(Color("GrayFontOne"))
                                .bold()
                                .padding(.horizontal,11)
                                .padding(.vertical, 5)
                            
                        }
                        .padding(8)
                        .frame(width: getScreenBounds().width * 0.9)
                        .background(Color("DBblack"))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("BorderGray"), lineWidth: borderWeight + 0.5))
                  
                        
                        
                        
                  
                   
                       
                       
                        
                    }
                    .padding(.bottom, 10)
      
                    
                    
                    
                    Button {
                        
                        
                        
                        let products = storeKit.storeProducts
                        let product = products[0]
                        Task {
                            try await storeKit.purchase(product)
                        }
                    } label: {
                        
                            HStack {
                                Spacer()
                                TextHelvetica(content: "Get Full Accses To InteliFitness", size: 20)
                                    .foregroundColor(Color("WhiteFontOne"))
                                    .bold()
                                Spacer()
                            }
                            .padding(15)
                            .frame(width: getScreenBounds().width * 0.9)
                             .background(Color("DBblack"))
                             .cornerRadius(10)
                             .overlay(
                                 RoundedRectangle(cornerRadius: 10)
                                     .stroke(Color("LinkBlue"), lineWidth: borderWeight))
                           
                    }
                    .padding(.bottom, 50)
                    
                    HStack {
                        NavigationLink(destination: PrivacyPolicyView()) {
                                Text("Privacy Policy")
                                    .font(.system(size: 12))
                                    .foregroundColor(Color("LinkBlue"))
                                    .bold()
                            }

                        NavigationLink(destination: EULAView()) {
                            Text("End User License Agreement")
                                .font(.system(size: 12))
                                .foregroundColor(Color("LinkBlue"))
                                .bold()
                        }
                    }
                    
                        
                    
                }

                Spacer()
            }

        }

      
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .background(Color("MainGray"))
    }
}


struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            Text("""
                

                
                Privacy Policy

                Last updated: (6/21/2023)

                InteliFitness ("we", "our" or "us") operates the InteliFitness mobile application (the "Service").

                This page informs you of our policies regarding the collection, use, and disclosure of personal information when you use our Service.

                By using the Service, you agree to the collection and use of information in accordance with this policy.

                Information Collection And Use

                While using our Service, we do not collect any personal information about you. We respect your privacy and are committed to protecting it.

                Service Providers

                We do not transfer, sell, or share your information with third-party companies, individuals, or organizations. Since we do not collect any personal data, third parties do not have access to your data through our Service.

                Children’s Privacy

                Our Service does not address anyone under the age of 13 ("Children"). Since our Service does not collect personal data, we do not knowingly collect personally identifiable information from children under 13.

                Changes To This Privacy Policy

                We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page.

                You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.

                Contact Us

                If you have any questions about this Privacy Policy, please contact us:

                By email: wakemanshawn@gmail.com
                """)
                .padding()
        }
        .navigationTitle("Privacy Policy")
    }
}

struct EULAView: View {
    var body: some View {
        ScrollView {
            Text("""
                LICENSED APPLICATION END USER LICENSE AGREEMENT
                ===========================

                Apps made available through the App Store are licensed, not sold, to you. Your license to each App is subject to your prior acceptance of either this Licensed Application End User License Agreement (“Standard EULA”), or a custom end user license agreement between you and the Application Provider (“Custom EULA”), if one is provided. Your license to any Apple App under this Standard EULA or Custom EULA is granted by Apple, and your license to any Third Party App under this Standard EULA or Custom EULA is granted by the Application Provider of that Third Party App. Any App that is subject to this Standard EULA is referred to herein as the “Licensed Application.” The Application Provider or Apple as applicable (“Licensor”) reserves all rights in and to the Licensed Application not expressly granted to you under this Standard EULA.

                a. Scope of License: Licensor grants to you a nontransferable license to use the Licensed Application on any Apple-branded products that you own or control and as permitted by the Usage Rules. The terms of this Standard EULA will govern any content, materials, or services accessible from or purchased within the Licensed Application as well as upgrades provided by Licensor that replace or supplement the original Licensed Application, unless such upgrade is accompanied by a Custom EULA. Except as provided in the Usage Rules, you may not distribute or make the Licensed Application available over a network where it could be used by multiple devices at the same time. You may not transfer, redistribute or sublicense the Licensed Application and, if you sell your Apple Device to a third party, you must remove the Licensed Application from the Apple Device before doing so. You may not copy (except as permitted by this license and the Usage Rules), reverse-engineer, disassemble, attempt to derive the source code of, modify, or create derivative works of the Licensed Application, any updates, or any part thereof (except as and only to the extent that any foregoing restriction is prohibited by applicable law or to the extent as may be permitted by the licensing terms governing use of any open-sourced components included with the Licensed Application).

                b. Consent to Use of Data: You agree that Licensor may collect and use technical data and related information—including but not limited to technical information about your device, system and application software, and peripherals—that is gathered periodically to facilitate the provision of software updates, product support, and other services to you (if any) related to the Licensed Application. Licensor may use this information, as long as it is in a form that does not personally identify you, to improve its products or to provide services or technologies to you.

                c. Termination. This Standard EULA is effective until terminated by you or Licensor. Your rights under this Standard EULA will terminate automatically if you fail to comply with any of its terms.

                d. External Services. The Licensed Application may enable access to Licensor’s and/or third-party services and websites (collectively and individually, "External Services"). You agree to use the External Services at your sole risk. Licensor is not responsible for examining or evaluating the content or accuracy of any third-party External Services, and shall not be liable for any such third-party External Services. Data displayed by any Licensed Application or External Service, including but not limited to financial, medical and location information, is for general informational purposes only and is not guaranteed by Licensor or its agents. You will not use the External Services in any manner that is inconsistent with the terms of this Standard EULA or that infringes the intellectual property rights of Licensor or any third party. You agree not to use the External Services to harass, abuse, stalk, threaten or defame any person or entity, and that Licensor is not responsible for any such use. External Services may not be available in all languages or in your Home Country, and may not be appropriate or available for use in any particular location. To the extent you choose to use such External Services, you are solely responsible for compliance with any applicable laws. Licensor reserves the right to change, suspend, remove, disable or impose access restrictions or limits on any External Services at any time without notice or liability to you.

                e. NO WARRANTY: YOU EXPRESSLY ACKNOWLEDGE AND AGREE THAT USE OF THE LICENSED APPLICATION IS AT YOUR SOLE RISK. TO THE MAXIMUM EXTENT PERMITTED BY APPLICABLE LAW, THE LICENSED APPLICATION AND ANY SERVICES PERFORMED OR PROVIDED BY THE LICENSED APPLICATION ARE PROVIDED "AS IS" AND “AS AVAILABLE,” WITH ALL FAULTS AND WITHOUT WARRANTY OF ANY KIND, AND LICENSOR HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS WITH RESPECT TO THE LICENSED APPLICATION AND ANY SERVICES, EITHER EXPRESS, IMPLIED, OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES AND/OR CONDITIONS OF MERCHANTABILITY, OF SATISFACTORY QUALITY, OF FITNESS FOR A PARTICULAR PURPOSE, OF ACCURACY, OF QUIET ENJOYMENT, AND OF NONINFRINGEMENT OF THIRD-PARTY RIGHTS. NO ORAL OR WRITTEN INFORMATION OR ADVICE GIVEN BY LICENSOR OR ITS AUTHORIZED REPRESENTATIVE SHALL CREATE A WARRANTY. SHOULD THE LICENSED APPLICATION OR SERVICES PROVE DEFECTIVE, YOU ASSUME THE ENTIRE COST OF ALL NECESSARY SERVICING, REPAIR, OR CORRECTION. SOME JURISDICTIONS DO NOT ALLOW THE EXCLUSION OF IMPLIED WARRANTIES OR LIMITATIONS ON APPLICABLE STATUTORY RIGHTS OF A CONSUMER, SO THE ABOVE EXCLUSION AND LIMITATIONS MAY NOT APPLY TO YOU.

                f. Limitation of Liability. TO THE EXTENT NOT PROHIBITED BY LAW, IN NO EVENT SHALL LICENSOR BE LIABLE FOR PERSONAL INJURY OR ANY INCIDENTAL, SPECIAL, INDIRECT, OR CONSEQUENTIAL DAMAGES WHATSOEVER, INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF PROFITS, LOSS OF DATA, BUSINESS INTERRUPTION, OR ANY OTHER COMMERCIAL DAMAGES OR LOSSES, ARISING OUT OF OR RELATED TO YOUR USE OF OR INABILITY TO USE THE LICENSED APPLICATION, HOWEVER CAUSED, REGARDLESS OF THE THEORY OF LIABILITY (CONTRACT, TORT, OR OTHERWISE) AND EVEN IF LICENSOR HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. SOME JURISDICTIONS DO NOT ALLOW THE LIMITATION OF LIABILITY FOR PERSONAL INJURY, OR OF INCIDENTAL OR CONSEQUENTIAL DAMAGES, SO THIS LIMITATION MAY NOT APPLY TO YOU. In no event shall Licensor’s total liability to you for all damages (other than as may be required by applicable law in cases involving personal injury) exceed the amount of fifty dollars ($50.00). The foregoing limitations will apply even if the above stated remedy fails of its essential purpose.

                g. You may not use or otherwise export or re-export the Licensed Application except as authorized by United States law and the laws of the jurisdiction in which the Licensed Application was obtained. In particular, but without limitation, the Licensed Application may not be exported or re-exported (a) into any U.S.-embargoed countries or (b) to anyone on the U.S. Treasury Department's Specially Designated Nationals List or the U.S. Department of Commerce Denied Persons List or Entity List. By using the Licensed Application, you represent and warrant that you are not located in any such country or on any such list. You also agree that you will not use these products for any purposes prohibited by United States law, including, without limitation, the development, design, manufacture, or production of nuclear, missile, or chemical or biological weapons.

                h. The Licensed Application and related documentation are "Commercial Items", as that term is defined at 48 C.F.R. §2.101, consisting of "Commercial Computer Software" and "Commercial Computer Software Documentation", as such terms are used in 48 C.F.R. §12.212 or 48 C.F.R. §227.7202, as applicable. Consistent with 48 C.F.R. §12.212 or 48 C.F.R. §227.7202-1 through 227.7202-4, as applicable, the Commercial Computer Software and Commercial Computer Software Documentation are being licensed to U.S. Government end users (a) only as Commercial Items and (b) with only those rights as are granted to all other end users pursuant to the terms and conditions herein. Unpublished-rights reserved under the copyright laws of the United States.

                i. Except to the extent expressly provided in the following paragraph, this Agreement and the relationship between you and Apple shall be governed by the laws of the State of California, excluding its conflicts of law provisions. You and Apple agree to submit to the personal and exclusive jurisdiction of the courts located within the county of Santa Clara, California, to resolve any dispute or claim arising from this Agreement. If (a) you are not a U.S. citizen; (b) you do not reside in the U.S.; (c) you are not accessing the Service from the U.S.; and (d) you are a citizen of one of the countries identified below, you hereby agree that any dispute or claim arising from this Agreement shall be governed by the applicable law set forth below, without regard to any conflict of law provisions, and you hereby irrevocably submit to the non-exclusive jurisdiction of the courts located in the state, province or country identified below whose law governs:

                If you are a citizen of any European Union country or Switzerland, Norway or Iceland, the governing law and forum shall be the laws and courts of your usual place of residence.

                Specifically excluded from application to this Agreement is that law known as the United Nations Convention on the International Sale of Goods.
                """)
                .padding()
        }
        .navigationTitle("EULA")
    }
}



struct P1View: View {
    @Binding var loadedPage: PageToLoad
    @Binding var isNavigationBarHidden: Bool
    @Binding var showPurchaseModal: Bool
    @ObservedObject var workoutLogViewModel: WorkoutLogViewModel
    @ObservedObject var homePageViewModel : HomePageViewModel
    @ObservedObject var viewModel : AppTimer
    @State private var selectedDestination: AnyView? = nil
    @AppStorage("userName") var savedName: String = ""

    
    var body: some View {
        ZStack {
            VStack(spacing: -3) {
                HStack(spacing: 0) {
                    Spacer()
                    HStack {
                        
                        if viewModel.timeRemaining > 0 {
                            let hours = viewModel.timeRemaining / 3600
                            let minutes = (viewModel.timeRemaining / 60) - (hours * 60)
                            let seconds = viewModel.timeRemaining % 60

                            if hours > 24 {
                                TextHelvetica(content: "\(hours / 24) days", size: 18)
                                    .foregroundColor(Color("WhiteFontOne"))
                                    .fontWeight(.bold)
                            }
                            else if hours < 1 {
                                TextHelvetica(content: "\(minutes):\(String(format: "%02d", seconds))", size: 18)
                                    .foregroundColor(Color("WhiteFontOne"))
                                    .fontWeight(.bold)
                            }
                            else{
                                TextHelvetica(content: "\(String(hours)):\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))", size: 18)
                                    .foregroundColor(Color("LinkBlue"))
                                    .fontWeight(.bold)
                            }

                        } else {
                            Image(systemName: "star")
                                .foregroundColor(Color("LinkBlue"))
                                .bold()
                        }
                    
                        
                        
                   
                  
                          
                            
                    }
               
                    .opacity(viewModel.timeRemaining < 0 ? 0: 100)
                    .padding(7)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showPurchaseModal.toggle()
                        }
                        
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                           
                            .strokeBorder(Color("LinkBlue").opacity(viewModel.timeRemaining < 0 ? 0: 100), lineWidth: borderWeight + 0.1))
                  
                     
                  
                }
               
                
                HStack {
                    TextHelvetica(content: "Welcome Back", size: 28)
                        .foregroundColor(Color("GrayFontOne"))
                    Spacer()
                }
                HStack {
                    TextHelvetica(content: savedName, size: 40)
                        .foregroundColor(Color("WhiteFontOne"))
                        .bold()
                    Spacer()
                }
               
                VStack(spacing: 12) {
                    Rectangle()
                        .frame(height: getScreenBounds().height * 0.00)
                        .foregroundColor(.clear)
                    ZStack {
                        let curColor = Color("LinkBlue")
                              
                        let curGradient = LinearGradient(
                                    gradient: Gradient (
                                        colors: [
                                            
                                            curColor.opacity(0.5),
                                            curColor.opacity(0.2),
                                            curColor.opacity(0.05),
                                        ]
                                    ),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                        RoundedRectangle(cornerRadius: 13)
                            .fill(
                                curGradient
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 13)
                                    .strokeBorder(Color("BorderGray"), lineWidth: borderWeight + 0.5)
                            )
                          
                        
                        VStack {
// del
                            Spacer()
                            HStack {
                                if let workout = homePageViewModel.upcomingWorkout() {
                                    VStack(alignment: .leading) {
                                        TextHelvetica(content: "Up Next, Today", size: 28)
                                            .foregroundColor(Color("GrayFontOne"))
                                        
                                        TextHelvetica(content: workout.name, size: 43)
                                            .foregroundColor(Color("WhiteFontOne"))
                                            .bold()
                                    }
                                } else {
                                    VStack(alignment: .leading) {
                                        TextHelvetica(content: "Quick Start", size: 28)
                                            .foregroundColor(Color("GrayFontOne"))
                                        
                                        TextHelvetica(content: "Blank Workout", size: 43)
                                            .foregroundColor(Color("WhiteFontOne"))
                                            .bold()
                                    }
                                }
                                
                                Spacer()
                            }
                       

                        }
                        
                        .padding(.all)
                        
                    }
                   
                    .onTapGesture {
                        HapticManager.instance.impact(style: .rigid)
                        if let workout = homePageViewModel.upcomingWorkout() {
                            let formattedData = HomePageModel.Workout(id: UUID(), WorkoutName: workout.name, exercises: workout.exercises, category: "not Important", competionDate: Date())
                            self.selectedDestination = AnyView(workoutLauncher(viewModel: homePageViewModel, workoutLogViewModel: workoutLogViewModel, isNavigationBarHidden: $isNavigationBarHidden, workout: formattedData, isForAddingToSchedule: false))
                            workoutLogViewModel.workoutName = formattedData.WorkoutName
                        
                        
                        } else {
                            let formattedData = HomePageModel.Workout(id: UUID(), WorkoutName: "Workout Name", exercises: [], category: "not Important", competionDate: Date())
                            
                            homePageViewModel.setOngoingState(state: false)
                            workoutLogViewModel.loadWorkout(workout: formattedData)
                            workoutLogViewModel.workoutName = formattedData.WorkoutName
                            withAnimation(.spring()) {
                                
                                homePageViewModel.setOngoingState(state: true)
                                
                                homePageViewModel.setWorkoutLogModuleStatus(state: true)
                       
                            }
                           
                        }
                       
                      
                    }
                   
                    ZStack {
                        RoundedRectangle(cornerRadius: 13)
                            .foregroundColor(Color("MainGray").opacity(0.4))
                            .frame(height: getScreenBounds().height * 0.08)
                         
                        HStack(spacing: -0) {
                            ZStack {
                             
                                Rectangle()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .cornerRadius(13, corners: [.topLeft, .bottomLeft])
                                    .foregroundColor(Color("MainGray"))
                                    
                                
                                    
                            }
                            .frame(width: getScreenBounds().width * 0.23)
                      
                            Divider()
                            
                                .frame(width: borderWeight)
                                .overlay(Color("BorderGray"))
                            TextHelvetica(content: "Schedule", size: 27)
                                .padding(.horizontal, 15)
                                .foregroundColor(Color("WhiteFontOne"))
                            
                            Spacer()
                          
                        }.frame(height: getScreenBounds().height * 0.08)
                    }
                    
                    .overlay(
                        RoundedRectangle(cornerRadius: 13)
                            .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                   
                    .onTapGesture {
                        HapticManager.instance.impact(style: .rigid)
             
                        self.selectedDestination = AnyView(WeeklyScheduleView(schedule: homePageViewModel, viewModel: workoutLogViewModel, isNavigationBarHidden: $isNavigationBarHidden))
                      
                    }
                   
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 13)
                            .foregroundColor(Color("MainGray").opacity(0.4))
                            .frame(height: getScreenBounds().height * 0.08)
                         
                        HStack(spacing: 0) {
                            
                            ZStack {
                             
                                Rectangle()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .cornerRadius(13, corners: [.topLeft, .bottomLeft])
                                    .foregroundColor(Color("MainGray"))
                                    
                                
                            }
                            .frame(width: getScreenBounds().width * 0.23)
                     
                            Divider()
                            
                                .frame(width: borderWeight)
                                .overlay(Color("BorderGray"))
                            TextHelvetica(content: "Workouts", size: 27)
                                .foregroundColor(Color("WhiteFontOne"))
                                .padding(.horizontal, 15)
                            
                            Spacer()
                          
                        }.frame(height: getScreenBounds().height * 0.08)
                    }
                    .overlay(
                        RoundedRectangle(cornerRadius: 13)
                            .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                    .onTapGesture {
                        HapticManager.instance.impact(style: .rigid)
                        self.selectedDestination = AnyView(MyWorkoutsPage(viewModel: homePageViewModel, workoutLogViewModel: workoutLogViewModel, isNavigationBarHidden: $isNavigationBarHidden, isForAddingToSchedule: false))

                        
                    }
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 13)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 13)
                                        .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                                .foregroundColor(Color("MainGray"))
                            VStack(alignment: .leading) {
                                Spacer()
                                TextHelvetica(content: "History", size: 20)
                  
                                    .padding(.vertical, 5)
                                    .padding(.leading, -30)
                                    .foregroundColor(Color("WhiteFontOne"))
                            }
             
                        }
                        .onTapGesture {
                            HapticManager.instance.impact(style: .rigid)
                            self.selectedDestination = AnyView(HistoryPage(viewModel: homePageViewModel, isNavigationBarHidden: $isNavigationBarHidden))
                        }
                        ZStack {

                            RoundedRectangle(cornerRadius: 13)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 13)
                                        .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                                .foregroundColor(Color("MainGray"))

                            VStack(alignment: .leading) {
                                Spacer()

                                TextHelvetica(content: "Exercises", size: 20)
                  
        
                                    .padding(.leading, -10)
                                    .padding(.bottom, 5)
                                    .foregroundColor(Color("WhiteFontOne"))
                            }

                         
                        }
                        .onTapGesture {
                            HapticManager.instance.impact(style: .rigid)
                            self.selectedDestination = AnyView(MyExercisesPage(viewModel: homePageViewModel, isNavigationBarHidden: $isNavigationBarHidden))
                        }
                       
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 13)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 13)
                                        .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                                .foregroundColor(Color("MainGray"))
                            VStack(alignment: .leading) {
                                Spacer()
                                TextHelvetica(content: "Stats", size: 20)
                  
                                    .padding(.vertical, 5)
                                    .padding(.leading, -50)
                                    .foregroundColor(Color("WhiteFontOne"))
                            }
                        }
                        
                        .onTapGesture {
                            HapticManager.instance.impact(style: .rigid)
                            let data = homePageViewModel.calculateStats()
                            let asd = homePageViewModel.calculateCategoryVolumes(for: homePageViewModel.exersises)
//                            let _ = print(asd)
                            self.selectedDestination = AnyView(Profile(viewModel: homePageViewModel, isNavigationBarHidden: $isNavigationBarHidden, profileData: data))
                        }
                    }
                    .frame(maxHeight: getScreenBounds().height * 0.14)
                    
                }

                if homePageViewModel.ongoingWorkout {
                    Rectangle()
                        .frame(height: getFrameHeight())
                        .foregroundColor(.clear)
                }
             
                
            } .padding(.all)
                .background(Color("DBblack"))
        }
        
        .onAppear {
            let screenHeight = UIScreen.main.bounds.height

        }

        
        .background(
            NavigationLink(
                "",
                destination: selectedDestination ?? AnyView(EmptyView()),
                isActive: Binding(get: { selectedDestination != nil }, set: { if !$0 { selectedDestination = nil } })
            )
            .opacity(0)
        )
        .navigationBarTitle(" ")
        .navigationBarHidden(self.isNavigationBarHidden)
        .onAppear {
            self.isNavigationBarHidden = true
        }
   
         
    }
}

func getFrameHeight() -> CGFloat {
    let screenHeight = UIScreen.main.bounds.height


    // These screen height values are approximate and could be adjusted to fit your needs
    if screenHeight <= 700 { // For smaller devices like iPhone SE
        return screenHeight * 0.12
    } else {
        return screenHeight * 0.085
    }
}


//struct P2View: View {
//
//    @Binding var asdh: Bool
//    @ObservedObject var viewModel: HomePageViewModel
//    var pageToSave: PageToLoad
//    var body: some View {
//
//        switch pageToSave {
//            case .history:
//                HistoryPage(viewModel: viewModel, asdh: $asdh)
//                // Load the history page
//            case .myExercises:
//
//                MyExercisesPage(viewModel: viewModel, asdh: $asdh)
//                // Load the my exercises page
//        }
//    }
//}

struct HomePage_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
            .previewDevice("iPhone 13 Mini")
        HomePageView()
            .previewDevice("iPad Pro (11-inch)")
    }
}


struct OnboardingView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var hasOnboarded: Bool
    
    var body: some View {
        
        let curColor = Color("LinkBlue")
              
        let curGradient = LinearGradient(
                    gradient: Gradient (
                        colors: [
                            
                            curColor.opacity(0.5),
                            curColor.opacity(0.2),
                            curColor.opacity(0.05),
                        ]
                    ),
                    startPoint: .top,
                    endPoint: .bottom
                )
        TabView {
            OnboardingViewPage1(image: "1.circle", title: "Welcome", description: "To help you stick to your workouts and optimize rest periods, make sure you have notifications enabled.", description2: "Thank you for installing InteliFitness! Please start by telling us your first name above.")
                               

            OnboardingViewPage2(image: "2.circle", title: "Your Personalized Fitness Tracker!", description: "InteliFitness is designed to help you keep track of your workouts, offering rich insights into your performance data. InteliFitness' goal is to empower you with information that will help you improve, one workout at a time.")
            VStack {
                OnboardingViewPage3(image: "3.circle", title: "Plan, Track, Improve!", description: "To maximize the benefits of InteliFitness, utilize the scheduler to plan your ideal workouts, leverage the tracker to optimize your exercise sessions, and use the progress charts to visualize your improvements over time.")
                Button(action: {
                    dismiss()
                    hasOnboarded = true
                }) {
                    Text("Start your 7 Day Free Trial")
                        .bold()
                        .frame(width: 280, height: 45)
                        .background(Color("LinkBlue"))
                        .foregroundColor(Color("WhiteFontOne"))
                        .cornerRadius(10)
                }
                .padding(.top, 50)
            }
        }
        .background(curGradient)
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .ignoresSafeArea(.keyboard)
    }
}

struct OnboardingViewPage1: View {
    var image: String
    var title: String
    var description: String
    var description2: String = ""
    @State private var name: String = ""
    @AppStorage("userName") var savedName: String = ""

    var body: some View {
        VStack {
            Image("onboarder1")
                .resizable()
                .scaledToFit()
                .frame(height: 200)
                .padding(.bottom, 50)
            
           
           

            TextHelvetica(content: title, size: 25)
                .bold()
                .foregroundColor(Color("WhiteFontOne"))
                .multilineTextAlignment(.center)
            
            if title == "Welcome" {
                
  
                
                
                TextField("Enter your name", text: $name, onCommit: {
                    savedName = name
                })
                .font(.subheadline)
                .background(Color("DBblack"))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .strokeBorder(Color("BorderGray"), lineWidth: borderWeight))
                   .padding(.horizontal, 50)
                   .padding(.top, 20)
                   .textFieldStyle(RoundedBorderTextFieldStyle())
                   .keyboardType(.default)
                   .submitLabel(.done)
            }
            
            TextHelvetica(content: description2, size: 15)
                .foregroundColor(Color("GrayFontOne"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
                .padding(.top, 20)
  
            
            

            TextHelvetica(content: description, size: 13)
                .foregroundColor(Color("GrayFontOne"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
                .padding(.top, 20)
        }

    }
}


struct OnboardingViewPage2: View {
    var image: String
    var title: String
    var description: String
    var description2: String = ""
  

    var body: some View {
        VStack {

            let data = [
                DataPoint(intelligence: 10, funny: 4, empathy: 7, veracity: 3, selflessness: 1, authenticity: 8, color: Color("LinkBlue"))
            ]
           
        

            RadarChartView(width: getScreenBounds().width * 0.67, MainColor: Color("WhiteFontOne"), SubtleColor: Color.init(white: 0.6), quantity_incrementalDividers: 0, dimensions: dimensions, data: data)
                .padding(.all)
                    .background(Color("MainGray"))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("BorderGray"), lineWidth: borderWeight))
                    .padding()
           

            TextHelvetica(content: title, size: 25)
                .bold()
                .foregroundColor(Color("WhiteFontOne"))
                .multilineTextAlignment(.center)
            
            TextHelvetica(content: description2, size: 15)
                .foregroundColor(Color("GrayFontOne"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
                .padding(.top, 20)
  
            


            TextHelvetica(content: description, size: 15)
                .foregroundColor(Color("GrayFontOne"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
                .padding(.top, 20)
        }
    }
}


struct OnboardingViewPage3: View {
    var image: String
    var title: String
    var description: String
    var description2: String = ""


    var body: some View {
        VStack {

   
          

            TextHelvetica(content: title, size: 25)
                .bold()
                .foregroundColor(Color("WhiteFontOne"))
                .multilineTextAlignment(.center)
            
            TextHelvetica(content: description2, size: 15)
                .foregroundColor(Color("GrayFontOne"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
                .padding(.top, 20)
  
            


            TextHelvetica(content: description, size: 15)
                .foregroundColor(Color("GrayFontOne"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 50)
                .padding(.top, 20)
        }
    }
}
