//
//  MovieModelViewModel.swift
//  HKMovie6 Coding Test
//
//  Created by Leo Wu on 22/8/2021.
//

import Foundation
import RxSwift
import RxCocoa

struct MovieModelViewModel {
    let name = BehaviorRelay<String>(value: "")
    let formattedOpenDate = BehaviorRelay<String>(value: "")
    let posterUrl = BehaviorRelay<String>(value: "")
    let rating = BehaviorRelay<String>(value: "0")
    let likeCount = BehaviorRelay<String>(value: "")
    let reviewCount = BehaviorRelay<String>(value: "")
    let duration = BehaviorRelay<Int>(value: 0)
    
    init(model: MovieModel) {
        name.accept(model.name ?? "")
        posterUrl.accept(model.poster ?? "")
        rating.accept(String(format: "%.1f", model.rating ?? 0.0))
        likeCount.accept("\(model.likeCount ?? 0)")
        reviewCount.accept("\(model.reviewCount ?? 0)")
        duration.accept(model.duration ?? 0)
        publishOpenDate(timeStamp: model.openDate ?? 0)
    }
    
    private func publishOpenDate(timeStamp: Double) {
        let date = Date(timeIntervalSince1970: timeStamp)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "zh-Hant")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        formattedOpenDate.accept(dateFormatter.string(from: date))

    }
}
