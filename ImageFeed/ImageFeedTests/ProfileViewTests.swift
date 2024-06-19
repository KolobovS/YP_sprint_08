//
//  ProfileViewTests.swift
//  ImageFeedTests
//
//  Created by Владимир Горбачев on 23.03.2024.
//

@testable import ImageFeed
import XCTest

final class ProfileViewTests: XCTestCase {
    func testViewControllerCallsViewDidLoad() {
        let presenter = ProfileViewPresenterSpy()
        let viewController = ProfileViewController()
        viewController.presenter = presenter
        presenter.view = viewController
        _ = viewController.view
        XCTAssertTrue(presenter.viewDidLoadCalled)
    }
    
    func testPresenterGetAvatarGetProfile() {
        let presenter = ProfileViewPresenterSpy()
        let viewController = ProfileViewControllerSpy()
        viewController.presenter = presenter
        presenter.view = viewController
        presenter.viewDidLoad()
        XCTAssertTrue(viewController.setAvatarCalled)
        XCTAssertTrue(viewController.setProfileDetailsCalled)
    }
}

final class ProfileViewPresenterSpy: ProfileViewPresenterProtocol {
    var viewDidLoadCalled: Bool = false
    var view: ProfileViewControllerProtocol?
    
    func viewDidLoad() {
        viewDidLoadCalled = true
        getProfileDetails()
        getAvatar()
    }

    func getAvatar() {
        guard let url = URL(string: "https://unsplash.com") else { return }
        view?.setAvatar(url)
    }
    
    func getProfileDetails() {
        let profileResponce = ProfileResponseBody(id: "testID", userName: "User name", firstName: "First name", lastName: nil, bio: nil)
        let profile = Profile(profileResponseBody: profileResponce)
        view?.setProfileDetails(profile)
    }
    
    func logout() {
        
    }
}

final class ProfileViewControllerSpy: ProfileViewControllerProtocol {
    var setAvatarCalled: Bool = false
    var setProfileDetailsCalled: Bool = false
    
    var presenter: ProfileViewPresenterProtocol?
    
    func setAvatar(_ url: URL) {
        setAvatarCalled = true
    }
    
    func setProfileDetails(_ profile: Profile) {
        setProfileDetailsCalled = true
    }
}
