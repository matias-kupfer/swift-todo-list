//
//  TasksViewController.swift
//  todo-list
//
//  Created by Matias Kupfer on 25.02.22.
//

import UIKit

class TasksViewController: UIViewController {
    
    private var tasks: [TaskModelCoreData] = [TaskModelCoreData]()
    
    private let tasksTable: UITableView = {
        let table = UITableView()
        table.register(TaskTableViewCell.self, forCellReuseIdentifier: TaskTableViewCell.identifier)
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Tasks"
        let appearance = UINavigationBarAppearance()
        //appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = appearance;
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        let rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.onAddTaskButtonClick(_:)))
        rightBarButtonItem.tintColor = .yellow
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
        
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
        CoreDataService.shared.getTasks(isCompleted: false) { [weak self] result in
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

extension TasksViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TaskTableViewCell()
        cell.configure(with: tasks[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let complete = UIContextualAction(style: .normal, title: "Complete", handler: {(action, view, completionHandler) in
            self.completeTask(task: self.tasks[indexPath.row])
            self.tasks.remove(at: indexPath.row);
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic);
            completionHandler(true)
        })
        complete.backgroundColor = .systemGreen
        complete.image = UIImage(systemName: "checkmark")

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
        delete.image = UIImage(systemName: "trash")
        
        let swipe = UISwipeActionsConfiguration(actions: [delete])
        return swipe
    }
}

extension TasksViewController: AddTaskViewControllerDelegate {
    @objc func onAddTaskButtonClick(_: UIBarButtonItem!) {
        let vce = AddTaskViewController()
        vce.addTaskViewControllerDelegate = self
        let vc = UINavigationController(rootViewController: vce)
        vc.sheetPresentationController?.detents = [.medium()]
        navigationController?.present(vc, animated: true)
    }
    
    func backwards() {
        getTasks()
    }
    
    
}


