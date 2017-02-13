//
//  PostViewController.swift
//  Baasic
//
//  Created by Zeljko Huber on 26/01/2017.
//  Copyright © 2017 Mono. All rights reserved.
//

import UIKit

public protocol TodoViewControllerDelegate {
    func fetchData()
}

class TodoViewController: ViewControllerBase {
    
    fileprivate let cellSize: CGFloat = 80.0
    fileprivate let screenHeight = UIScreen.main.bounds.height
    fileprivate let statusBarHeight = UIApplication.shared.statusBarFrame.height
    
    @IBOutlet weak var todoTableView: UITableView!
    
    private var refreshControl: UIRefreshControl!
    private var loadMoreLoader: UIActivityIndicatorView!
    
    fileprivate var isLoading = false
    
    fileprivate var currentPage = 1
    fileprivate let recordsPerPage = 10
    fileprivate var todos: [TodoModel] = []
    
    private let dynamicResourceClient: DynamicResourceClient<TodoModel>
    
    required init?(coder aDecoder: NSCoder) {
        self.dynamicResourceClient = DynamicResourceClient()
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "TODO"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(addTodo))
        LoaderView.show()
        self.setupTableView()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.fetchData()
    }
    
    private func setupTableView() {
        self.todoTableView.register(cellType: TodoCell.self)
        
        self.todoTableView.delegate = self
        self.todoTableView.dataSource = self
        self.todoTableView.estimatedRowHeight = cellSize
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(fetchData), for: UIControlEvents.valueChanged)
        self.todoTableView.addSubview(self.refreshControl)
        
        let tableSize = self.todoTableView.frame.size
        
        let loaderView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        loaderView.frame = CGRect(x: 0, y: 0, width: tableSize.width, height: cellSize)
        loaderView.startAnimating()
        
        self.loadMoreLoader = loaderView
        self.todoTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    public func fetchData() {
        self.showTopLoader(true)
        self.currentPage = 1
        
        let params = FilterParameters()
        params.sort = "title"
        params.page = self.currentPage
        params.rpp = self.recordsPerPage
        
        self.dynamicResourceClient.find(filter: params, completion: { (response: BaasicResponse<CollectionModelBase<TodoModel>>) in
            LoaderView.hide()
            self.showTopLoader(false)
            
            switch response {
            case .success(let value):
                self.todos = value.item
                self.refreshTableData()
                break
            case .failure(let error, let statusCode):
                self.displayErrorMessage(errorType: .response(error, statusCode))
                break
            }
        })
    }
    
    public func loadMore(page: Int) {
        self.showBottomLoader(true)
        self.currentPage = page
        
        let params = FilterParameters()
        params.sort = "title"
        params.page = page
        params.rpp = self.recordsPerPage
        
        self.dynamicResourceClient.find(filter: params, completion: { (response: BaasicResponse<CollectionModelBase<TodoModel>>) in
            switch response {
            case .success(let value):
                var startRow = self.todos.count - 1
                self.todos += value.item
                
                let indexPaths: [IndexPath] = value.item.map({ item in
                    startRow += 1
                    return IndexPath(row: startRow, section: 0)
                })
                
                self.todoTableView.beginUpdates()
                self.todoTableView.insertRows(at: indexPaths, with: .fade)
                self.todoTableView.endUpdates()
                break
            case .failure(let error, let statusCode):
                self.displayErrorMessage(errorType: .response(error, statusCode))
                break
            }
            
            self.showBottomLoader(false)
        })

        
    }
    
    private func showTopLoader(_ show: Bool) {
        self.isLoading = show
        if !LoaderView.sharedInstance.isLoading {
            if show {
                self.refreshControl.beginRefreshing()
            }
            else {
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    private func showBottomLoader(_ show: Bool) {
        self.isLoading = show
        self.todoTableView.tableFooterView = show ? self.loadMoreLoader : UIView(frame: CGRect.zero)
    }
    
    public func refreshTableData() {
        DispatchQueue.main.async{
            self.todoTableView.reloadData()
        }
    }

    public func addTodo() {
        let controller = TodoEditViewController.loadFromStoryboard()
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    public func editTodo(_ todo: TodoModel) {
        let controller = TodoEditViewController.loadFromStoryboard()
        controller.todo = todo
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    public func deleteTodo(_ todo: TodoModel) {
        self.dynamicResourceClient.delete(id: todo.id, completion: { response in
            switch response {
            case .success(_):
                self.fetchData()
                break
            case .failure(let error, let statusCode):
                self.displayErrorMessage(errorType: .response(error, statusCode))
                break
            }
        })
    }
    
    public func completeTodo(_ todo: TodoModel) {
        todo.isComplete = true
        self.dynamicResourceClient.update(resource: todo, completion: { response in
            switch response {
            case .success(_):
                self.fetchData()
                break
            case .failure(let error, let statusCode):
                todo.isComplete = false
                self.displayErrorMessage(errorType: .response(error, statusCode))
                break
            }
        })
    }
}

extension TodoViewController : UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TodoCell = tableView.dequeueReusableCell(for: indexPath) as TodoCell
        let todo = self.todos[indexPath.row]
        cell.setup(todo: todo)
        return cell
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.todos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellSize
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let controller = TodoDetailViewController.loadFromStoryboard()
        controller.post = self.todos[indexPath.row]
        self.navigationController!.pushViewController(controller, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, indexPath in
            self.deleteTodo(self.getTodo(at: indexPath.row))
            tableView.setEditing(false, animated: true)
        }
        delete.backgroundColor = .red
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { action, indexPath in
            self.editTodo(self.getTodo(at: indexPath.row))
            tableView.setEditing(false, animated: true)
        }
        edit.backgroundColor = .blue
        
        var actions = [delete, edit]
        
        let todo = self.getTodo(at: indexPath.row)
        if !todo.isComplete {
            let complete = UITableViewRowAction(style: .normal, title: "Complete") { action, indexPath in
                let todo = self.getTodo(at: indexPath.row)
                self.completeTodo(todo)
                tableView.setEditing(false, animated: true)
            }
            complete.backgroundColor = .green
            
            actions.insert(complete, at: 0)
        }
        
        return actions
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var sectionCount = 0
        
        if self.todos.count > 0 {
            tableView.backgroundView = nil
            sectionCount = 1
        }
        else {
            let size = tableView.bounds.size
            let noDataLabel = UILabel(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            noDataLabel.text = "No Todo Items Found"
            noDataLabel.textColor = UIColor.black
            noDataLabel.textAlignment = NSTextAlignment.center
            tableView.backgroundView = noDataLabel
            
        }
        
        return sectionCount
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let cellY = cell.frame.origin.y + 10
        let offset = self.navigationController!.navigationBar.frame.size.height + statusBarHeight
        let loadStartY = screenHeight - offset
        
        if (!self.isLoading && cellY >= loadStartY && indexPath.row == self.todos.count - 1) {
            self.loadMore(page: self.currentPage + 1)
        }
    }
    
    func getTodo(at row: Int) -> TodoModel {
        return self.todos[row]
    }
}
