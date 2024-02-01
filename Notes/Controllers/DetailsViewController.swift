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
        textView.backgroundColor = #colorLiteral(red: 0.7823485341, green: 0.5645258996, blue: 0.1184541641, alpha: 1)
        textView.allowsEditingTextAttributes = true
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
                let font = DataStoreManager.shared.getFont(for: data)
                let fontSize = DataStoreManager.shared.getFontSize(for: data)
                self.noteTextView.font = UIFont(name: font ?? "Avenir Next", size: CGFloat(fontSize ?? 15))
            }
        }
    }
    
    private var options = ["Avenir Next", "Times New Roman", "American Typewriter", "Rockwell", "Helvetica", "Copperplate"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = #colorLiteral(red: 0.7823485341, green: 0.5645258996, blue: 0.1184541641, alpha: 1)
        
        headerTextView.delegate = self
        noteTextView.delegate = self
        
        view.addSubview(headerTextView)
        view.addSubview(noteTextView)
        
        setupAllConstraints()
        createBarButtons()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard (_:)))
                self.view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateNavigationBarColor), name: Notification.Name(rawValue: "AppleInterfaceThemeChangedNotification"), object: nil)
        updateNavigationBarColor()
    }
    
    private func createBarButtons() {
        let fontButton = UIBarButtonItem(image: UIImage(systemName: "arrow.down"),
                                             style: .plain, target: self,
                                             action: #selector(decreaseFontSizeButtonClick))
        
        let fontSizeButton = UIBarButtonItem(image: UIImage(systemName: "arrow.up"),
                                        style: .plain, target: self,
                                        action: #selector(increaseFontSizeButtonClick))
        
        let changeFontButton = UIBarButtonItem(image: UIImage(systemName: "textformat"),
                                               style: .plain, target: self,
                                               action: #selector(changeFontButtonClick))
        
        navigationItem.rightBarButtonItems = [fontButton, fontSizeButton, changeFontButton]
    }
    
    @objc 
    private func updateNavigationBarColor() {
        if traitCollection.userInterfaceStyle == .dark {
            navigationController?.navigationBar.tintColor = .white
        } else {
            navigationController?.navigationBar.tintColor = .black
        }
    }

    @objc
    func dismissKeyboard (_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @objc
    private func decreaseFontSizeButtonClick() {
        var newFontSize = DataStoreManager.shared.getFontSize(for: data!)! - 1
        if newFontSize < 10 {
            newFontSize = 10
        }
        let currentFontName = DataStoreManager.shared.getFont(for: data!)
        noteTextView.font = UIFont(name: currentFontName!, size: CGFloat(newFontSize))
        DataStoreManager.shared.updateFontSize(for: data!, fontSize: newFontSize)
    }
        
    @objc
    private func increaseFontSizeButtonClick() {
        var newFontSize = DataStoreManager.shared.getFontSize(for: data!)! + 1
        if newFontSize > 80 {
            newFontSize = 80
        }
        let currentFontName = DataStoreManager.shared.getFont(for: data!)
        noteTextView.font = UIFont(name: currentFontName!, size: CGFloat(newFontSize))
        DataStoreManager.shared.updateFontSize(for: data!, fontSize: newFontSize)
    }
    
    @objc
    private func changeFontButtonClick() {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        pickerView.delegate = self
        pickerView.dataSource = self
        vc.view.addSubview(pickerView)
        let alert = UIAlertController(title: "Choose a font", message: "", preferredStyle: .alert)
        alert.setValue(vc, forKey: "contentViewController")
        let actionDone = UIAlertAction(title: "Done", style: .default)
        alert.addAction(actionDone)
        self.present(alert, animated: true)
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

extension DetailsViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return options.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return options[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let newFontName = options[row]
        let currentFontSize = DataStoreManager.shared.getFontSize(for: data!)
        noteTextView.font = UIFont(name: newFontName, size: CGFloat(currentFontSize!))
        DataStoreManager.shared.updateFont(for: data!, font: newFontName)
    }
}
