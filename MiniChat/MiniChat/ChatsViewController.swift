//
//  ChatsViewController.swift
//  MiniChat
//
//  Created by Akkshay Khoslaa on 10/18/16.
//  Copyright © 2016 Akkshay Khoslaa. All rights reserved.
//

import UIKit

import FirebaseAuth
import FirebaseDatabase
class ChatsViewController: UIViewController {
    
    var tableView: UITableView!
    var chats = [Chat]()
    var dbRef: FIRDatabaseReference!
    private var selectedChat: Chat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dbRef = FIRDatabase.database().reference()
        setupNavBar()
        setupTableView()
        getChats()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavBar() {
        self.title = "Chats"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barStyle = .blackTranslucent
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.012, green: 0.663, blue: 0.957, alpha: 1)
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.white,
             NSFontAttributeName: UIFont(name: "SFUIText-Medium", size: 16)!]
    }
    
    func setupTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        tableView.register(ChatTableViewCell.self, forCellReuseIdentifier: "chatCell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    
    
    func getChats() {
        let currUserId = FIRAuth.auth()?.currentUser?.uid
        let dbPath = "users/\(currUserId!)/chat_ids/"
        dbRef.child(dbPath).observeSingleEvent(of: .value, with: { snapshot -> Void in
            if let dict = snapshot.value as? [String: AnyObject] {
                for chatId in dict.keys {
                    SoarUtils().getChat(withId: chatId, block: { chat -> Void in
                        self.chats.append(chat)
                        self.chats.sort(by: { (chatOne, chatTwo) -> Bool in
                            if chatOne.createdAt < chatTwo.createdAt {
                                return true
                            }
                            return false
                        })
                        let index = self.chats.index(where: {$0.chatId == chat.chatId})
                        let indexPaths = [IndexPath(item: index!, section: 0)]
                        self.tableView.insertRows(at: indexPaths, with: .fade)
                    })
                    
                }
            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toMessages" {
            let destVC = segue.destination as! MessagesViewController
            destVC.chat = selectedChat
        }
    }
    
    
}

extension ChatsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as! ChatTableViewCell
        
        cell.awakeFromNib()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cell = cell as! ChatTableViewCell
        populateChatCell(withChat: chats[indexPath.item], cell: cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedChat = chats[indexPath.item]
        self.performSegue(withIdentifier: "toMessages", sender: self)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    //TODO: better time ago
    func populateChatCell(withChat: Chat, cell: ChatTableViewCell) {
        cell.profPicImageView.image = nil
        withChat.getOtherUser(withBlock: { otherUser -> Void in
            cell.usernameLabel.text = otherUser.name!
            otherUser.getPhoto(withBlock: { image -> Void in
                cell.profPicImageView.image = image
            })
        })
        cell.timeAgoLabel.text = MDBSwiftUtils.timeSince(withChat.createdAt!)
        let currUserId = FIRAuth.auth()?.currentUser?.uid
        withChat.getLastMessage(withBlock: { lastMessage -> Void in
            if lastMessage.senderId == currUserId {
                cell.contentLabel.text = "You: " + lastMessage.content!
            } else {
                lastMessage.getSender(withBlock: { sender -> Void in
                    cell.contentLabel.text = sender.name! + lastMessage.content!
                })
            }
        })
    }
    
    
    
    
}
