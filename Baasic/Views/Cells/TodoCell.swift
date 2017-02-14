//
//  PostCell.swift
//  Baasic
//
//  Created by Zeljko Huber on 26/01/2017.
//  Copyright © 2017 Mono. All rights reserved.
//

import Foundation
import UIKit

public class TodoCell : UITableViewCell, NibReusable {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var scheduledDateLabel: UILabel!
    
    public func setup(todo: TodoModel) {
        self.titleLabel.text = todo.title
        self.descriptionLabel.text = todo.description
        
        let formatter = DateFormatter.todoDateFormatter()
        self.scheduledDateLabel.text = formatter.string(from: todo.scheduledDate)
        
        self.backgroundColor = todo.isComplete ? UIColor.green : UIColor.clear
    }
}
