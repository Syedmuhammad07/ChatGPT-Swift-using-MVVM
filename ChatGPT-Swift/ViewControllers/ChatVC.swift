//
//  ChatVC.swift
//  ChatGPT-Swift
//
//  Created by Syed Muhammad on 26/03/2023.
//

import Foundation
import UIKit

class ChatVC: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var questionField: UITextField!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Properties
    var viewModel: ChatVM = ChatVM()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        questionField.delegate = self
        doneBtn.disable()
        tableViewSetup()
    }
    
    //MARK: - Methods
    func tableViewSetup() {
  
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ChatCell", bundle: nil), forCellReuseIdentifier: "ChatCell")

    }
    
    //MARK: - Actions
    @IBAction func doneBtnAction(_ sender: Any) {
        
        viewModel.appendQuesArray(questionField.text ?? "")
        
        questionField.text = ""
        doneBtn.disable()
        
        tableView.reloadData()
        
        viewModel.sendChatGPTCall(success: {
            self.tableView.reloadData()
        }, failure: {
            
        })
    }
    
    @IBAction func newChatAction(_ sender: Any) {
        viewModel.clearChat()
        tableView.reloadData()
    }
}

extension ChatVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
        cell.cellVM = viewModel.getCellVM(index: indexPath.row)
        cell.showToast = {
            self.showToast(message: "Copied!", font: .systemFont(ofSize: 12.0))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
}

extension ChatVC: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        questionField.text == "" ? doneBtn.disable() : doneBtn.enable()
        viewModel.message = questionField.text ?? ""
    }
}
