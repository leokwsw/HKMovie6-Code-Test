//
//  ViewControllerViewModel.swift
//  HKMovie6 Coding Test
//
//  Created by Leo Wu on 19/8/2021.
//

import Foundation
import RxSwift
import RxCocoa
import RxAlamofire

struct ViewControllerViewModel {
    let movieViewModels = BehaviorRelay<[MovieModelViewModel]>(value: [])
    let isLoad = PublishSubject<Bool>()
    let isGrid = BehaviorRelay<Bool>(value: true)
    
    func callAPIForGetMovie() -> Disposable {
        return RxAlamofire.requestString(.get, "https://jsonkeeper.com/b/WTPZ")
            .subscribe(onNext: { (response, data) in
                if let array = convertModel(from: data, to: [MovieModel].self) {
                    let viewModels = array.compactMap { return MovieModelViewModel(model: $0) }
                    self.movieViewModels.accept(viewModels)
                    self.isLoad.onNext(true)
                }
            }, onError: { (error) in
                print(error as NSError)
            })
    }
    
    func convertModel<T: Codable>(from jsonString: String, to newModel: T.Type) -> T? {
        do {
            guard let data = jsonString.data(using: .isoLatin1) else { return nil }

            return try JSONDecoder().decode(newModel.self, from: data)
        } catch {
            print(error)
            return nil
        }
    }
}
