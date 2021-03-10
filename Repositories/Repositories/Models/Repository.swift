import Cocoa
import CoreData

class RepositoryAction {
    enum NotificationName: String {
        case remove = "removeRepo"
        case selected = "selected"
        case selectedDirectory = "directory"
    }
    static func notificationName(_ name: NotificationName) -> Notification.Name {
        Notification.Name.init(name.rawValue)
    }
}

class Repository: NSManagedObject {
    static func createWithContext(_ context: NSManagedObjectContext, _ name: String, _ path: String) -> Repository {
        let r = Repository(context: context)
        r.name = name
        r.path = path
        return r
    }
 
    @NSManaged var id: UUID;
    @NSManaged var name: String;
    @NSManaged var path: String;
}
