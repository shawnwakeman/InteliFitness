//
//  CostomTFKeyboard.swift
//  NutrimalA
//
//  Created by Shawn Wakeman on 4/2/23.
//

import SwiftUI


extension View {
    @ViewBuilder
    func inputView<Content: View>(for textField: UITextField, @ViewBuilder content: @escaping () -> Content) -> some View {
        self
            .background {
                SetTFKeyboard(textField: textField, keyboardContent: content())
            }
    }
}

fileprivate struct SetTFKeyboard<Content: View>: UIViewRepresentable {
    var textField: UITextField
    var keyboardContent: Content
    @State private var hostingController: UIHostingController<Content>?
    
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            if textField.inputView == nil {
                hostingController = UIHostingController(rootView: keyboardContent)
                hostingController?.view.backgroundColor = UIColor(Color("DBblack"))
                
                let size : CGSize = CGSize(width: hostingController?.view.intrinsicContentSize.width ?? .zero, height: (hostingController?.view.intrinsicContentSize.height ?? .zero) + 50 )
                hostingController?.view.frame = .init(origin: .zero, size: size )
                
                textField.inputView = hostingController?.view
            } else {
                hostingController?.rootView = keyboardContent
            }
        }
    }
}

struct CostomTFKeyboard_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutLogView()
    }
}


fileprivate extension UIView {
    var allSubViews: [UIView] {
        
        return subviews.flatMap { [$0] + $0.subviews}
    }
    
    var findTextField: UITextField? {
        if let textField = allSubViews.first(where: {view in view is UITextField
        }) as? UITextField {
            return textField
        }
        
        return nil
    }
}
