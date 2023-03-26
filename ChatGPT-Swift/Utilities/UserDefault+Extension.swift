//
//  UserDefault+Extension.swift
//  ChatGPT-Swift
//
//  Created by Syed Muhammad on 26/03/2023.
//

import Foundation

struct defaultKeys {
    
    static var name = "1"
    static var userQuestions = "2"
    static var gptAnswers = "3"
 
}

extension UserDefaults {
    
    func setCodable<T: Codable>(_ value: T, forKey key: String, ofType type: T.Type) {
        guard let data = try? JSONEncoder().encode(value) else {
            fatalError("Cannot create a json representation of \(value)")
        }
        self.set(data, forKey: key)
    }
    
    func codable<T: Codable>(forKey key: String, ofType type: T.Type) -> T? {
        guard let data = self.data(forKey: key) else {
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: data)
    }

    func clearAllDefaults() {
        let defaults = UserDefaults.standard
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
        defaults.synchronize()
    }
}
