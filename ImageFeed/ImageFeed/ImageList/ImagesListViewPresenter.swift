//
//  ImageListViewPresenter.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 23.03.2024.
//

import Foundation

public protocol ImagesListViewPresenterProtocol {
    var view: ImagesListViewControllerProtocol? { get set }
    
    func viewDidLoad()
    func getNextPhotos(_ lastShowedPhotoIndex: Int)
    func changeLike(_ photoIndex: Int, completion: @escaping (_ : Bool?) -> Void)
}

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    private let imagesListService = ImagesListService.shared
    private var imagesListServiceObserver: NSObjectProtocol?
    
    func viewDidLoad() {
        imagesListService.fetchPhotosNextPage()
        imagesListServiceObserver = NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            guard let self, let lastLoadedPhotosCount = self.imagesListService.lastLoadedPhotosCount, lastLoadedPhotosCount > 0 else { return }
            let photosCount = self.imagesListService.photos.count
            self.view?.showNextPhotos(from: photosCount - lastLoadedPhotosCount, to: photosCount)
        }
    }
    
    func getNextPhotos(_ lastShowedPhotoIndex: Int) {
        if lastShowedPhotoIndex == imagesListService.photos.count {
            imagesListService.fetchPhotosNextPage()
        }
    }
    
    func changeLike(_ photoIndex: Int, completion: @escaping (_ : Bool?) -> Void) {
        let photo = imagesListService.photos[photoIndex]
        imagesListService.changeLike(photoId: photo.id, isLike: !photo.isLiked) { [weak self] (result: Result<Void, Error>) in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success():
                    return completion(self.imagesListService.photos[photoIndex].isLiked)
                case .failure(_):
                    return completion(nil)
                }
            }
        }
    }
}
