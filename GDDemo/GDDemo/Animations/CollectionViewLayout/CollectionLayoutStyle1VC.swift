//
//  CollectionLayoutStyle1VC.swift
//  GDDemo
//
//  Created by GDD on 2021/7/7.
//  Copyright © 2021 GDD. All rights reserved.
//

import UIKit

class CollectionLayoutStyle1VC: BaseViewController {

    enum LayoutStyle {
        case linerStyle
        case circle
        case pinch
    }

    var style = LayoutStyle.linerStyle
    private var cellCount = 20
    init(_ style: LayoutStyle) {
        super.init(nibName: nil, bundle: nil)
        self.style = style
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(collectV)
        collectV.snp.makeConstraints { snp in
            snp.edges.equalToSuperview()
        }

        if style == .circle {
            let tap = UITapGestureRecognizer.init(target: self, action: #selector(handleTapGesture(sender:)))
            self.collectV.addGestureRecognizer(tap)
        } else if style == .pinch {
            let pinch = UIPinchGestureRecognizer.init(target: self, action: #selector(handlePinchGesture(sender:)))
            self.collectV.addGestureRecognizer(pinch)
        }
    }

    @objc private func handlePinchGesture(sender: UIPinchGestureRecognizer) {
        if sender.state == .began {
            let pinchPoint = sender.location(in: collectV)
            let tappedIndexPath = collectV.indexPathForItem(at: pinchPoint)
            layoutStyle3.pinchCellPath = tappedIndexPath
        } else if sender.state == .changed {
            layoutStyle3.pinchCellScale = sender.scale
            layoutStyle3.pinchCellCenter = sender.location(in: collectV)
            if let indexPaht = layoutStyle3.pinchCellPath {
                collectV.reloadItems(at: [indexPaht])
            }
        } else {
            layoutStyle3.pinchCellPath = nil
            collectV.reloadData()
        }
    }

    @objc private func handleTapGesture(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let pinchPoint = sender.location(in: collectV)
            if let tappedIndexPath = collectV.indexPathForItem(at: pinchPoint) {
                cellCount -= 1
                collectV.performBatchUpdates({
                    [weak self] in
                    guard let self = self else { return }
                    self.collectV.deleteItems(at: [tappedIndexPath])
                }, completion: nil)
            } else {
                cellCount += 1
                collectV.performBatchUpdates({
                    [weak self] in
                    guard let self = self else { return }
                    self.collectV.insertItems(at: [IndexPath.init(item: 0, section: 0)])
                }, completion: nil)
            }
        }
    }

    private lazy var layoutStyle1: CollectionViewLayoutStyle1 = {
        let v = CollectionViewLayoutStyle1()
        return v
    }()
    private lazy var layoutStyle2: CollectionViewLayoutStyle2 = {
        let v = CollectionViewLayoutStyle2()
        return v
    }()
    private lazy var layoutStyle3: CollectionViewLayoutStyle3 = {
        let v = CollectionViewLayoutStyle3()
        v.itemSize = CGSize.init(width: 80, height: 80)
        v.minimumLineSpacing = 20
        v.minimumInteritemSpacing = 20
        return v
    }()
    private lazy var collectV: UICollectionView = {
        var layout: UICollectionViewFlowLayout?
        switch self.style {
        case .linerStyle:
            layout = layoutStyle1
        case .circle:
            layout = layoutStyle2
        case .pinch:
            layout = layoutStyle3
        }
        let v = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout!)
//        v.delegate = self
        v.dataSource = self
        v.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return v
    }()
}


extension CollectionLayoutStyle1VC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        if let cell = cell as? CustomCollectionViewCell {
            cell.titleL.text = "\(indexPath.section), \(indexPath.row)"
            cell.layer.cornerRadius = itemCircleSizeWidth / 2
            cell.layer.masksToBounds = true
        }
        return cell
    }


}


class CustomCollectionViewCell: UICollectionViewCell {
    var titleL = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .cyan
        contentView.addSubview(titleL)
        titleL.textColor = .black
        titleL.snp.makeConstraints { snp in
            snp.edges.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
