import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    weak var delegate: ImagesListCellDelegate?
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dataLable: UILabel!
    @IBOutlet var gradientCell: GradientView!
        
    @IBAction func likeButtonClicked(_ sender: UIButton) {
        delegate?.imageListCellDidTapLike(self)
    }
    override func prepareForReuse() {
        gradientCell.removeFromSuperview()
    }
    
    func setIsLiked(_ isLiked: Bool) {
        if isLiked {
            self.likeButton.imageView?.image = UIImage(named: "like_button_on")
        } else {
            self.likeButton.imageView?.image = UIImage(named: "like_button_off")
        }
    }
}
