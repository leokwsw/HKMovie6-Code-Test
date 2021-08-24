//
//  ViewController.swift
//  HKMovie6 Coding Test
//
//  Created by Leo Wu on 18/8/2021.
//

import UIKit
import RxSwift
import RxCocoa
import Kingfisher

class ViewController: UIViewController {
    private var navBarButton = UIBarButtonItem.init()
        
    var vm: ViewControllerViewModel = ViewControllerViewModel()
    
    let disposeBag = DisposeBag()
    
    var fullScreenSize: CGSize!
    var collectionView: UICollectionView!
    
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
        
        setupNavigationBar()
        setupCollectionView()
        setupTableView()
        binding()
        
        vm.callAPIForGetMovie().disposed(by: disposeBag)
    }
    
    private func binding() {
        vm.movieViewModels.bind(to: tableView.rx.items(cellIdentifier: MovieHorizontalTableViewCell.CellID)) {row, element, cell in
            let cell = cell as! MovieHorizontalTableViewCell
            cell.setup(viewModel: element)
        }.disposed(by: disposeBag)
        
        vm.movieViewModels.bind(to: collectionView.rx.items(cellIdentifier: MovieVerticalCollectionViewCell.CellID)) {row, element, cell in
            let cell = cell as! MovieVerticalCollectionViewCell
            cell.setup(viewModel: element)
        }.disposed(by: disposeBag)
        
        vm.isGrid.bind { [weak self] (isGrid) in
            guard let self = self else { return }
            self.collectionView.isHidden = !isGrid
            self.tableView.isHidden = isGrid
            self.navBarButton.image = UIImage(systemName: !isGrid ? "rectangle.grid.3x2" : "list.bullet")
        }.disposed(by: disposeBag)
        
        vm.isLoad.bind(onNext: { [weak self] (isLoad) in
            guard let self = self else {return}
            if(isLoad){
                self.navBarButton.isEnabled = true
                self.collectionView.reloadData()
                self.tableView.reloadData()
            }
        }).disposed(by: disposeBag)
    }
    
    private func setupNavigationBar(){
        navBarButton = UIBarButtonItem(
            image: UIImage(systemName: !vm.isGrid.value ? "rectangle.grid.3x2" : "list.bullet"),
            style: .plain,
            target: self,
            action: #selector(didTapNavigationItemButton(_:))
        )
        navigationItem.rightBarButtonItems = [navBarButton]
        navBarButton.isEnabled = false
    }
    
    @objc func didTapNavigationItemButton(_ sender: Any) {
        vm.isGrid.accept(!vm.isGrid.value)
    }

    //MARK: - UICollectionView Extensions
    private func setupCollectionView() {
        fullScreenSize = UIScreen.main.bounds.size
        
        let width = (CGFloat(fullScreenSize.width) / 3) - 7.0
        
        let height = (width / 9) * 16 + 20.0
        
        let flowLayout = UICollectionViewFlowLayout()
        
        flowLayout.itemSize = CGSize(
            width: width,
            height: height
        )
        
        collectionView = UICollectionView(
            frame: view.bounds,
            collectionViewLayout: flowLayout
        )
        
        collectionView.register(UINib(nibName: "MovieVerticalCollectionViewCell", bundle: nil)
            , forCellWithReuseIdentifier: MovieVerticalCollectionViewCell.CellID)
        
        collectionView.backgroundColor = .clear
        view.addSubview(collectionView)
    }
    
    //MARK: - UITableView Extensions
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.register(UINib(nibName: "MovieHorizontalTableViewCell", bundle: nil), forCellReuseIdentifier: MovieHorizontalTableViewCell.CellID)
        view.addSubview(tableView)
    }
}
