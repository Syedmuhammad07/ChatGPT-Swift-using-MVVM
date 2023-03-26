//
//  ViewController.swift
//  ChatGPT-Swift
//
//  Created by Syed Muhammad on 21/03/2023.
//

import UIKit

class ViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var nameField: UITextField!
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.hideKeyboardWhenTappedAround()
        nameField.delegate = self
        doneBtn.disable()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let name = UserDefaults.standard.value(forKey: defaultKeys.name) as? String
        name != nil && name != "" ? moveToChatVC() : nil
    }
    
    //MARK: - Actions
    @IBAction func doneBtnAction(_ sender: Any) {
        let name = nameField.text
        UserDefaults.standard.set(name, forKey: defaultKeys.name)
        moveToChatVC()
    }
    
    //MARK: - Methods
    func moveToChatVC() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        self.present(viewController, animated: true, completion:nil)
    }
    
}

//MARK: - Extension UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        nameField.text == "" ? doneBtn.disable() : doneBtn.enable()
    }
}

