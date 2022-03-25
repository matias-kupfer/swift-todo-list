//
//  AddTaskViewController.swift
//  todo-list
//
//  Created by Matias Kupfer on 25.02.22.
//

import UIKit

protocol AddTaskViewControllerDelegate: AnyObject {
    func backwards()
}

class AddTaskViewController: UIViewController {

    public var addTaskViewControllerDelegate: AddTaskViewControllerDelegate!

    
    let inputField: UITextField = {
        let input = UITextField()
        input.placeholder = "Walk the fish"
        input.translatesAutoresizingMaskIntoConstraints = false
        input.font = UIFont.systemFont(ofSize: 15)
        input.borderStyle = UITextField.BorderStyle.roundedRect
        input.autocorrectionType = UITextAutocorrectionType.no
        input.keyboardType = UIKeyboardType.default
        input.returnKeyType = UIReturnKeyType.done
        input.clearButtonMode = UITextField.ViewMode.whileEditing
        input.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        return input
    }()
    
    let leftBarButtonItem: UIBarButtonItem = {
        var button = UIBarButtonItem()
        button.title = "Cancel"
        button.style = UIBarButtonItem.Style.plain
        button.action = #selector(dismissModal(_:))
        button.tintColor = .red
        return button
    }()
    
    let rightBarButtonItem: UIBarButtonItem = {
        var button = UIBarButtonItem()
        button.title = "Save"
        button.style = UIBarButtonItem.Style.plain
        button.isEnabled = false
        button.action = #selector(onSaveTask(_:))
        button.tintColor = .systemBlue
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Add Task"
        
        inputField.addTarget(self, action: #selector(onUserDidType(_:)), for: .editingChanged)
        leftBarButtonItem.target = self
        rightBarButtonItem.target = self
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        
        view.backgroundColor = .systemBackground
        view.addSubview(inputField)
        
        setUpConstraints()
    }

    
    private func setUpConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(inputField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10))
        constraints.append(inputField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10))
        constraints.append(inputField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor))
        
        //        constraints.append(inputField.topAnchor.constraint(equalTo: view.topAnchor, constant: 120))
        //        constraints.append(inputField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20))
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    @objc private func onUserDidType(_ textField: UITextField) {
        self.rightBarButtonItem.isEnabled = textField.text != ""
    }
    
    @objc private func dismissModal(_: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func onSaveTask(_: UIBarButtonItem) {
        let taskObject = TaskModel(title: inputField.text!, is_completed: false)
        CoreDataService.shared.saveTask(model: taskObject) { result in
            switch result {
            case .success():
                self.addTaskViewControllerDelegate.backwards()
                self.dismiss(animated: true, completion: nil)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}

