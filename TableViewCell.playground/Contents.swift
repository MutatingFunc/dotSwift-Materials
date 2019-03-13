//: # Using UIViews as UITableViewCells
  
import UIKit
import PlaygroundSupport

extension UIView {
    func constrainAllSides(toSuperview superview: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: superview.topAnchor, constant: 8),
            self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 8),
            superview.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 8),
            superview.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 8)
        ])
    }
}

//: ### Reusable generic implementation

class TableViewCell<View: UIView>: UITableViewCell {
    var cellView: View? {
        didSet {
            if oldValue != nil {
                oldValue?.removeFromSuperview()
            }
            setUpViews()
        }
    }
    
    private func setUpViews() {
        guard let cellView = cellView else { return }
        
        contentView.addSubview(cellView)
        
        cellView.constrainAllSides(toSuperview: contentView)
    }
}

//: ### Example Table View Controller
//: Creates UILabels with cells from 0 to 24, and displays them in cells

class TableVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let tableView = UITableView()
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        tableView.constrainAllSides(toSuperview: self.view)
        
        tableView.register(TableViewCell<UILabel>.self, forCellReuseIdentifier: "labelcell")
    }
    
}

extension TableVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 24
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "labelcell") as! TableViewCell<UILabel>
        
        cell.cellView = labelForIndex(indexPath.row)
        
        return cell
    }
    func labelForIndex(_ index: Int) -> UILabel {
        let label = UILabel()
        label.text = "\(index)"
        label.textAlignment = .right
        return label
    }
    
}

//: View Controller → Assistant Editor

PlaygroundPage.current.liveView = TableVC()
