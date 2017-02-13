//
//  PostEditViewController.swift
//  Baasic
//
//  Created by Zeljko Huber on 28/01/2017.
//  Copyright © 2017 Mono. All rights reserved.
//

import Foundation
import UIKit

public class TodoEditViewController : ViewControllerBase, StoryboardLoadable {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    public var todo: TodoModel?
    
    private let dynamicResourceClient: DynamicResourceClient<TodoModel> = DynamicResourceClient()
    
    public static var storyboardName: String {
        return "Main"
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func viewDidLoad() {
        if let todo = self.todo {
            self.title = "Edit Post"
            
            self.titleTextField.text = todo.title
            self.descriptionTextView.text = todo.description
            
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update",
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(updateTodo))
        }
        else {
            self.title = "Create New Post"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create",
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(createTodo))
        }
    }
    
    func updateTodo() {
        let todo = bind(todo: self.todo!)
        if !self.validate(todo: todo) {
            return
        }
        
        LoaderView.show()
        self.dynamicResourceClient.update(resource: todo, completion: { response in
            LoaderView.hide()
            switch response {
            case .success(_):
                _ = self.navigationController?.popToRootViewController(animated: true)
                break
            case .failure(let error, let statusCode):
                self.displayErrorMessage(errorType: .response(error, statusCode))
                break
            }
        })
    }
    
    func createTodo() {
        let todo = bind(todo: TodoModel())
        todo.dateCreated = Date()
        
        if !self.validate(todo: todo) {
            return
        }
        
        LoaderView.show()
        self.dynamicResourceClient.insert(resource: todo, completion: { response in
            LoaderView.hide()
            switch response {
            case .success(_):
                _ = self.navigationController?.popToRootViewController(animated: true)
                break
            case .failure(let error, let statusCode):
                self.displayErrorMessage(errorType: .response(error, statusCode))
                break
            }
        })
    }
    
    private func bind(todo: TodoModel) -> TodoModel {
        todo.title = self.titleTextField.text!
        todo.description = self.descriptionTextView.text
        return todo
    }
    
    private func validate(todo: TodoModel) -> Bool {
        let isValid = todo.title != "" && todo.description != ""
        if !isValid {
            self.displayErrorMessage(errorType: .custom(title: "Validation Failed", description: "Please enter all fields"))
            return false
        }
        
        return true
    }
}
