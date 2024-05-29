import UIKit

final class AuthViewController: UIViewController {
    private let showWebViewIdentifier = "ShowWebView"
    weak var delegate: AuthViewControllerDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "ShowWebView" {
            let authView = segue.destination as? WebViewViewController
            if let unwrappedView = authView {
                unwrappedView.delegate = self
            }
        }
    }
}
extension AuthViewController: WebViewViewControllerDelegate {
    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        dismiss(animated: true)
    }

    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        delegate?.fetchAuthToken(code: code)
    }
}

protocol AuthViewControllerDelegate: AnyObject {
    func fetchAuthToken(code: String)
}
