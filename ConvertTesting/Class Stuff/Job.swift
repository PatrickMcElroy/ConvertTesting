//
//  Job.swift
//  ConvertTesting
//
//  Created by Patrick McElroy on 5/28/21.
//

import Foundation
import SwiftUI
import CoreLocation

struct Job: Hashable, Codable, Identifiable {
    let id = UUID()
    var installationDate: String
    var name: String
    var address: String
    var sortDate: Int = 0
    var componentList: [Component] = components
    private enum CodingKeys : String, CodingKey {
            case installationDate = "Installation Date"
            case name = "Opportunity Name"
            case address = "Mailing Address Line 1"
    }
    static func == (lhs: Job, rhs: Job) -> Bool {
        return lhs.id == rhs.id
    }
    static func < (lhs: Job, rhs: Job) -> Bool {
        if (lhs.sortDate < rhs.sortDate) {
            return true
        }
        return false
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
