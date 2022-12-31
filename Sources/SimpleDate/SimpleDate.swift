//
//  SimpleDate.swift
//  Namico
//
//  Created by Nazariy Vysokinskyi on 10.08.2021.
//

import Foundation

public struct SimpleDate {
    let dayNumber: Int
    
    private let monthAndDay: (month: Int, day: Int)
    private let isLeapYear: Bool
}

// MARK: - Public functions
public extension SimpleDate {
    func isInReach(with anotherDate: SimpleDate, by offset: Int) -> Bool {
        let removablePointFrom29thOfFebruary = (isLeapYear && (self <= anotherDate ? self...anotherDate : anotherDate...self).contains(SimpleDate(monthIndex: 2, dayIndex: 29, isLeapYear: true))) ? 1 : 0
        return (self - anotherDate) <= offset + removablePointFrom29thOfFebruary
    }
    
    func isSameMonth(as anotherDate: SimpleDate) -> Bool {
        return self.monthAndDay.month == anotherDate.monthAndDay.month
    }
}

// MARK: - Private functions
private extension SimpleDate {
    private static func getMonthsOffset(monthIndex: Int, isLeapYear: Bool) -> Int {
        var offset = 0
        
        for index in 1..<monthIndex {
            offset += Month(rawValue: index)!.monthOffset(isLeapYear: isLeapYear)
        }
        
        return offset
    }
}

// MARK: - Initializers
public extension SimpleDate {
    
    init(date: Date) {
        let components = Calendar.current.dateComponents([.day, .month], from: date)
        
        self.isLeapYear = { Calendar.current.range(of: .day, in: .year, for: date)!.upperBound == 366 }()
        self.dayNumber = components.day! + SimpleDate.getMonthsOffset(monthIndex: components.month!, isLeapYear: self.isLeapYear)
        self.monthAndDay = (components.month!, components.day!)
    }
    
    init(monthIndex: Int, dayIndex: Int, isLeapYear: Bool = { Calendar.current.range(of: .day, in: .year, for: Date())!.count == 366 }()) {
        var monthIndex = monthIndex
        var dayIndex = dayIndex
        
        // Check if month is real
        if monthIndex > 12 {
            monthIndex = 12
        } else if monthIndex < 1 {
            monthIndex = 1
        }
        
        // Check if day is real
        if dayIndex < 1 {
            dayIndex = 1
        } else {
            let numberOfDaysInMonth = Month(rawValue: monthIndex)!.monthOffset(isLeapYear: isLeapYear)
            if dayIndex > numberOfDaysInMonth {
                dayIndex = numberOfDaysInMonth
            }
        }
        
        self.dayNumber = dayIndex + SimpleDate.getMonthsOffset(monthIndex: monthIndex, isLeapYear: isLeapYear)
        self.monthAndDay = (monthIndex, dayIndex)
        self.isLeapYear = isLeapYear
    }
}

// MARK: - Month enum

private extension SimpleDate {
    private enum Month: Int, Codable {
        case january = 1, february, march, april, may, june, july, august, september, october, november, december
        
        func monthOffset(isLeapYear: Bool) -> Int {
            switch self {
                case .january, .march, .may, .july, .august, .october, .december:
                    return 31
                case .february:
                    return isLeapYear ? 29 : 28
                default:
                    return 30
            }
        }
    }
}

// MARK: - Protocol conformance
extension SimpleDate: Comparable {
    public static func < (lhs: SimpleDate, rhs: SimpleDate) -> Bool {
        lhs.dayNumber < rhs.dayNumber
    }
}

extension SimpleDate: Equatable {
    public static func == (lhs: SimpleDate, rhs: SimpleDate) -> Bool {
        lhs.monthAndDay == rhs.monthAndDay
    }
}

extension SimpleDate: Codable {
    enum CodingKeys: String, CodingKey {
        case dayNumber, month, day, isLeapYear
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        dayNumber = try values.decode(Int.self, forKey: .dayNumber)
        let month = try values.decode(Int.self, forKey: .month)
        let day = try values.decode(Int.self, forKey: .day)
        monthAndDay = (month, day)
        isLeapYear = try values.decode(Bool.self, forKey: .isLeapYear)
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(dayNumber, forKey: .dayNumber)
        try container.encode(monthAndDay.month, forKey: .month)
        try container.encode(monthAndDay.day, forKey: .day)
        try container.encode(isLeapYear, forKey: .isLeapYear)
    }
}

extension SimpleDate: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(dayNumber)
    }
}

extension SimpleDate: CustomDebugStringConvertible {
    public var debugDescription: String {
        "It's a \(dayNumber) day of the year"
    }
}

// MARK: - Custom operators

public extension SimpleDate {
    static func + (lhs: SimpleDate, rhs: SimpleDate) -> Int {
        lhs.dayNumber + rhs.dayNumber
    }
    
    static func - (lhs: SimpleDate, rhs: SimpleDate) -> Int {
        abs(lhs.dayNumber - rhs.dayNumber)
    }
}

