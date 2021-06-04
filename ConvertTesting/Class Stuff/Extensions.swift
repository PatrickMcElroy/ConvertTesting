//
//  Extensions.swift
//  ConvertTesting
//
//  Created by Patrick McElroy on 6/4/21.
//

import Foundation
import SwiftUI

extension View {
    
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
