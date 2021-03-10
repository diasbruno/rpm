import Cocoa

fileprivate func selectedColor(_ isSelected: Bool) -> CGColor {
    isSelected ? NSColor.selectedControlColor.cgColor : NSColor.clear.cgColor
}

class Item: NSCollectionViewItem {
    weak var item: Repository? = nil;

    @IBOutlet var label: NSTextField? = nil
    @IBOutlet var button: NSButton? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.wantsLayer = true
    }
    
    override var isSelected: Bool {
        didSet {
            super.isSelected = isSelected
            self.view.layer?.backgroundColor = selectedColor(isSelected)
        }
    }
    
    @IBAction func onClick(_ sender: NSObject) {
        let name: NSNotification.Name = NSNotification.Name(rawValue: "removeRepo")
        NotificationCenter.default.post(name: name, object: self.item)
    }
}

private func layout() -> NSCollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let goupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(30))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: goupSize, subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    let layout = NSCollectionViewCompositionalLayout(section: section)
    return layout
}

class ListViewController: NSViewController, NSCollectionViewDataSource, NSCollectionViewDelegate {
    static var ident = NSUserInterfaceItemIdentifier(rawValue: "repoItem")

    @IBOutlet var collectionView: NSCollectionView? = nil;
    
    var delegate: NavigationDelegate? = nil;
    
    var content: [Repository] = []
    var onRemoveRepo: NSObjectProtocol? = nil;

    override var representedObject: Any? { didSet {} }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.register(Item.self, forItemWithIdentifier: ListViewController.ident)
        self.content = RepositoryService.shared.getAll()
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        self.collectionView?.isSelectable = true
        self.collectionView?.collectionViewLayout = layout()
        
        self.onRemoveRepo = NotificationCenter.default.addObserver(forName: RepositoryAction.notificationName(.remove), object: nil, queue: nil, using: self.removeRepository)
    }
    
    override func viewWillDisappear() {
        NotificationCenter.default.removeObserver(self.onRemoveRepo!)
        self.onRemoveRepo = nil
    }

    private func removeRepository(_ event: Notification) -> Void {
        RepositoryService.shared.delete(event.object as! Repository)
        self.content = RepositoryService.shared.getAll()
        self.collectionView?.reloadData()
    }
    
    @IBAction func onClick(_ sender: NSObject) {
        self.delegate?.goToCreate()
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        self.content.count
    }
    
    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let view = collectionView.makeItem(withIdentifier: ListViewController.ident, for: indexPath) as! Item
        let item: Repository = self.content[indexPath.item]
        view.label!.stringValue = item.name
        view.item = item
        return view
    }
    
    func collectionView(_ collectionView: NSCollectionView,
                        didSelectItemsAt indexPaths: Set<IndexPath>) {
        guard let firstSelected = indexPaths.first?.item
        else { return }
        let item: Repository = self.content[firstSelected]
        NotificationCenter.default.post(name: RepositoryAction.notificationName(.selected), object: item)
    }
    
}
