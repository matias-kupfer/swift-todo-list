//
//  CompletedViewController.swift
//  todo-list
//
//  Created by Matias Kupfer on 25.02.22.
//

import UIKit

class CompletedViewController: UIViewController {
    
    private var tasks: [TaskModelCoreData] = [TaskModelCoreData]()
    
    private let tasksTable: UITableView = {
        let table = UITableView()
        table.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Completed"
        
        view.addSubview(tasksTable)
        tasksTable.delegate = self
        tasksTable.dataSource = self
        
        getTasks()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tasksTable.frame = view.bounds
    }
    
    func getTasks() {
        CoreDataService.shared.getTasks(isCompleted: true) { [weak self] result in
            switch result {
            case .success(let tasks):
                self?.tasks = tasks
                DispatchQueue.main.async {
                    self?.tasksTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func completeTask(task: TaskModelCoreData) {
        CoreDataService.shared.updateTask(task: task) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.tasksTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteTask(task: TaskModelCoreData) {
        CoreDataService.shared.deleteTask(task: task) { [weak self] result in
            switch result {
            case .success(_):
                DispatchQueue.main.async {
                    self?.tasksTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension CompletedViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TaskTableViewCell()
        cell.configure(with: self.tasks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let complete = UIContextualAction(style: .normal, title: "Todo", handler: {(action, view, completionHandler) in
            self.completeTask(task: self.tasks[indexPath.row])
            self.tasks.remove(at: indexPath.row);
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic);
            completionHandler(true)
        })
        complete.backgroundColor = .systemGreen
        
        let swipe = UISwipeActionsConfiguration(actions: [complete])
        return swipe
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete", handler: {(action, view, completionHandler) in
            self.deleteTask(task: self.tasks[indexPath.row])
            self.tasks.remove(at: indexPath.row);
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic);
            completionHandler(true)
        })
        
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        return swipe
    }
}
