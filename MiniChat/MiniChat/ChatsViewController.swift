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
    
    
    
    
}
