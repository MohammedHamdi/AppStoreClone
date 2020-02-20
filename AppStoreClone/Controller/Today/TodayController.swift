//
//  TodayController.swift
//  AppStoreClone
//
//  Created by Mohammed Hamdi on 2/11/20.
//  Copyright © 2020 Mohammed Hamdi. All rights reserved.
//

import UIKit

class TodayController: BaseListController, UICollectionViewDelegateFlowLayout {
    
//    fileprivate let cellId = "cellId"
//    fileprivate let multipleAppCellId = "multipleAppCellId"
    
    static let cellSize: CGFloat = 500
    
//    let items = [

//
//        TodayItem.init(category: "HOLIDAYS", title: "Travel on a Budget", image: #imageLiteral(resourceName: "holiday"), description: "Find out all you need to know on how to travel without packing everything!", backgroundColor: UIColor(red: 250 / 255, green: 245 / 255, blue: 175 / 255, alpha: 1), cellType: .single),
//
//        TodayItem.init(category: "MULTIPLE CELL", title: "Test-Drive These CarPlay Apps", image: #imageLiteral(resourceName: "star"), description: "", backgroundColor: .white, cellType: .multiple)
//    ]
    
    var items = [TodayItem]()
    
    var activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .large)
        aiv.color  = .darkGray
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    var startingFrame: CGRect?
    var appFullScreenController: AppFullScreenController!
    
    var anchoredConstraints: AnchoredConstraints?
    
    // To solve a bug that the tab bar doesn't stick to the bottom of the screen (pre iOS 13)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        tabBarController?.tabBar.superview?.setNeedsLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
        collectionView.backgroundColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1)
        
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayItem.CellType.single.rawValue)
        collectionView.register(TodayMultipleAppCell.self, forCellWithReuseIdentifier: TodayItem.CellType.multiple.rawValue)
        
        fetchData()
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.centerInSuperview()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = items[indexPath.item].cellType.rawValue
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BaseTodayCell
        cell.todayItem = items[indexPath.item]
        
        (cell as? TodayMultipleAppCell)?.multipleAppsController.collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMultipleAppsTap)))
        
        return cell
    }
    
    fileprivate func showDailyListFullScreen(_ indexPath: IndexPath) {
        let fullController = TodayMultipleAppsController(mode: .fullscreen)
        fullController.apps = self.items[indexPath.item].apps
        let navigationController = BackEnabledNavigationController(rootViewController: fullController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch items[indexPath.item].cellType {
        case .multiple:
            showDailyListFullScreen(indexPath)
        default:
            showSingleAppFullScreen(indexPath: indexPath)
        }
    }
    
    fileprivate func setupSingleAppFullScreenController(_ indexPath: IndexPath) {
        let appFullScreenController = AppFullScreenController()
        appFullScreenController.todayItem = items[indexPath.item]
        appFullScreenController.dismissHandler = {
            self.handleRemoveFullScreenView()
        }
        appFullScreenController.view.layer.cornerRadius = 16
        
        self.appFullScreenController = appFullScreenController
    }
    
    fileprivate func setupStartingCellFrame(_ indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        
        // Absolute coordinates of cell
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        
        self.startingFrame = startingFrame
    }
    
    fileprivate func setupAppFullScreenStartingPosition(_ indexPath: IndexPath) {
        let fullScreenView = appFullScreenController.view!
        view.addSubview(fullScreenView)
        
        addChild(appFullScreenController)
        
        self.collectionView.isUserInteractionEnabled = false
        
        setupStartingCellFrame(indexPath)
        
        guard let startingFrame = self.startingFrame else { return }
        
        self.anchoredConstraints = fullScreenView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(top: startingFrame.origin.y, left: startingFrame.origin.x, bottom: 0, right: 0), size: .init(width: startingFrame.width, height: startingFrame.height))
        view.layoutIfNeeded()
    }
    
    fileprivate func beginAppFullScreenAnimation() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {

            self.anchoredConstraints?.top?.constant = 0
            self.anchoredConstraints?.leading?.constant = 0
            self.anchoredConstraints?.width?.constant = self.view.frame.width
            self.anchoredConstraints?.height?.constant = self.view.frame.height
            
            self.view.layoutIfNeeded()

            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height
            
            guard let cell = self.appFullScreenController.tableView.cellForRow(at: [0,0]) as? AppFullScreenHeaderCell else { return }
            cell.todayCell.topConstraint.constant = 48
            cell.layoutIfNeeded()
        }, completion: nil)
    }
    
    fileprivate func showSingleAppFullScreen(indexPath: IndexPath) {
        // #1 Setup the new fullscreen controller
        setupSingleAppFullScreenController(indexPath)
        
        // #2 Setup fullscreen in its starting position
        setupAppFullScreenStartingPosition(indexPath)
        
        // #3 Begin the fullscreen animation
        beginAppFullScreenAnimation()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width - 64, height: TodayController.cellSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 32, left: 0, bottom: 32, right: 0)
    }
    
    @objc func handleRemoveFullScreenView() {
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            
            guard let startingFrame = self.startingFrame else { return }
            
            self.anchoredConstraints?.top?.constant = startingFrame.origin.y
            self.anchoredConstraints?.leading?.constant = startingFrame.origin.x
            self.anchoredConstraints?.width?.constant = startingFrame.width
            self.anchoredConstraints?.height?.constant = startingFrame.height
            
            self.view.layoutIfNeeded()
            
            self.appFullScreenController.tableView.contentOffset = .zero
            
            if let tabBarFrame = self.tabBarController?.tabBar.frame {
                self.tabBarController?.tabBar.frame.origin.y = self.view.frame.size.height - tabBarFrame.height
            }
            
            guard let cell = self.appFullScreenController.tableView.cellForRow(at: [0,0]) as? AppFullScreenHeaderCell else { return }
            cell.todayCell.topConstraint.constant = 24
            cell.layoutIfNeeded()
        }, completion: { _ in
            self.appFullScreenController.view.removeFromSuperview()
            self.appFullScreenController.removeFromParent()
            self.collectionView.isUserInteractionEnabled = true
        })
    }
    
    fileprivate func fetchData() {
        let dispatchGroup = DispatchGroup()
        
        var topGrossingGroup: AppGroup?
        var gamesGroup: AppGroup?
        
        dispatchGroup.enter()
        Service.shared.fetchTopGrossing { (appGroup, error) in
            if let error = error {
                print("Error fetching top grossing apps in today view: ", error)
            }
            
            topGrossingGroup = appGroup
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        Service.shared.fetchGames { (appGroup, error) in
            if let error = error {
                print("Error fetching games in today view: ", error)
            }
            
            gamesGroup = appGroup
            
            dispatchGroup.leave()
        }
        
        // Completion block for the dispatch group
        dispatchGroup.notify(queue: .main) {
            print("Finished Fetching")
            
            self.items = [
                TodayItem.init(category: "LIFE HACK", title: "Utilizing your Time", image: #imageLiteral(resourceName: "garden"), description: "All the tools and apps you need to intenlligently organize your life the right way.", backgroundColor: .white, cellType: .single, apps: []),
                
                TodayItem.init(category: "DAILY LIST", title: topGrossingGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "star"), description: "", backgroundColor: .white, cellType: .multiple, apps: topGrossingGroup?.feed.results ?? []),
                
                TodayItem.init(category: "DAILY LIST", title: gamesGroup?.feed.title ?? "", image: #imageLiteral(resourceName: "star"), description: "", backgroundColor: .white, cellType: .multiple, apps: gamesGroup?.feed.results ?? []),
                
                TodayItem.init(category: "HOLIDAYS", title: "Travel on a Budget", image: #imageLiteral(resourceName: "holiday"), description: "Find out all you need to know on how to travel without packing everything!", backgroundColor: UIColor(red: 250 / 255, green: 245 / 255, blue: 175 / 255, alpha: 1), cellType: .single, apps: []),
            ]
            
            self.activityIndicatorView.stopAnimating()
            self.collectionView.reloadData()
        }
    }
    
    @objc fileprivate func handleMultipleAppsTap(gesture: UIGestureRecognizer) {
        let collectionView = gesture.view
        
        var superview = collectionView?.superview
        
        while superview != nil {
            if let cell = superview as? TodayMultipleAppCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
                
                let apps = self.items[indexPath.item].apps
                
                let fullController = TodayMultipleAppsController(mode: .fullscreen)
                fullController.apps = apps
                let navigationController = BackEnabledNavigationController(rootViewController: fullController)
                navigationController.modalPresentationStyle = .fullScreen
                present(navigationController, animated: true)
                return
            }
            superview = superview?.superview
        }
    }
}
