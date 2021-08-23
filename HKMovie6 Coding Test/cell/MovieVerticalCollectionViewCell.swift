//
//  MovieVerticalCollectionViewCell.swift
//  HKMovie6 Coding Test
//
//  Created by Leo Wu on 18/8/2021.
//

import UIKit
import RxSwift
import RxCocoa

class MovieVerticalCollectionViewCell: UICollectionViewCell {
    static let CellID = "MovieVerticalCollectionViewCell"
    var disposeBag = DisposeBag()
    
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var ratingView: MovieInfoView!
    @IBOutlet weak var likeView: MovieInfoView!
    @IBOutlet weak var reviewView: MovieInfoView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setup(viewModel: MovieModelViewModel) {
        
        viewModel.posterUrl.bind { [weak self] url in
            guard let self = self else { return }
            self.posterImageView.kf.setImage(with: URL(string: url))
        }.disposed(by: disposeBag)
        viewModel.name.bind(to: titleLabel.rx.text).disposed(by: disposeBag)
        ratingView.imageView.image = UIImage(systemName: "star")
        likeView.imageView.image = UIImage(systemName: "heart")
        reviewView.imageView.image = UIImage(systemName: "message")
        viewModel.rating.bind(to: ratingView.label.rx.text).disposed(by: disposeBag)
        viewModel.likeCount.bind(to: likeView.label.rx.text).disposed(by: disposeBag)
        viewModel.reviewCount.bind(to: reviewView.label.rx.text).disposed(by: disposeBag)
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
}
