//
//  ImagesListService.swift
//  ImageFeed
//
//  Created by Владимир Горбачев on 29.02.2024.
//

import Foundation

final class ImagesListService {
    private enum ImagesListServiceError: Error {
        case photosError
    }
    
    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(rawValue: "ImagesListServiceDidChange")
    
    private(set) var photos: [Photo] = []
    private weak var taskPhotos: URLSessionTask?
    private weak var taskLikes: URLSessionTask?
    private var lastLoadedPage: Int?
    private(set) var lastLoadedPhotosCount: Int?
    private var configuration: AuthConfiguration = .standard
    
    private init() { }
    
    func fetchPhotosNextPage() {
        assert(Thread.isMainThread)
        if taskPhotos != nil { return }
        let nextPage = (lastLoadedPage ?? 0) + 1
        lastLoadedPhotosCount = 0
        guard var urlComponents = URLComponents(url: configuration.defaultBaseURL, resolvingAgainstBaseURL: false) else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "page", value: String(nextPage))
        ]
        urlComponents.path = "/photos"
        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(OAuth2TokenStorage.token ?? "")", forHTTPHeaderField: "Authorization")
        taskPhotos = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<[PhotoResponseBody], Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let responseBody):
                    for item in responseBody {
                        self?.photos.append(Photo(photoResponceBody: item))
                    }
                    self?.lastLoadedPage = nextPage
                    self?.lastLoadedPhotosCount = responseBody.count
                    NotificationCenter.default.post(name: ImagesListService.didChangeNotification, object: self)
                case .failure(_):
                    URLSession.printError(service: "fetchPhotosNextPage", errorType: "DataError", desc: "Ошибка создания модели массива фото")
                }
                self?.taskPhotos = nil
            }
        }
        taskPhotos?.resume()
    }
    
    func changeLike(photoId: String, isLike: Bool, _ handler: @escaping (Result<Void, Error>) -> Void) {
        assert(Thread.isMainThread)
        if taskLikes != nil { return }
        guard let index = photos.firstIndex(where: { $0.id == photoId }) else {
            handler(.failure(ImagesListServiceError.photosError))
            URLSession.printError(service: "changeLike", errorType: "PhotosError", desc: "Не найдена фотография по идентификатору")
            return
        }
        guard var urlComponents = URLComponents(url: configuration.defaultBaseURL, resolvingAgainstBaseURL: false) else { return }
        urlComponents.path = "/photos/\(photoId)/like"
        guard let url = urlComponents.url else { return }
        var request = URLRequest(url: url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.setValue("Bearer \(OAuth2TokenStorage.token ?? "")", forHTTPHeaderField: "Authorization")
        taskLikes = URLSession.shared.objectTask(for: request) { [weak self] (result: Result<LikeResponseBody, Error>) in
            DispatchQueue.main.async {
                switch result {
                case .success(let likeResponseBody):
                    self?.photos[index] = Photo(photoResponceBody: likeResponseBody.photo)
                    handler(.success(()))
                case .failure(let error):
                    handler(.failure(error))
                    URLSession.printError(service: "changeLike", errorType: "DataError", desc: "Ошибка работы с лайком")
                }
                self?.taskLikes = nil
            }
        }
        taskLikes?.resume()
    }
    
    func cleanData() {
        photos = []
        lastLoadedPage = nil
        lastLoadedPhotosCount = nil
    }
}

