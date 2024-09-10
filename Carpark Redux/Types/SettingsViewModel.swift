//
//  SettingsViewModel.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 9/9/24.
//

import SwiftUI
import Observation

@Observable
class SettingsViewModel {
    let settingsCounterKey = "settingsWasOpenedCounter"
    
    func shouldAskForReview() -> Bool {
        let counter: Int? = UserDefaults.standard.value(forKey: settingsCounterKey) as? Int
        
        guard let counter else {
            UserDefaults.standard.setValue(1, forKey: settingsCounterKey)
            return false
        }
        
        let newCounterValue = counter + 1
        UserDefaults.standard.setValue(newCounterValue, forKey: settingsCounterKey)
        
        if newCounterValue > 45 {
            UserDefaults.standard.setValue(0, forKey: settingsCounterKey)
        }
        
        if newCounterValue == 3 || newCounterValue == 15 || newCounterValue == 30 {
            return true
        } else {
            return false
        }
    }
}

