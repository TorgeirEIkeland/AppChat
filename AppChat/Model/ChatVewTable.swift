import UIKit
class MyViewController : UIViewController {
    var myCollectionView:UICollectionView?
    
    var colorList: [UIColor] = [.blue, .red, .orange,.blue, .red, .orange,.blue, .red, .orange,.blue, .red, .orange,.blue, .red, .orange,.blue, .red, .orange,.blue, .red, .orange,.blue, .red, .orange,.blue, .red, .orange,.blue, .red, .orange,.blue, .red, .orange,.blue, .red, .orange,.blue, .red, .orange,.blue, .red, .orange,.blue, .red, .orange,.blue, .red, .orange,.blue, .red, .orange,.blue, .red, .orange,.blue, .red, .orange,.blue, .red, .orange,.blue, .red, .orange,.blue, .red, .orange,.blue, .red, .orange,.blue, .red, .orange,.blue, .red, .orange,.blue, .red, .orange,.blue, .red, .orange]
    
    var messageList: [Message] = [Message(sender: "Torgeir", message: "Melding fra Torgeir"), Message(sender: "Lasse", message: "Melding fra Lasse"),Message(sender: "Torgeir", message: "Melding fra Torgeir"), Message(sender: "Lasse", message: "Melding fra Lasse"),Message(sender: "Torgeir", message: "Melding fra Torgeir"), Message(sender: "Lasse", message: "Melding fra Lasse")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let view = UIView()
        view.backgroundColor = .white
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        layout.estimatedItemSize = CGSize(width: (self.view.frame.size.width-20), height: 150)
        
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView?.register(CustomCell.self, forCellWithReuseIdentifier: "MyCell")
        myCollectionView?.backgroundColor = UIColor.white
        layout.scrollDirection = .vertical
        
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
 
        view.addSubview(myCollectionView ?? UICollectionView())
        
        self.view = view
    }
}
extension MyViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messageList.count// How many cells to display
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! CustomCell
        myCell.text = messageList[indexPath.row].message
        myCell.sender = messageList[indexPath.row].sender
        return myCell
    }
}
extension MyViewController: UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       print("User tapped on item \(indexPath.row)")
    }
}

class CustomCell: UICollectionViewCell {
    
    var loggedInUser: String = "Torgeir"
    lazy var sender: String? = "" {
        didSet {
            setupConstraints()
            label.updateConstraints()
            containerView.updateConstraints()
            if loggedInUser != sender {
                print("no the same")
            }
            print("wants to update constraint")
        }
    }
    lazy var text: String? = "text didnt send" {
        didSet {
            label.text = text
        }
    }
    
    var chatBox: UIView = {
        let view = UIView()
        view.backgroundColor = .blue
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var label: UILabel = {
        let l = UILabel()
        l.text = text
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(r: 80, g: 101, b: 161)

        self.addSubview(containerView)
        containerView.addSubview(label)
        containerView.addSubview(chatBox)
        setupConstraints()
        
        
        print("ViewLoaded")
    }
    
    func setupConstraints() {
        containerView.anchor(top: self.topAnchor, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: self.trailingAnchor)
        containerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        


        
        if sender != loggedInUser {
            label.anchor(
                top: containerView.topAnchor,
                leading: containerView.leadingAnchor,
                bottom: containerView.bottomAnchor,
                trailing: nil
            )

        } else {
            label.anchor(
                top: containerView.topAnchor,
                leading: nil,
                bottom: containerView.bottomAnchor,
                trailing: containerView.trailingAnchor
            )
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

struct Message {
    let sender: String
    let message: String
}
