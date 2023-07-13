//
//  TextFieldExtensions.swift
//  Luto
//
//  Created by Pierre Boulc'h on 06/07/2023.
//

import Foundation
import SwiftUI

struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .textFieldStyle(.plain)
            .colorMultiply(.gray)
            .padding(10)
            .tint(.gray)
            .foregroundColor(.black)
            .background(.white)
            .cornerRadius(20)
            .shadow(color: .accentColor, radius: 2)
            
    }
}

extension NSTextField {
        open override var focusRingType: NSFocusRingType {
                get { .none }
                set { }
        }
}

