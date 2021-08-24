//
//  MovieHorizontalTableViewCell.swift
//  HKMovie6 Coding Test
//
//  Created by Leo Wu on 23/8/2021.
//

import UIKit
import Cosmos
import RxSwift
import RxCocoa

class MovieHorizontalTableViewCell: UITableViewCell {

    static let CellID = "MovieHorizontalTableViewCell"

    var disposeBag = DisposeBag()
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeView: MovieInfoView!
    @IBOutlet weak var reviewView: MovieInfoView!
    @IBOutlet weak var openDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
    }
    
    func setup(viewModel: MovieModelViewModel) {
        viewModel.posterUrl.bind { [weak self] url in
            guard let self = self else { return }
            self.posterImageView.kf.setImage(with: URL(string: url))
        }.disposed(by: disposeBag)
        viewModel.rating.bind { [weak self] rating in
            guard let self = self else { return }
            self.ratingLabel.text = rating
            self.ratingView.rating = Double(rating) ?? 0.0
        }.disposed(by: disposeBag)
        viewModel.name.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        likeView.imageView.image = UIImage(systemName: "heart")
        reviewView.imageView.image = UIImage(systemName: "message")
        viewModel.rating.bind(to: reviewView.label.rx.text).disposed(by: disposeBag)
        viewModel.likeCount.bind(to: likeView.label.rx.text).disposed(by: disposeBag)
        viewModel.formattedOpenDate.bind(to: openDateLabel.rx.text).disposed(by: disposeBag)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
