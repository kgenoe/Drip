//
//  HealthKitManager.swift
//  DripSimpleHydration
//
//  Created by Kyle on 2018-01-04.
//  Copyright © 2018 Kyle. All rights reserved.
//

import Foundation
import HealthKit

class HealthKitManager: NSObject {
    
    //MARK: - Shared Instance
    static let shared = HealthKitManager()
    
    //MARK: - Properties
    private var store: HKHealthStore
    
    //MARK: - Life Cycle
    private override init() {
        store = HKHealthStore()
    }
    
    
    //MARK: - Access and Authorization
    static var isHealthKitAvailable: Bool {
        return HKHealthStore.isHealthDataAvailable()
    }
    
    func requestAuthorization( _ completionHandler: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let healthDataToRead: Set = [
            HKObjectType.quantityType(forIdentifier: .dietaryWater)!
        ]
        let healthDataToWrite: Set = [
            HKObjectType.quantityType(forIdentifier: .dietaryWater)!
        ]
        store.requestAuthorization(toShare: healthDataToWrite, read: healthDataToRead) {(success, error) -> Void in
            completionHandler(success, error)
        }
    }
    
    
    //MARK: - Fetching
    func getDietaryWater(on date: Date, _ completionHandler: @escaping (_ dietaryWaters: HKQuantity?) -> Void) {
        
        let sampleType = HKQuantityType.quantityType(forIdentifier: .dietaryWater)!
        let startOfDate = Calendar.current.startOfDay(for: date)
        let endOfDate = Calendar.current.date(byAdding: .day, value: 1, to: startOfDate)!
        let predicate = HKQuery.predicateForSamples(withStart: startOfDate, end: endOfDate, options: [])
        var interval = DateComponents()
        interval.day = 1
        
        let query = HKStatisticsQuery(quantityType: sampleType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (query, result, error) in
            
            guard error == nil else { completionHandler(nil); return }
            
            guard let result = result else { completionHandler(nil); return  }
            
            if let sum = result.sumQuantity() {
                completionHandler(sum)
            }
        }
        
        self.store.execute(query)
    }
    
    func saveDietaryWater(quantity: HKQuantity, _ completionHandler: @escaping () -> Void) {
        
        let quantityType = HKQuantityType.quantityType(forIdentifier: .dietaryWater)!
        let sample = HKQuantitySample(type: quantityType,
                                      quantity: quantity,
                                      start: Date(),
                                      end: Date())
        
        store.save(sample) { (success, error) in
            
            guard error == nil else {
                print("Error Saving DietaryWater:\n\(error!)\n")
                return
            }
            
            completionHandler()
        }
    }
}
