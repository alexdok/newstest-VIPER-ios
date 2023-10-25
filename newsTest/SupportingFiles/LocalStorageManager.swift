//
//  SaveManager.swift
//  newsTest
//
//  Created by алексей ганзицкий on 13.09.2023.
//
// пока реализован как синглтон , потом нужно переделать 
import Foundation

protocol LocalStorage {
    func save(_ title: String, count: Int)
    func loadCount(_ title: String) -> Int
    func saveSettingsList(arrayOfLabels: [String?], titleForNews: String)
    func loadSettingsList(titleForNews: String) -> [String?]
}

class LocalStorageManager: LocalStorage {
    static let shared = LocalStorageManager()
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
