//
//  main.swift
//  SimpleDomainModel
//
//  Created by Xinyue Chen on 10/17/17.
//  Copyright © 2017 Xinyue Chen. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
    return "I have been tested"
}

open class TestMe {
    open func Please() -> String {
        return "I have been tested"
    }
}

protocol CustomStringConvertible {
    var description : String { get }
}

protocol Mathematics {
    func add(_: Money) -> Money
    func subtract(_: Money) -> Money
}

extension Double {
    var USD: Money {
        return Money(amount: Int(self), currency: "USD")
    }
    var EUR: Money {
        return Money(amount: Int(self), currency: "EUR")
    }
    var GBP: Money {
        return Money(amount: Int(self), currency: "GBP")
    }
    var YEN: Money {
        return Money(amount: Int(self), currency: "YEN")
    }
}

////////////////////////////////////
// Money
//
public struct Money: CustomStringConvertible, Mathematics {
    public var amount : Int
    public var currency : String
    
    public var description: String {
        return "\(currency)\(Double(amount))"
    }
    
    init(amount: Int, currency: String) {
        self.amount = amount
        self.currency = currency
    }
    
    public func convert(_ to: String) -> Money {
        if self.currency == "USD" {
            switch to {
            case "USD": return self
            case "GBP": return Money(amount: self.amount / 2, currency: "GBP")
            case "EUR": return Money(amount: Int(Double(self.amount) * 1.5), currency: "EUR")
            case "CAN": return Money(amount: Int(Double(self.amount) * 1.25), currency: "CAN")
            default:
                print("Don't know the corresponding exchange rate.")
                return self
            }
        } else if (self.currency == "GBP") {
            switch to {
            case "GBP": return self
            case "USD": return Money(amount: self.amount * 2, currency: "USD")
            default:
                print("Don't know the corresponding exchange rate.")
                return self
            }
        } else if (self.currency == "EUR") {
            switch to {
            case "EUR": return self
            case "USD": return Money(amount: Int(Double(self.amount) / 1.5), currency: "USD")
            default:
                print("Don't know the corresponding exchange rate.")
                return self
            }
        } else if (self.currency == "CAN") {
            switch to {
            case "CAN": return self
            case "USD": return Money(amount: Int(Double(self.amount) / 1.25), currency: "USD")
            default:
                print("Don't know the corresponding exchange rate.")
                return self
            }
        } else {
            print("Unknown currency")
            return self
        }
    }
    
    public func add(_ to: Money) -> Money {
        if self.currency == to.currency {
            return Money(amount: self.amount + to.amount, currency: to.currency)
        } else {
            return to.add(_:self.convert(to.currency))
        }
    }
    public func subtract(_ from: Money) -> Money {
        if self.currency == from.currency {
            return Money(amount: from.amount - self.amount, currency: from.currency)
        } else {
            return self.convert(from.currency).subtract(_:from)
        }
    }
}

////////////////////////////////////
// Job
//
open class Job: CustomStringConvertible {
    fileprivate var title : String
    fileprivate var type : JobType
    
    public var description: String {
        var str = "\(title), "
        switch self.type {
            case .Hourly(let num): str += "\(num) per hour"
            case .Salary(let num): str += "\(num) per year"
        }
        return str
    }
    
    public enum JobType {
        case Hourly(Double)
        case Salary(Int)
    }
    
    public init(title : String, type : JobType) {
        self.title = title
        self.type = type
    }
    
    open func calculateIncome(_ hours: Int) -> Int {
        switch self.type {
            case .Hourly(let num): return Int(num * Double(hours))
            case .Salary(let num): return num
        }
    }
    
    open func raise(_ amt : Double) {
        switch self.type {
            case .Hourly(let num):
                self.type = JobType.Hourly(num + amt)
            case .Salary(let num):
                self.type = JobType.Salary(num + Int(amt))
        }
    }
}

////////////////////////////////////
// Person
//
open class Person: CustomStringConvertible {
    open var firstName : String = ""
    open var lastName : String = ""
    open var age : Int = 0
    
    public var description: String {
        var jobStr = ""
        var spouseStr = ""
        if self._job != nil {
            jobStr = "works as \(self._job!.description)"
        } else {
            jobStr = "no job"
        }
        if self._spouse != nil {
            spouseStr = "spouse: \(self._spouse!.firstName) \(self._spouse!.lastName)"
        } else {
            spouseStr = "no spouse"
        }
        return "\(firstName) \(lastName), \(age), \(jobStr), \(spouseStr)"
    }
    
    fileprivate var _job : Job? = nil
    open var job : Job? {
        get {
            return _job
        }
        set(value) {
            if self.age >= 16 {
                self._job = value
            }
        }
    }
    
    fileprivate var _spouse : Person? = nil
    open var spouse : Person? {
        get {
            return _spouse
        }
        set(value) {
            if self.age >= 18 {
                self._spouse = value
            }
        }
    }
    
    public init(firstName : String, lastName: String, age : Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.age = age
    }
    
    
    open func toString() -> String {
        return "[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job) spouse:\(spouse)]"
    }
}

////////////////////////////////////
// Family
//
open class Family: CustomStringConvertible {
    fileprivate var members : [Person] = []
    public var description: String {
        var intro = "\(members.count) family members:"
        for person in members {
            intro += " \(person.firstName) \(person.lastName)"
        }
        return intro
    }
    public init(spouse1: Person, spouse2: Person) {
        if (spouse1._spouse == nil && spouse2._spouse == nil) {
            members.append(spouse1)
            members.append(spouse2)
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
        }
    }
    
    open func haveChild(_ child: Person) -> Bool {
        if members[0].age > 21 || members[1].age > 21 {
            members.append(child)
            return true
        } else {
            return false
        }
    }
    
    open func householdIncome() -> Int {
        var income = 0
        for person in members {
            if person.job != nil {
                income += person.job!.calculateIncome(50 * 5 * 8)
            }
        }
        return income
    }
}





