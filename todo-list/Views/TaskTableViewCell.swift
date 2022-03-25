//
//  TaskTableViewCell.swift
//  todo-list
//
//  Created by Matias Kupfer on 25.02.22.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    static let identifier = "TaskTableViewCell"
    
    private let task: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(task)
        applyConstraints()
    }
    
    private func applyConstraints() {
        var constraints = [NSLayoutConstraint]()
        
        constraints.append(task.centerYAnchor.constraint(equalTo: self.centerYAnchor))
        constraints.append(task.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10))
        
        NSLayoutConstraint.activate(constraints)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public func configure(with model: TaskModelCoreData) {
        let labelValue = NSMutableAttributedString(string: model.title!)
        if(model.is_completed) {
            labelValue.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: labelValue.length))
        }
        task.attributedText = labelValue
    }
    
}
