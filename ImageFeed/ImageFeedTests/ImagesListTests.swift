@testable import ImageFeed
import XCTest

final class ImagesListTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let presenter = ImagesListViewPresenterSpy()
        let viewController = ImagesListViewController()
        viewController.presenter = presenter
        presenter.view = viewController
        _ = viewController.view
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testViewControllerNeedCallShowNextPhotos() {
        let presenter = ImagesListViewPresenterSpy()
        presenter.photosCount = 0
        let viewController = ImagesListViewController()
        viewController.presenter = presenter
        presenter.view = viewController
        _ = viewController.view
        XCTAssertTrue(presenter.getNextPhotosCalled)
    }
    
    func testViewPresenterNotNeedCallShowNextPhotos() {
        let presenter = ImagesListViewPresenterSpy()
        presenter.photosCount = 20
        let viewController = ImagesListViewController()
        viewController.presenter = presenter
        presenter.view = viewController
        _ = viewController.view
        XCTAssertFalse(presenter.getNextPhotosCalled)
    }
}

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var getNextPhotosCalled: Bool = false
    
    var view: ImagesListViewControllerProtocol?
    
    var photosCount: Int = 0
    
    func viewDidLoad() {
        viewDidLoadCalled = true
        getNextPhotos(0)
    }
    
    func getNextPhotos(_ lastShowedPhotoIndex: Int) {
        if lastShowedPhotoIndex == photosCount {
            view?.showNextPhotos(from: lastShowedPhotoIndex, to: photosCount)
            getNextPhotosCalled = true
        }
    }
    
    func changeLike(_ photoIndex: Int, completion: @escaping (_ : Bool?) -> Void) {
        
    }
}

final class ImagesListViewControllerSpy: ImagesListViewControllerProtocol {
    var showNextPhotosCalled: Bool = false
    var presenter: ImagesListViewPresenterProtocol?
    
    func showNextPhotos(from firstPhotoIndex: Int, to lastPhotoIndex: Int) {
        showNextPhotosCalled = true
    }
}
