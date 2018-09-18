//
//  DBHelp.swift
//  WDemo
//
//  Created by wyj on 2018/9/18.
//  Copyright © 2018 Alex. All rights reserved.
//

import UIKit
import CoreData

class DBHelp: NSObject {
    
    // 单例
    static let shared = DBHelp()
    
    lazy var context: NSManagedObjectContext = {
        let context = ((UIApplication.shared.delegate) as! AppDelegate).persistentContainer.viewContext
        return context
    }()
    
    func insertWithModelName(modelName:String) -> NSManagedObject {
        let obj = NSEntityDescription.insertNewObject(forEntityName: modelName, into: context)
        return obj
    }
    
    func searchWithModelName(modelName:String,pageIndex:Int) -> [Any] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        fetchRequest.fetchLimit = 30
        fetchRequest.fetchOffset = pageIndex
        do{
            let fetchedResults = try context.fetch(fetchRequest)
            return fetchedResults
        } catch {
            return Array.init()
        }
    }
    
    func searchWithName(modelName:String) -> [Any] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: modelName)
        do{
            let fetchedResults = try context.fetch(fetchRequest)
            return fetchedResults
        } catch {
            return Array.init()
        }
    }
    
    func saveContext() -> Void {
        do{
            try context.save()
        } catch {
            
        }
        
    }
}
