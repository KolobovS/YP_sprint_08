import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController{
    private let ShowSingleImageSegueIdentifier = "ShowSingleImage"
    @IBOutlet private var tableView: UITableView!
    private var photos: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        NotificationCenter.default.addObserver(self, selector: #selector(updateTableViewAnimated), name: ImagesListService.didChangeNotification, object: nil)
        ImagesListService.shared.fetchPhotosNextPage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowSingleImageSegueIdentifier {
            let viewController = segue.destination as? SingleImageViewController
            guard let indexPath = sender as? IndexPath else { return }
            viewController?.fullImageUrl = photos[indexPath.row].fullImageUrl
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    @objc
    private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = ImagesListService.shared.photos.count
        photos = ImagesListService.shared.photos
        
        if oldCount != newCount {
            tableView.performBatchUpdates({
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            }, completion: nil)
        }
    }
    
    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row + 1 == photos.count {
            ImagesListService.shared.fetchPhotosNextPage()
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ImagesListCell", for: indexPath) as? ImagesListCell else { fatalError("Cannot extract cell") }
        cell.delegate = self
        cell.selectionStyle = .none
        let photo = photos[indexPath.row]
        if let url = URL(string: photo.thumbImageURL) {
            cell.imageCell.kf.indicatorType = .activity
            cell.imageCell.kf.setImage(with: url,
                                       placeholder: UIImage(named: "placeholder_stub"),
                                       options: []) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(_):
                    if let created = photo.createdAt {
                        cell.dataLable.text = self.dateFormatter.string(from: created)
                    } else {
                        cell.dataLable.text = ""
                    }
                    cell.setIsLiked(photo.isLiked)
                case .failure(let error):
                    print(error)
                }
            }
        }
        return cell
    }
}

extension ImagesListViewController: ImagesListCellDelegate {
    func imageListCellDidTapLike(_ cell: ImagesListCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let photo = photos[indexPath.row]
        let isLiked = !photo.isLiked
        UIBlockingProgressHUD.show()
        ImagesListService.shared.changeLike(photoId: photo.id, isLike: isLiked) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.photos = ImagesListService.shared.photos
                    cell.setIsLiked(self.photos[indexPath.row].isLiked)
                case .failure(let error):
                    print("Error changing like: \(error)")
                }
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: ShowSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let scale = imageViewWidth / photos[indexPath.row].size.width
        let cellHeight = photos[indexPath.row].size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}
