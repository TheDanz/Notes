import UIKit

class DetailsViewController: UIViewController {
    
    lazy var headerTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "Avenir Next Bold", size: 30)
        textView.backgroundColor = #colorLiteral(red: 0.7823485341, green: 0.5645258996, blue: 0.1184541641, alpha: 1)
        textView.textContainer.maximumNumberOfLines = 1
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    lazy var noteTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont(name: "Avenir Next", size: 15)
        textView.backgroundColor = #colorLiteral(red: 0.7823485341, green: 0.5645258996, blue: 0.1184541641, alpha: 1)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    var data: NoteModel? {
        didSet {
            guard let data = data else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.headerTextView.text = DataStoreManager.shared.getHeader(for: data)
                self.noteTextView.text = DataStoreManager.shared.getText(for: data)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.7823485341, green: 0.5645258996, blue: 0.1184541641, alpha: 1)
        
        headerTextView.delegate = self
        noteTextView.delegate = self
        
        view.addSubview(headerTextView)
        view.addSubview(noteTextView)
        setupAllConstraints()
    }
    
    @objc
    func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    private func setupAllConstraints() {
        setupHeaderTextViewConstraints()
        setupNoteTextViewConstraints()
    }

    
    private func setupHeaderTextViewConstraints() {
        headerTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        headerTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        headerTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        headerTextView.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func setupNoteTextViewConstraints() {
        noteTextView.topAnchor.constraint(equalTo: headerTextView.bottomAnchor, constant: 0).isActive = true
        noteTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        noteTextView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        noteTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
    }
    
}

extension DetailsViewController: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        switch textView {
        case headerTextView:
            if let text = self.headerTextView.text {
                DataStoreManager.shared.updateHeader(for: data!, header: text)
                DataStoreManager.shared.updateModifiedDate(for: data!, date: Date())
            }
        case noteTextView:
            if let text = self.noteTextView.text {
                DataStoreManager.shared.updateNote(for: data!, text: text)
                DataStoreManager.shared.updateModifiedDate(for: data!, date: Date())
            }
        default:
            break
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        switch textView {
        case headerTextView:
            if textView.text.isEmpty {
                DataStoreManager.shared.updateHeader(for: data!, header: "No header")
                DataStoreManager.shared.updateModifiedDate(for: data!, date: Date())
            }
        default:
            break
        }
    }
}
