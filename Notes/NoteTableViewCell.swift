import UIKit

class NoteTableViewCell: UITableViewCell {
    
    static let identifier = "NoteTableViewCell"
    
    lazy var mainView: UIView = {
        var view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 345, height: 100)
        view.layer.cornerRadius = 12
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 1, height: 5)
        view.backgroundColor = #colorLiteral(red: 0.9202577243, green: 0.6595746663, blue: 0.2539399565, alpha: 0.8)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(view)
        return view
    }()
    
    lazy var headerLabel: UILabel = {
        var view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 310, height: 40)
        view.font = UIFont(name: "Avenir Next Demi Bold", size: 20)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.mainView.addSubview(view)
        return view
    }()
    
    lazy var dateLabel: UILabel = {
        var view = UILabel()
        view.frame = CGRect(x: 0, y: 0, width: 310, height: 40)
        view.font = UIFont(name: "Avenir Next", size: 16)
        view.translatesAutoresizingMaskIntoConstraints = false
        self.mainView.addSubview(view)
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = #colorLiteral(red: 0.7823485341, green: 0.5645258996, blue: 0.1184541641, alpha: 1)
        
        setupAllConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupAllConstraints() {
        setupMainViewConstraints()
        setupHeaderLabelConstraints()
        setupDateLabelConstraints()
    }
    
    private func setupMainViewConstraints() {
        mainView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        mainView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24).isActive = true
        mainView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -24).isActive = true
        mainView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    private func setupHeaderLabelConstraints() {
        headerLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        headerLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10).isActive = true
        headerLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 18).isActive = true
        headerLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -17).isActive = true
    }
    
    private func setupDateLabelConstraints() {
        dateLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        dateLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 0).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 18).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -17).isActive = true
    }
}
