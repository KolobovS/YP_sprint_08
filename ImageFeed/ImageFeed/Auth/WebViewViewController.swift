import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
}

public protocol WebViewViewControllerProtocol: AnyObject {
    var presenter: WebViewPresenterProtocol? { get set }
    
    func load(request: URLRequest)
    func setProgressValue(_ newValue: Float)
    func setProgressHidden(_ isHidden: Bool)
}

final class WebViewViewController: UIViewController, WebViewViewControllerProtocol {
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.navigationDelegate = self
        webView.accessibilityIdentifier = "UnsplashWebView"
        return webView
    }()
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressViewStyle = .default
        progressView.tintColor = .imageFeedBlack
        progressView.progressTintColor = .imageFeedBlack
        progressView.backgroundColor = .none
        return progressView
    }()
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "BackwardBlack"), for: .normal)
        button.addTarget(self, action: #selector(touchUpInsideBackButton), for: .touchUpInside)
        return button
    }()
    
    var presenter: WebViewPresenterProtocol?
    weak var delegate: WebViewViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
            options: [],
            changeHandler: { [weak self] _, _ in
                guard let progress = self?.webView.estimatedProgress else { return }
                self?.presenter?.didUpdateProgressValue(progress)
            }
        )
        presenter?.viewDidLoad()
    }
    
    func load(request: URLRequest) {
        webView.load(request)
    }
    
    private func setupWebView() {
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        view.addSubviewWithoutAutoresizingMask(webView)
        view.addSubviewWithoutAutoresizingMask(backButton)
        view.addSubviewWithoutAutoresizingMask(progressView)
    }

    private func applyConstraints() {
        NSLayoutConstraint.activate([
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9)
        ])
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            progressView.topAnchor.constraint(equalTo: backButton.bottomAnchor)
        ])
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func setProgressValue(_ newValue: Float) {
        progressView.setProgress(newValue, animated: true)
    }

    func setProgressHidden(_ isHidden: Bool) {
        progressView.isHidden = isHidden
        if progressView.isHidden {
            progressView.setProgress(0, animated: false)
        }
    }
    
    // MARK: - Actions
    
    @objc func touchUpInsideBackButton(_ sender: Any) {
        delegate?.webViewViewControllerDidCancel(self)
    }
}

extension WebViewViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, 
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    private func code(from navigationAction: WKNavigationAction) -> String? {
        guard let url = navigationAction.request.url else { return nil }
        return presenter?.code(from: url)
    }
}
