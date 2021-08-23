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

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource{
        
    private var navBarButton = UIBarButtonItem.init()
    
    private var isGrid = true
    
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
        setUpTableView()
        
        vm.isLoad.bind(onNext: { [weak self] (isLoad) in
            guard let self = self else {return}
            if(isLoad){
                self.navBarButton.isEnabled = true
                self.collectionView.reloadData()
            }
        }).disposed(by: disposeBag)
        
        vm.callAPIForGetMovie().disposed(by: disposeBag)
        
    }
    
    private func setupNavigationBar(){
        navBarButton = UIBarButtonItem(
            image: UIImage(systemName: "rectangle.grid.3x2"),
            style: .plain,
            target: self,
            action: #selector(didTapNavigationItemButton(_:))
        )
        
        navigationItem.rightBarButtonItems = [navBarButton]
        
        navBarButton.isEnabled = false
    }
    
    private func setupCollectionView() {
        fullScreenSize = UIScreen.main.bounds.size
        
        collectionView = UICollectionView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: fullScreenSize.width,
                height: fullScreenSize.height
            ),
            collectionViewLayout: getFlowLayout()
        )
        
        collectionView.register(UINib(nibName: "MovieVerticalCollectionViewCell", bundle: nil)
            , forCellWithReuseIdentifier: MovieVerticalCollectionViewCell.CellID)
        
        collectionView.backgroundColor = .clear
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.addSubview(collectionView)
    }
    
    private func setUpTableView() {
        tableView = UITableView(frame: view.bounds)
        
        tableView.register(UINib(nibName: "MovieHorizontalTableViewCell", bundle: nil), forCellReuseIdentifier: MovieHorizontalTableViewCell.CellID)
        
        tableView.isHidden = true
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
    }
    
    @objc func didTapNavigationItemButton(_ sender: Any) {
        isGrid = !isGrid
        navBarButton.image = UIImage(systemName: isGrid ? "rectangle.grid.3x2" : "list.bullet")
        
        if(isGrid){
            collectionView.isHidden = false
            tableView.isHidden = true
            collectionView.reloadData()
        } else {
            collectionView.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
    
    private func getFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        
        let width = (CGFloat(fullScreenSize.width) / (isGrid ? 3 : 1)) - (isGrid ? 7.0 : 0.0)
        
        let height = (isGrid ? (width / 9) * 16 + 20.0 : CGFloat(fullScreenSize.width) / 3)
        
        flowLayout.itemSize = CGSize(
            width: width,
            height: height
        )
        return flowLayout
    }

    //MARK: - UICollectionView Extensions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.movieViewModels.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
                        
        guard let verticalCell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieVerticalCollectionViewCell", for: indexPath) as? MovieVerticalCollectionViewCell else { fatalError() }
        
        let movieViewModel = vm.movieViewModels.value[indexPath.row]
        verticalCell.setup(viewModel: movieViewModel)
        
        return verticalCell
    }
    
    //MARK: - UITableView Extensions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.movieViewModels.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let horizontalCell = tableView.dequeueReusableCell(withIdentifier: "MovieHorizontalTableViewCell", for: indexPath) as? MovieHorizontalTableViewCell else { fatalError() }
        
        let movieViewModel = vm.movieViewModels.value[indexPath.row]
        horizontalCell.setup(viewModel: movieViewModel)
        
        return horizontalCell
    }
    
}
