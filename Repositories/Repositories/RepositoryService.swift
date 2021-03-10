//
//  RepositoryService.swift
//  Repositories
//
//  Created by Bruno Henrique Dias on 07/03/21.
//

import Cocoa

class RepositoryService: NSObject {
    static var shared: RepositoryService = RepositoryService()
    
    private override init() {}
    
    func getAll() -> [Repository] {
        let c = AppDelegate.shared.persistentContainer.viewContext
        let items = try! c.fetch(Repository.fetchRequest()) as! [Repository]
        return items
    }
    
    func add(_ name: String, _ path: String) {
        let c = AppDelegate.shared.persistentContainer.viewContext
        let r = Repository.createWithContext(c, name, path)
        do {
            r.id = UUID.init()
            c.insert(r)
            try c.save()
        } catch {
            print(error)
        }
    }
    
    func delete(_ repo: Repository) {
        let c = AppDelegate.shared.persistentContainer.viewContext
        do {
            c.delete(repo as NSManagedObject)
            try c.save()
        } catch {
            print(error)
        }
        
    }
}
