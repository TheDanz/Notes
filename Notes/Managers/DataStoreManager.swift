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
        note.font = "Avenir Next"
        note.fontSize = 15
        
        try? viewContext.save()
    }
    
    func deleteNote(object: NoteModel) {
        viewContext.delete(object)
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
    
    func getFont(for object: NoteModel) -> String? {
        return object.font
    }
    
    func getFontSize(for object: NoteModel) -> Int? {
        return Int(object.fontSize)
    }
    
    func updateHeader(for object: NoteModel, header: String) {
        object.header = header
        try? viewContext.save()
    }
    
    func updateNote(for object: NoteModel, text: String) {
        object.text = text
        try? viewContext.save()
    }
    
    func updateModifiedDate(for object: NoteModel, date: Date) {
        object.modifiedDate = date
        try? viewContext.save()
    }
    
    func updateFont(for object: NoteModel, font: String) {
        object.font = font
        try? viewContext.save()
    }
    
    func updateFontSize(for object: NoteModel, fontSize: Int) {
        object.fontSize = Int16(fontSize)
        try? viewContext.save()
    }
}

extension DataStoreManager: NSCopying {

    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}
