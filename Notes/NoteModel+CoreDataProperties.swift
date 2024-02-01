import CoreData
import CoreData

extension NoteModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteModel> {
        return NSFetchRequest<NoteModel>(entityName: "NoteModel")
    }

    @NSManaged public var text: String?

}

extension NoteModel : Identifiable {

}
