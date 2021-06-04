//
//  JobData.swift
//  ConvertTesting
//
//  Created by Patrick McElroy on 5/28/21.
//

import Foundation
import SwiftUI

extension Date {
    var month: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMMMMMMMMMMM"
        return dateFormatter.string(from: self)
    }
}

var jobs: [Job] = load("Jobs.json")
var newJobs = clean(jobs)

func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

func clean(_ jobs: [Job]) -> [Job] {
    var cleanJobs : [Job] = []
    for var job in jobs {
        if (job.installationDate != "") {
            var firstSlashIndex = job.installationDate.firstIndex(of: "/") ?? String.Index(utf16Offset: 0, in: job.installationDate)
            var afterFirstSlashIndex = job.installationDate.index(after: firstSlashIndex)
            var secondSlashIndex = job.installationDate.lastIndex(of: "/") ?? String.Index(utf16Offset: 0, in: job.installationDate)
            let jobDay = String(job.installationDate[afterFirstSlashIndex..<secondSlashIndex])
            let jobMonth = job.installationDate.substring(to: firstSlashIndex)
            let date = Date()
            let format = DateFormatter()
            format.dateFormat = "MM"
            var month = format.string(from: date)
            if (month.hasPrefix("0")) {
                month.removeFirst()
            }
            format.dateFormat = "dd"
            let day = format.string(from: date)
            format.dateFormat = "yyyy"
            let year = format.string(from: date)
            let sortDate = jobMonth + jobDay
            var intMonth = Int(jobMonth) ?? 0
            var intDay = Int(jobDay) ?? 0
            if (intMonth > Int(month)! || (intMonth == Int(month) && intDay >= Int(day)!)) { // TODO: figure out how to format new jobs (goes with having search feature)
                job.sortDate = intMonth * 1000 + intDay
                cleanJobs.append(job)
            }
        }
    }
    cleanJobs = cleanJobs.sorted(by: { $0.sortDate < $1.sortDate })
    return cleanJobs
}
