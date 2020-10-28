//
//  ViewController.swift
//  TextShot
//
//  Created by yingkelei on 2020/10/19.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var containerLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tvContainer: UIView!
    @IBOutlet weak var inputTV: UITextView!
    
    let provider = ListProvider()
    
    private var viewWidth: CGFloat {
        return view.bounds.width
    }
    private var maxWidth: CGFloat {
        return viewWidth - 12 * 2
    }
    private var minWidth: CGFloat {
        return viewWidth * 0.5
    }
    
    private var baseValue: CGFloat?
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    private var collectionView: UICollectionView! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureDataSource()
    }


    @IBAction func pinchContainer(_ sender: UIPinchGestureRecognizer) {
        guard sender.numberOfTouches >= 2 else {
            return
        }
        let finger1 = sender.location(ofTouch: 0, in: tvContainer);
        let finger2 = sender.location(ofTouch: 1, in: tvContainer);
        if abs(finger2.x - finger1.x) < abs(finger2.y - finger1.y) {
            return
        }
        switch sender.state {
        case .began:
            baseValue = tvContainer.bounds.width
        case.changed:
            if let val = baseValue {
                let targetWidth = min(maxWidth, max(minWidth, val * sender.scale))
                let edge = (viewWidth - targetWidth) / 2
                containerLeadingConstraint.constant = edge
                containerTrailingConstraint.constant = edge
            }
        case.ended:
            baseValue = nil
        default:
            break
        }
    }
    
    private func configureHierarchy() {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.delegate = self;
        collectionView.layer.borderColor = COLOR0?.cgColor
        collectionView.layer.borderWidth = 1.0
        collectionView.layer.cornerRadius = 8.0
        collectionView.backgroundColor = COLOR2
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: tvContainer.bottomAnchor, constant: 32),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12)
        ])
    }
    
    private func configureDataSource() {
        
        
        let cellRegistration = UICollectionView.CellRegistration<ConfigureListCell, Item> { (cell, indexPath, item) in
//            cell.updateWithItem(item)
//            cell.accessories = [.disclosureIndicator()]
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(provider.configurations)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension MainViewController: UICollectionViewDelegate {
    
}


fileprivate class ConfigureListCell: UICollectionViewListCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueTextField: UITextField!
    
    func setup(_ title: String?, _ value: String?) {
        titleLabel.text = title
        valueTextField.text = value
    }
    
}

