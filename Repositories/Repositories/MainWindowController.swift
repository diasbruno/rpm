import Cocoa

class NavigationDelegate {
    weak var windowController: MainWindowController? = nil

    func addRepository(_ name: String, _ path: String) {
        RepositoryService.shared.add(name, path)
    }
    
    func deleteRepository(_ repo: Repository) {
        RepositoryService.shared.delete(repo)
    }
    
    func changeViewController(_ viewController: NSViewController) {
        self.windowController?.setContentViewController(viewController)
    }

    func goToCreate() {
        let vc = windowController?.createViewController()
        vc!.delegate = self
        self.changeViewController(vc!)
    }

    func goToManager() {
        let vc = windowController?.managerViewController()
        vc!.delegate = self
        self.changeViewController(vc!)
    }
}

class MainWindowController: NSWindowController {
    var delegate: NavigationDelegate = NavigationDelegate()

    enum View: String {
        case create = "create", manager = "manager"
    }

    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.title = "Repositories"
        self.delegate.windowController = self
        self.delegate.goToManager()
    }

    func setContentViewController(_ viewController: NSViewController) {
        self.window?.contentViewController = viewController
    }

    fileprivate func findController(_ view: View) -> NSViewController {
        return (storyboard?.instantiateController(identifier: view.rawValue))!
    }

    fileprivate func createViewController() -> CreateViewController {
        return self.findController(.create) as! CreateViewController
    }

    fileprivate func managerViewController() -> ManagerViewController {
        return self.findController(.manager) as! ManagerViewController
    }
}
