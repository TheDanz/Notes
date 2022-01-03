//
//  ViewController.swift
//  Notes
//
//  Created by Danil Ryumin on 31.12.2021.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var notes:[NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        setNoteButtonToView()
        getFetchRequest()
    }
    
    private func setNoteButtonToView() {
        let button = UIButton()
        button.setBackgroundImage(#imageLiteral(resourceName: "plusButtonIcon"), for: .normal)
        button.addTarget(self, action: #selector(handlerCreateNewButtonPressed), for: .touchUpInside)
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 70).isActive = true
        button.widthAnchor.constraint(equalToConstant: 70).isActive = true
    }
    
    @objc func handlerCreateNewButtonPressed() {
        let alert = UIAlertController(title: "Create note", message: "", preferredStyle: .alert)
        alert.addTextField { textField in
              textField.placeholder = "Enter note..."
            }
        let cancel = UIAlertAction(title: "cancel", style: .default, handler: nil)
        let create = UIAlertAction(title: "create", style: .cancel) { [unowned self] action in
            guard let textField = alert.textFields?.first, let noteSave = textField.text else { return }
            
            self.save(text: noteSave)
            tableView.reloadData()
           }
        alert.addAction(create)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }

    func save(text: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Note", in: managedContext)!
        let note = NSManagedObject(entity: entity, insertInto: managedContext)
        note.setValue(text, forKey: "noteName")
        do {
            try managedContext.save()
            notes.append(note)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    func getFetchRequest() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Note")
        do {
            notes = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }

    func editNote(_ index: IndexPath) {
        let alert = UIAlertController(title: "Edit note", message: "Change note", preferredStyle: .alert)
        let save = UIAlertAction(title: "save", style: .cancel) { [unowned self] action in
              guard let textField = alert.textFields?.first, let noteSave = textField.text else { return }
                    let oldText = self.notes[index.row].value(forKey: "noteName") as! String
                    self.update(oldText: oldText, newText: noteSave)
                    tableView.reloadData()
            }
        let cancel = UIAlertAction(title: "cancel", style: .default, handler: nil)
        alert.addTextField { textField in
            textField.text = self.notes[index.row].value(forKey: "noteName") as? String
        }
        alert.addAction(save)
        alert.addAction(cancel)
        present(alert, animated: true)
    }

    func update(oldText: String, newText: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
        fetchRequest.predicate = NSPredicate(format: "noteName = %@", oldText)
        let results = try! managedContext.fetch(fetchRequest) as? [NSManagedObject]
        if results?.count != 0 {
              results![0].setValue(newText, forKey: "noteName")
            }
        try! managedContext.save()
    }

    func delete(by indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        managedContext.delete(notes[indexPath.row])
        notes.remove(at: indexPath.row)
        try! managedContext.save()
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        editNote(indexPath)
      }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
      }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delete(by: indexPath)
        }
      }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = notes[indexPath.row].value(forKey: "noteName") as? String
        cell.textLabel?.textColor = #colorLiteral(red: 0.5058823824, green: 0.3372549117, blue: 0.06666667014, alpha: 1)
        cell.backgroundColor = #colorLiteral(red: 0.9600886703, green: 0.9261525273, blue: 0.8534681797, alpha: 1)
        cell.textLabel?.font = UIFont(name: "System", size: 20)
        return cell
    }
}
