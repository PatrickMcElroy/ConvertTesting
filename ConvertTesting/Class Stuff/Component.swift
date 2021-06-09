//
//  Component.swift
//  ConvertTesting
//
//  Created by Patrick McElroy on 6/1/21.
//

import Foundation
import SwiftUI

struct Component: Identifiable {
    let id = UUID()
    var name: String
    var hasPhoto: Bool = false
    var isSelected: Bool = false
    var electricalComponent = false
}
