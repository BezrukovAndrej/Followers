//
//  Date + Extensions.swift
//  GithubFollowers
//
//  Created by Andrey Bezrukov on 05.05.2024.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: self)
    }
}
