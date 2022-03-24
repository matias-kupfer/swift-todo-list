//
//  DataPersistenceMAnager.swift
//  todo-list
//
//  Created by Matias Kupfer on 25.02.22.
//

import Foundation
import CoreData
import UIKit

class CoreDataService {
    
    enum DatabaseError: Error {
        case failedToSaveData
        case failedToFetchData
    }
    
    static let shared = CoreDataService()
    
    func saveTask(model: TaskModel, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = TaskModelCoreData(context: context)
        item.title = model.title
        item.is_completed = model.is_completed
        
        do {
            try context.save()
            completion(.success(()))
            
        } catch {
            completion(.failure(DatabaseError.failedToSaveData))
        }
    }
    
    func updateTask(task: TaskModelCoreData, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        task.is_completed = !task.is_completed
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    func deleteTask(task: TaskModelCoreData, completion: @escaping (Result<Void, Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        context.delete(task)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
    
    func getTasks(isCompleted: Bool, completion: @escaping (Result<[TaskModelCoreData], Error>) -> Void) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request: NSFetchRequest<TaskModelCoreData>
        request = TaskModelCoreData.fetchRequest()
        
        request.predicate = NSPredicate(format: "is_completed = \(NSNumber(value:isCompleted))")
        
        do {
            let tasks = try context.fetch(request)
            completion(.success(tasks))
        } catch {
            completion(.failure(DatabaseError.failedToFetchData))
        }
    }
}
