import UIKit
import Kingfisher

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    private var cellImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "FavoritesActive"), for: .normal)
        button.addTarget(self, action: #selector(touchUpInsidelikeButton), for: .touchUpInside)
        button.accessibilityIdentifier = "LikeButton"
        return button
    }()
    private var dateLabel: UILabel = {
        let label = UILabel()
        label.text = "6 января 2024"
        label.textColor = .imageFeedWhite
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    var imageURL: String? {
        didSet {
            guard let url = URL(string: imageURL ?? "") else { return }
            cellImage.kf.indicatorType = .activity
            cellImage.kf.setImage(with: url, placeholder: UIImage(named: "Scrible")) { [weak self] result in
                guard let self = self else { return }
                self.cellImage.contentMode = .scaleAspectFill
            }
        }
    }
    
    var imageDate: Date? {
        didSet {
            if let date = imageDate {
                dateLabel.text = DateFormatManager.shared.dateToString(date)
            } else {
                dateLabel.text = ""
            }
        }
    }
    
    var isFavorites: Bool? {
        didSet {
            let likeButtonImage = isFavorites ?? false ? UIImage(named: "FavoritesActive") : UIImage(named: "FavoritesNotActive")
            likeButton.setImage(likeButtonImage, for: .normal)
        }
    }
    
    static let reuseIdentifier = "ImageListCell"
    weak var delegate: ImagesListCellDelegate?
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupImagesListCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupImagesListCell() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
        addSubViews()
        applyConstraints()
    }
    
    private func addSubViews() {
        contentView.addSubviewWithoutAutoresizingMask(cellImage)
        contentView.addSubviewWithoutAutoresizingMask(likeButton)
        contentView.addSubviewWithoutAutoresizingMask(dateLabel)
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            cellImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cellImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cellImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
            cellImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
        NSLayoutConstraint.activate([
            likeButton.heightAnchor.constraint(equalToConstant: 48),
            likeButton.widthAnchor.constraint(equalToConstant: 48),
            likeButton.topAnchor.constraint(equalTo: cellImage.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: cellImage.trailingAnchor)
        ])
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: cellImage.leadingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(lessThanOrEqualTo: cellImage.trailingAnchor, constant: -8),
            dateLabel.bottomAnchor.constraint(equalTo: cellImage.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func touchUpInsidelikeButton() {
        delegate?.imageListCellDidTapLike(self)
    }
}
