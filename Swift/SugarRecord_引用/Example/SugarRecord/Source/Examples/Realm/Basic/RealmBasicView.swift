import Foundation
import UIKit
import SugarRecord
import RealmSwift

class RealmBasicView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Attributes
    lazy var db: RealmDefaultStorage = {
        var configuration = Realm.Configuration()
        configuration.fileURL = URL(fileURLWithPath: databasePath("realm-basic"))
        let _storage = RealmDefaultStorage(configuration: configuration)
        return _storage
    }()
    lazy var tableView: UITableView = {
        let _tableView = UITableView(frame: CGRect.zero, style: UITableViewStyle.plain)
        _tableView.translatesAutoresizingMaskIntoConstraints = false
        _tableView.delegate = self
        _tableView.dataSource = self
        _tableView.register(UITableViewCell.classForCoder(), forCellReuseIdentifier: "default-cell")
        return _tableView
    }()
    var entities: [RealmBasicEntity] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    
    // MARK: - Init
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Realm Basic"
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("🚀🚀🚀 Deallocating \(self) 🚀🚀🚀")
    }
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        updateData()
    }
    
    
    // MARK: - Private
    
    fileprivate func setup() {
        setupView()
        setupNavigationItem()
        setupTableView()
    }
    
    fileprivate func setupView() {
        self.view.backgroundColor = UIColor.white
    }
    
    fileprivate func setupNavigationItem() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add, target: self, action: #selector(RealmBasicView.userDidSelectAdd(_:)))
    }
    
    fileprivate func setupTableView() {
        self.view.addSubview(tableView)
        self.tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view)
        }
    }
    
    
    // MARK: - UITableViewDataSource / UITableViewDelegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "default-cell")!
        cell.textLabel?.text = "\(entities[(indexPath as NSIndexPath).row].name) - \(entities[(indexPath as NSIndexPath).row].dateString)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let name = entities[(indexPath as NSIndexPath).row].name
            try! db.operation({ (context, save) -> Void in
                guard let obj = try! context.request(RealmBasicObject.self).filtered(with: "name", equalTo: name).fetch().first else { return }
                _ = try? context.remove(obj)
                save()
            })
            updateData()
        }
    }
    
    
    // MARK: - Actions
    
    func userDidSelectAdd(_ sender: AnyObject!) {
        try! db.operation { (context, save) -> Void in
            let _object: RealmBasicObject = try! context.new()
            _object.date = Date()
            _object.name = randomStringWithLength(10) as String
            try! context.insert(_object)
            save()
        }
        updateData()
    }
    
    
    // MARK: - Private
    
    fileprivate func updateData() {
        self.entities = try! db.fetch(FetchRequest<RealmBasicObject>()).map(RealmBasicEntity.init)
    }
}
