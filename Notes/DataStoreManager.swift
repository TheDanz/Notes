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
    
    func createNote(header: String, text: String, modifiedDate: Date) {
        
        let note = NoteModel(context: viewContext)
        note.header = header
        note.text = text
        note.modifiedDate = modifiedDate
        
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
    
    func getHeader(for object: NoteModel) -> String? {
        return object.header
    }
    
    func getText(for object: NoteModel) -> String? {
        return object.text
    }
    
    func getModifiedDate(for object: NoteModel) -> Date? {
        return object.modifiedDate
    }
}

extension DataStoreManager: NSCopying {

    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
