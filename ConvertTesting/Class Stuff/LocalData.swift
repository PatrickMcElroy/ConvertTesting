//
//  LocalData.swift
//  ConvertTesting
//
//  Created by Patrick McElroy on 6/8/21.
//

import Foundation

class LocalData: ObservableObject {
    @Published var jobArr: [Job] = newJobs
}
