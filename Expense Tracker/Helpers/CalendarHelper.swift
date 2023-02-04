//
//  CalendarHelper.swift
//  Expense Tracker
//
//  Created by Ravshanbek Tursunbaev on 2023/02/03.
//

import Foundation

struct CalendarHelper{
    
    //MARK: - Properties
    
    private let calendar = Calendar(identifier: .gregorian)
    private var date = Date()
    private lazy var weekdayOfWeek:Int = {
        return weekDay()//sunday is 1 and saturday is 7
    }()
    private lazy var currentday:Int = {
        return currentDay()
    }()
    
    //MARK: - Day
    
    func currentDay()->Int{
        let components = calendar.dateComponents([.day], from: date)
        return components.day!
    }
    
    //MARK: - Week
    
    func weekDay()->Int {
        let components = calendar.dateComponents( [.weekday], from: date)
        return components.weekday!
    }
    
    mutating func currentWeek()->[Int]{
        
        var daysOfWeek:[Int] = []
        var remainDaysOfPreviousMonth:[Int] = []
        let firstDayOfWeek = currentday - (weekdayOfWeek-1)
        let lastDayOfWeek = firstDayOfWeek + 6
        if firstDayOfWeek > 0{
            daysOfWeek = Array(firstDayOfWeek...lastDayOfWeek)
        }else{
            let previousMonth = calendar.date(byAdding: .month, value: -1, to: date)!
            let daysOfMonth = daysInMonth(date: previousMonth)
            for number in 1...(firstDayOfWeek * (-1)){
                remainDaysOfPreviousMonth.append(daysOfMonth-number)
            }
            
            for number in 1...(7+(firstDayOfWeek)){
                daysOfWeek.append(number)
            }
        }
        remainDaysOfPreviousMonth = remainDaysOfPreviousMonth.sorted()
        daysOfWeek = remainDaysOfPreviousMonth + daysOfWeek
        return daysOfWeek
    }
    
    mutating func nextWeek(){
        let days = daysInMonth(date: date)
        let weeks = days/4
        self.date = calendar.date(byAdding: .weekday, value: 7, to: date)!
        print(date)
    }
    mutating func previousWeek(){
        self.date = calendar.date(byAdding: .weekday, value: -7, to: date)!
    }
    
    //MARK: - Month
    
     func monthString (date: Date)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: date)
    }

    func daysInMonth(date: Date)->Int {
        let range = calendar.range(of: .day, in: .month, for: date)
        return range!.count
    }

    func monthString(date: Date)->Int {
        let components = calendar.dateComponents( [.day], from: date)
        return components.day!
    }

    func firstDayOfMonth(date: Date)->Date {
        let components = calendar.dateComponents( [.year , .month], from: date)
        let yearAndMonth = calendar.date(from: components)
        return yearAndMonth!
    }

    
    
    //MARK: - Year
    
    func yearString(date: Date)-> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
   }
}
