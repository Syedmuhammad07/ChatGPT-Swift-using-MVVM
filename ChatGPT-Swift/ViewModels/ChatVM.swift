//
//  ChatVM.swift
//  ChatGPT-Swift
//
//  Created by Syed Muhammad on 26/03/2023.
//

import Foundation

class ChatVM {
    
    //MARK: - Properties
    var userQuesArr: [String] = UserDefaults.standard.array(forKey: defaultKeys.userQuestions) as? [String] ?? []
    var gptAnsArr: [String] = UserDefaults.standard.array(forKey: defaultKeys.gptAnswers) as? [String] ?? []
    var numberOfRows: Int {
        userQuesArr.count + gptAnsArr.count
    }
    var message: String = ""
    var name: String {
        UserDefaults.standard.string(forKey: defaultKeys.name) ?? ""
    }
    
    //MARK: - Methods
    func getRequestModel() -> GPTRequest {
        let message = Message.init(role: "user", content: message)
        return GPTRequest(model: "gpt-3.5-turbo", messages: [message])
    }
    
    func appendQuesArray(_ text: String) {
        userQuesArr.append(text)
        UserDefaults.standard.set(userQuesArr, forKey: defaultKeys.userQuestions)
    }
    
    func appendAnsArray(_ text: String) {
        gptAnsArr.append(text)
        UserDefaults.standard.set(gptAnsArr, forKey: defaultKeys.gptAnswers)
    }
    
    func getCellVM(index: Int) -> ChatCellVM {
        var obj = ChatCellVM()
        obj.name = name
        obj.type = index%2 == 0 ? .user : .chatGpt
        if obj.type == .user {
            obj.text = userQuesArr[index - index/2]
        }
        else {
            obj.text = gptAnsArr[index - (index/2 + index%2)]
        }
        return obj
    }
    
    func clearChat() {
        userQuesArr = []
        gptAnsArr = []
        UserDefaults.standard.set(userQuesArr, forKey: defaultKeys.userQuestions)
        UserDefaults.standard.set(userQuesArr, forKey: defaultKeys.gptAnswers)
    }
    
    
    //MARK: - Network Calls
    func sendChatGPTCall(success: @escaping() -> (), failure: @escaping() -> ()) {
        
        do{
            let requestModel = getRequestModel()
            let param = try JSONEncoder().encode(requestModel)
            
            ServiceManager.shared.sendAPICall(withEndpoint: "https://api.openai.com/v1/chat/completions", Parameters: param, httpMethod: "POST", completion: { result in
                
                switch result {
                case .success(let data):
                    do {
                        let jsonData = try JSONDecoder().decode(GPTResponse.self, from: data)
                        self.appendAnsArray(jsonData.choices?[0].message?.content ?? "")
                        success()
                    }
                    catch{
                        print("Error: Dencoding failed.")
                        failure()
                    }
                case .failure(let error):
                    print("Error: \(error)")
                    failure()
                }
                
            })
        }
        catch {
            print("Error: Encoding failed.")
            failure()
        }
    }
}
