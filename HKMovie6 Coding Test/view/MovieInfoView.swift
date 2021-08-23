//
//  MovieInfoView.swift
//  HKMovie6 Coding Test
//
//  Created by Leo Wu on 22/8/2021.
//

import UIKit
import RxSwift
import RxCocoa

class MovieInfoView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    private func loadView() {
        Bundle.main.loadNibNamed("MovieInfoView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
    }
}
