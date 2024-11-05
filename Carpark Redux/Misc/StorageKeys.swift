//
//  StorageKeys.swift
//  Carpark Redux
//
//  Created by Mack Slevin on 11/4/24.
//

enum StorageKeys: String {
    case customAccentColor = "customAccentColor"
    case dataMigratedFromUIKit = "dataHasBeenMigratedFromUIKitVersion"
    case shouldUseHaptics = "shouldUseHaptics"
    case mapPreference = "mapPreference"
    case shouldConfirmBeforeParking = "shouldConfirmBeforeParking"
    case settingsWasOpenedCounter = "settingsWasOpenedCounter" // Incremented on view appear. Eventually reset to zero. Used in determining when to prompt for app store review/rating.
}
