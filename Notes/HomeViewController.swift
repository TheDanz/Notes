import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    private let dataStoreManager = DataStoreManager.shared
    private var fetchedResultsController: NSFetchedResultsController<NoteModel>!
    
    let notesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.register(NoteTableViewCell.self, forCellReuseIdentifier: NoteTableViewCell.identifier)
        return tableView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        DispatchQueue.main.async {
            self.notesTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(notesTableView)
        notesTableView.delegate = self
        notesTableView.dataSource = self
        
        setupNewNoteButton()
        setupNotesTableViewConstants()
        setupFetchedResultsContoller()
    }
    
    private func setupNewNoteButton() {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "plus"), for: .normal)
        button.addTarget(self, action: #selector(handlerNewNoteButtonClick), for: .touchUpInside)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 70).isActive = true
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    @objc func handlerNewNoteButtonClick() {
        // open new viewController
    }
    
    private func setupFetchedResultsContoller() {
        
        let fetchRequest: NSFetchRequest<NoteModel> = NoteModel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "text", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.fetchLimit = 15
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: dataStoreManager.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        try! fetchedResultsController.performFetch()
    }
    
    private func setupNotesTableViewConstants() {
        notesTableView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        notesTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        notesTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        notesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
}

// MARK: - Table View Methods

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let numberOfObjects = fetchedResultsController?.sections?[section].numberOfObjects ?? 0
        
        if numberOfObjects == 0 {
            
            let noDataLabel = UILabel(frame: CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height))
            noDataLabel.font = UIFont(name: "Avenir Next Bold", size: 30)
            noDataLabel.text = "You haven't saved any notes yet"
            noDataLabel.textAlignment = .center
            noDataLabel.textColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
            noDataLabel.numberOfLines = 0
            tableView.backgroundView = noDataLabel
            
            return 0
        }
        
        if tableView.backgroundView != nil {
            tableView.backgroundView = nil
        }
        
        return numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTableViewCell.identifier) as? NoteTableViewCell else {
            return UITableViewCell()
        }
        
        let noteModel = fetchedResultsController?.object(at: indexPath)
        DispatchQueue.main.async {
            cell.someTextLabel.text = DataStoreManager.shared.getText(for: noteModel!)
            // cell.dateLabel.text = Data
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let noteModelToDelete = fetchedResultsController.object(at: indexPath)
            dataStoreManager.deleteNote(object: noteModelToDelete)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let destinationVC = DetailsViewController()
//        let noteModel = fetchedResultsController.object(at: indexPath)
//        destinationVC.data = noteModel
//        navigationController?.pushViewController(destinationVC, animated: true)
    }
}

// MARK: - NSFetchedResultsControllerDelegate

extension HomeViewController: NSFetchedResultsControllerDelegate {
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let indexPath = indexPath {
                notesTableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                notesTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        default:
            break
        }
    }
}
