//
//  JobTests.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import XCTest

import SimpleDomainModel

class JobTests: XCTestCase {
  
  func testCreateSalaryJob() {
    let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
    XCTAssert(job.calculateIncome(50) == 1000)
  }

  func testCreateHourlyJob() {
    let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
    XCTAssert(job.calculateIncome(10) == 150)
  }
  
  func testSalariedRaise() {
    let job = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
    XCTAssert(job.calculateIncome(50) == 1000)

    job.raise(1000)
    XCTAssert(job.calculateIncome(50) == 2000)
  }
  
  func testHourlyRaise() {
    let job = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
    XCTAssert(job.calculateIncome(10) == 150)
    
    job.raise(1.0)
    XCTAssert(job.calculateIncome(10) == 160)
  }
  
    func testJobDescription() {
        let job1 = Job(title: "Janitor", type: Job.JobType.Hourly(15.0))
        XCTAssert(job1.description == "Janitor, 15.0 per hour")
        
        job1.raise(1.0)
        XCTAssert(job1.description == "Janitor, 16.0 per hour")
        
        let job2 = Job(title: "Guest Lecturer", type: Job.JobType.Salary(1000))
        XCTAssert(job2.description == "Guest Lecturer, 1000 per year")
        
        job2.raise(1000)
        XCTAssert(job2.description == "Guest Lecturer, 2000 per year")
    }
}
