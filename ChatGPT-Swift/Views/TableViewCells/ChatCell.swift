//
//  ChatCell.swift
//  ChatGPT-Swift
//
//  Created by Syed Muhammad on 23/03/2023.
//

import UIKit

enum chatCellType {
    case chatGpt
    case user
}

struct ChatCellVM {
    var name: String?
    var type: chatCellType?
    var text: String?
}

class ChatCell: UITableViewCell {

    //MARK: - Outlet
    @IBOutlet weak var chatLabel: UILabel!
    @IBOutlet weak var userIconView: UIView!
    @IBOutlet weak var userIconLabel: UILabel!
    @IBOutlet weak var view: UIView!
    
    //MARK: - Properties
    var showToast: (()->())?
    var cellVM: ChatCellVM! {
        didSet {
            if cellVM.type == .chatGpt {
                view.backgroundColor = UIColor(named: "GptChatCellColor")
                userIconView.isHidden = true
            }
            else {
                view.backgroundColor = UIColor(named: "userChatCellColor")
                userIconView.isHidden = false
            }
            chatLabel.text = cellVM.text
            userIconLabel.text = cellVM.name?.initials
        }
    }
    
    var type: chatCellType? {
        didSet {
            if type == .chatGpt {
                view.backgroundColor = UIColor(named: "GptChatCellColor")
                userIconView.isHidden = true
            }
            else {
                view.backgroundColor = UIColor(named: "userChatCellColor")
                userIconView.isHidden = false
            }
        }
    }
    
    //MARK: - LifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(labelDidGetTapped))

        chatLabel.isUserInteractionEnabled = true
        chatLabel.addGestureRecognizer(tapGesture)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    //MARK: - Methods
    @objc func labelDidGetTapped(sender: UITapGestureRecognizer) {
        guard let label = sender.view as? UILabel else {
            return
        }
        UIPasteboard.general.string = label.text
        self.showToast?()
    }
    
}
