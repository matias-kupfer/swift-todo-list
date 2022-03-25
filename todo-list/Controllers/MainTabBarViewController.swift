//
//  ViewController.swift
//  todo-list
//
//  Created by Matias Kupfer on 25.02.22.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        tabBar.backgroundColor = .systemBackground
        tabBar.tintColor = .systemYellow
        
        
        let vc1 = UINavigationController(rootViewController: TasksViewController())
        let vc2 = UINavigationController(rootViewController: CompletedViewController())
        
        vc1.tabBarItem.image = UIImage(systemName: "checklist")
        vc2.tabBarItem.image = UIImage(systemName: "checkmark.circle")
        
        vc1.title = "To do"
        vc2.title = "Completed"
        
        
        setViewControllers([vc1, vc2], animated: true)
        
    }
}

