import CoreData
import Foundation

extension NoteModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteModel> {
        return NSFetchRequest<NoteModel>(entityName: "NoteModel")
    }

    @NSManaged public var header: String?
    @NSManaged public var text: String?
    @NSManaged public var modifiedDate: Date?
    @NSManaged public var fontSize: Int16
    @NSManaged public var font: String?

}

extension NoteModel : Identifiable {

}
