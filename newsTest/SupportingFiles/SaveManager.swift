//
//  SaveManager.swift
//  newsTest
//
//  Created by алексей ганзицкий on 13.09.2023.
//

import Foundation

protocol SaveManager {
    func save(_ title: String, count: Int)
    func loadCount(_ title: String) -> Int
    func saveSettingsList(arrayOfLabels: [String?], titleForNews: String)
    func loadSettingsList(titleForNews: String) -> [String?]
}

class SaveManagerImpl: SaveManager {
    static let shared = SaveManagerImpl()
    private init() {}
    
    func save(_ title: String, count: Int) {
        UserDefaults.standard.set(count, forKey: "\(title)")
    }
    
    func loadCount(_ title: String) -> Int {
      let count = UserDefaults.standard.integer(forKey: "\(title)")
        return count
    }
    
    func saveSettingsList(arrayOfLabels: [String?], titleForNews: String) {
        UserDefaults.standard.setValue(arrayOfLabels, forKey: titleForNews)
    }
    
    func loadSettingsList(titleForNews: String) -> [String?] {
        let array = UserDefaults.standard.value(forKey: titleForNews)
        return array as? [String?] ?? [""]
    }
}
