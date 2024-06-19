//
//  ImageFeedTests.swift
//  ImageFeedTests
//
//  Created by Владимир Горбачев on 21.03.2024.
//

@testable import ImageFeed
import XCTest

final class WebViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let presenter = WebViewPresenterSpy()
        let viewController = WebViewViewController()
        viewController.presenter = presenter
        presenter.view = viewController
        _ = viewController.view
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterCallsLoadRequest() {
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        let viewController = WebViewViewControllerSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.viewDidLoad()
        XCTAssertTrue(viewController.loadCalled)
    }
    
    func testProgressVisibleWhenLessThenOne() {
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        let shouldHideProgress = presenter.shouldHideProgress(for: 0.6)
        XCTAssertFalse(shouldHideProgress)
    }
    
    func testProgressHiddenWhenOne() {
        let presenter = WebViewPresenter(authHelper: AuthHelper())
        let shouldHideProgress = presenter.shouldHideProgress(for: 1)
        XCTAssertTrue(shouldHideProgress)
    }
    
    func testAuthHelperAuthURL() {
        let configuration = AuthConfiguration.standard
        let authHelper = AuthHelper(configuration: configuration)
        let url = authHelper.authURL()
        XCTAssertNotNil(url)
        guard let url else { return }
        let urlString = url.absoluteString
        XCTAssertTrue(urlString.contains(configuration.authURLString))
        XCTAssertTrue(urlString.contains(configuration.accessKey))
        XCTAssertTrue(urlString.contains(configuration.redirectURI))
        XCTAssertTrue(urlString.contains("code"))
        XCTAssertTrue(urlString.contains(configuration.accessScope))
    }
    
    func testCodeFromURL() {
        let urlComponents = URLComponents(string: "https://unsplash.com/oauth/authorize/native")
        XCTAssertNotNil(urlComponents)
        guard var urlComponents else { return }
        urlComponents.queryItems = [URLQueryItem(name: "code", value: "test code")]
        let url = urlComponents.url
        XCTAssertNotNil(url)
        guard let url else { return }
        let authHelper = AuthHelper()
        let code = authHelper.code(from: url)
        XCTAssertEqual(code, "test code")
    }
}

final class WebViewPresenterSpy: WebViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: WebViewViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func didUpdateProgressValue(_ newValue: Double) {
    
    }
    
    func code(from url: URL) -> String? {
        return nil
    }
}

final class WebViewViewControllerSpy: WebViewViewControllerProtocol {
    var loadCalled: Bool = false
    var presenter: WebViewPresenterProtocol?
    
    func load(request: URLRequest) {
        loadCalled = true
    }
    func setProgressValue(_ newValue: Float) {
        
    }
    func setProgressHidden(_ isHidden: Bool) {
        
    }
}
