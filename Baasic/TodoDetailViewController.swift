//
//  PostDetailViewController.swift
//  Baasic
//
//  Created by Zeljko Huber on 28/01/2017.
//  Copyright © 2017 Mono. All rights reserved.
//

import Foundation
import UIKit

public class TodoDetailViewController : UIViewController, StoryboardLoadable {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    public var post: TodoModel!

    public static var storyboardName: String {
        return "Main"
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        self.title = self.post.title
        self.titleLabel.text = self.post.title
        self.descriptionLabel.text = self.post.description
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit,
                                                                 target: self,
                                                                 action: #selector(editClicked))
    }
    
    public func editClicked() {
        let controller = TodoEditViewController.loadFromStoryboard()
        controller.todo = post
        self.navigationController!.pushViewController(controller, animated: true)
    }
}
