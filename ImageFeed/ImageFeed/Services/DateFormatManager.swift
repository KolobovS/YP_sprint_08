//
//  DateFormatManager.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 05.03.2024.
//

import Foundation

final class DateFormatManager {
    static let shared = DateFormatManager()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    private let iso8601DateFormatter = ISO8601DateFormatter()
    
    private init() { }
    
    func dateToString(_ date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func iso8601Date(_ string: String) -> Date? {
        return iso8601DateFormatter.date(from: string)
    }
}
