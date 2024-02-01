import CoreData

class DataStoreManager {
    
    static var shared: DataStoreManager = DataStoreManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Notes")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var viewContext = persistentContainer.viewContext

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func createNote(text: String) {
        
        let note = NoteModel(context: viewContext)
        note.text  = text
        
        try? viewContext.save()
    }
    
    func deleteNote(object: NoteModel) {
        viewContext.delete(object)
        try? viewContext.save()
    }
    
    func updateNote(for object: NoteModel, text: String) {
        object.text = text
        try? viewContext.save()
    }
    
    func getText(for object: NoteModel) -> String? {
        return object.text
    }
}

extension DataStoreManager: NSCopying {

    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
