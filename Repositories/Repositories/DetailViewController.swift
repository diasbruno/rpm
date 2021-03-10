//
//  DetailViewController.swift
//  Repositories
//
//  Created by Bruno Henrique Dias on 09/03/21.
//

import Cocoa

class DetailViewController: NSViewController {
    weak var item: Repository? = nil
    
    @IBOutlet var nameLabel: NSTextField? = nil
    @IBOutlet var pathLabel: NSTextField? = nil
    
    var branches: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateInformation()
    }
    
    func updateInformation() {
        guard let item = self.item else { return }
        self.nameLabel!.stringValue = item.name
        self.pathLabel!.stringValue = item.path
        
        self.readBranches()
    }
    
    fileprivate func readBranches() {
        do {
            var path: String = String(self.item!.path) as String
            path.append("/.git/refs/heads/")
            let urls = try FileManager.default.contentsOfDirectory(at: URL(fileURLWithPath: path), includingPropertiesForKeys: [.isDirectoryKey], options: .skipsHiddenFiles)
            self.branches = urls.map { $0.lastPathComponent }
        } catch {
            print(error)
        }
    }
    
    override var representedObject: Any? { didSet {} }
}
