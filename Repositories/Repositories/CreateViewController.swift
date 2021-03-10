import Cocoa


func openFolderSelection() -> Void
{
    let openPanel = NSOpenPanel()
    openPanel.allowsMultipleSelection = false
    openPanel.canChooseDirectories = true
    openPanel.canCreateDirectories = false
    openPanel.canChooseFiles = false
    openPanel.begin
        { (result) -> Void in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue
            {
                let url = openPanel.url
                NotificationCenter.default.post(name: RepositoryAction.notificationName(.selectedDirectory), object: url)
            }
    }
}

class CreateViewController: NSViewController {
    @IBOutlet private var nameTextField: NSTextField?;
    @IBOutlet private var pathTextField: NSTextField?;

    var delegate: NavigationDelegate? = nil;
    
    var onSelectedDirectory: NSObjectProtocol? = nil;

    override func viewDidLoad() {
        super.viewDidLoad()
        self.onSelectedDirectory = NotificationCenter.default.addObserver(forName: RepositoryAction.notificationName(.selectedDirectory), object: nil, queue: nil, using: self.selectedDirectory)
    }

    override func viewWillDisappear() {
        NotificationCenter.default.removeObserver(self.selectedDirectory)
        self.onSelectedDirectory = nil
    }
    
    override var representedObject: Any? {
        didSet {}
    }

    @IBAction private func doneButtonClick(_ obj: NSButton) {
        let name = self.nameTextField!.stringValue
        let path = self.pathTextField!.stringValue
        self.delegate?.addRepository(name, path)
        self.delegate?.goToManager()
    }

    @IBAction private func cancelButtonClick(_ obj: NSButton) {
        self.delegate?.goToManager()
    }
    
    @IBAction private func selectDirectory(_ obj: NSButton) {
        let _ = openFolderSelection()
    }
    
    private func selectedDirectory(_ event: Notification) {
        let url = event.object as! URL
        self.pathTextField!.stringValue = url.path
        self.nameTextField!.stringValue = url.lastPathComponent
    }
}

extension CreateViewController: NSTextFieldDelegate {
    func controlTextDidChange(_ obj: Notification) {}
}
