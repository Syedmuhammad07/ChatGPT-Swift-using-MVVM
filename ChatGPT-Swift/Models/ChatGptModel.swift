//
//  ChatGptModel.swift
//  ChatGPT-Swift
//
//  Created by Syed Muhammad on 26/03/2023.
//

import Foundation

// MARK: - GPTRequest
struct GPTRequest: Codable {
    var model: String?
    var messages: [Message]?
    
    init(model: String? = nil, messages: [Message]? = nil) {
        self.model = model
        self.messages = messages
    }
}

// MARK: - GPTResponse
struct GPTResponse: Codable {
    var id: String?
    var object: String?
    var created: Int?
    var model: String?
    var usage: Usage?
    var choices: [Choice]?
}

// MARK: - Choice
struct Choice: Codable {
    var message: Message?
    var finishReason: String?
    var index: Int?
}

// MARK: - Message
struct Message: Codable {
    var role: String?
    var content: String?
}

// MARK: - Usage
struct Usage: Codable {
    var promptTokens: Int?
    var completionTokens: Int?
    var totalTokens: Int?
}
