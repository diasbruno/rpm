//
//  ManagerViewController.swift
//  Repositories
//
//  Created by Bruno Henrique Dias on 07/03/21.
//

import Cocoa

class ManagerViewController: NSSplitViewController {
    var delegate: NavigationDelegate? = nil;
    
    weak var list: ListViewController? = nil;
    var detailViewController: DetailViewController? = nil;
    
    weak var onSelectedRepo: NSObjectProtocol? = nil;
    
    weak var selectedRepo: Repository? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.list = self.splitViewItems[0].viewController as? ListViewController
        self.list?.delegate = self.delegate
        
        self.onSelectedRepo = NotificationCenter.default.addObserver(forName: RepositoryAction.notificationName(.selected), object: nil, queue: nil, using: self.selectRepo)
    }
    
    private func selectRepo(_ event: Notification) -> Void {
        self.selectedRepo = event.object as? Repository
        
        let v: DetailViewController = self.splitViewItems[1].viewController as! DetailViewController
        v.item = self.selectedRepo
        v.updateInformation()
    }
    
    override func viewWillDisappear() {
        NotificationCenter.default.removeObserver(self.selectRepo)
        self.onSelectedRepo = nil
    }

    override var representedObject: Any? {
        didSet {}
    }
}
