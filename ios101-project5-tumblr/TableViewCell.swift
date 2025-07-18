//
//  TableViewCell.swift
//  ios101-project5-tumblr

import UIKit

class PostCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var summaryLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code (optional styling)
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        summaryLabel.numberOfLines = 0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Optionally customize selected state
    }
}

