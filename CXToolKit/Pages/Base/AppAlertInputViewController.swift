//
//  AppAlertInputViewController.swift
//  CXToolKit
//
//  Created by 陈鑫 on 2022/10/27.
//

import Foundation
import UIKit

class AppAlertInputViewController: BaseViewController {
    
    var tintColor:UIColor = UIColor.red
    var cornerRadius:CGFloat = 12
  
    
    private var contentSize:CGSize = CGSize(width: 310, height: 190)
    private var itemSize:CGSize = CGSize(width: 100, height: 32)
    private var extensionHeight:CGFloat = 60
    
    lazy var contentView:UIView = {
        let view = UIView()
        view.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        view.clipsToBounds = true
        return view
    }()
    
    lazy var titleLab:UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        return label
    }()
    
    
    
    lazy var textInput:UITextField = {
        let field = UITextField()
        field.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        field.borderStyle = .bezel
        field.font = .systemFont(ofSize: 14)
        field.textAlignment = .center
        return field
    }()
    

    lazy var paymentCardTextField: UITextField = {
        let field = UITextField()
        field.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        field.borderStyle = .bezel
        field.font = .systemFont(ofSize: 14)
        field.textAlignment = .center
        return field
    }()

    
    lazy var listView:UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 12
        flowLayout.minimumLineSpacing = 12
        flowLayout.sectionInset = UIEdgeInsets(top: 22, left: 22, bottom: 22, right: 22)
        flowLayout.itemSize = CGSize(width: 100, height: 48)
        let listView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        listView.backgroundColor = UIColor.clear
        listView.dataSource = self
        listView.delegate = self
        listView.register(AlertMenuCollectionCell.self, forCellWithReuseIdentifier: AlertMenuCollectionCell.normalIdentifier)
        return listView
    }()
    
    init() {
        
        super.init(nibName: nil, bundle: nil)
        providesPresentationContextTransitionStyle = true
        definesPresentationContext = true
        modalPresentationStyle = .overCurrentContext
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        providesPresentationContextTransitionStyle = true
        definesPresentationContext = true
        modalPresentationStyle = .overCurrentContext
    }
     
    override func setupPageView() {
        super.setupPageView()
        view.addSubview(contentView)
        contentView.addSubview(listView)
        contentView.addSubview(titleLab)
        contentView.addSubview(textInput)
        
        
    }
    
    override func setupPageLayout() {
        super.setupPageLayout()
        let bounds = self.view.bounds
        var contentSize = self.contentSize
        let spacer:CGFloat = 22
        let safeSize = CGSize(width: contentSize.width - spacer * 2, height: contentSize.height - spacer * 2)
        
  
        contentView.bounds = CGRect(x: 0,y: 0, width: contentSize.width, height: contentSize.height)
        titleLab.frame = CGRect(x: spacer, y: spacer, width: safeSize.width, height: spacer * 1.5)
        
        
        textInput.frame = CGRect(x: 20, y: titleLab.frame.maxY + spacer/2, width: contentSize.width - 40, height: extensionHeight)
        
        let extensinY = textInput.frame.maxY
        let extensionHeight:CGFloat = min(self.extensionHeight, max(bounds.size.height * 0.8 - extensinY, 60)) + spacer * 1.5
        contentSize.height = extensinY + extensionHeight
        
        listView.frame = CGRect(x: 0, y: textInput.frame.maxY + spacer/2, width: contentSize.width, height: extensionHeight)
        contentView.frame = CGRect(x: (bounds.size.width - contentSize.width)/2, y: (bounds.size.height - contentSize.height)/3, width: contentSize.width, height: contentSize.height)
    }
    
    private func setupPageItemSize() {
        let spacer:CGFloat = 22
        let itemCount = actions.count
        let itemRow = itemCount < 3 ? 1 : itemCount
        let itemWidth = contentSize.width - spacer * 2
        let itemHeight = itemSize.height + 12
        itemSize = CGSize(width: itemCount == 2 ? (itemWidth - spacer)/2 : itemWidth, height: itemSize.height)
        extensionHeight = CGFloat(itemRow) * itemHeight
    }
    
    override func setupPageEvent() {
        super.setupPageEvent()
    }
    
    override func setupThemeStyle() {
        super.setupThemeStyle()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = cornerRadius
        titleLab.textColor = .black
        textInput.textColor = .black
    }
    
    var alertTitle:CustomStringConvertible = "" {
        didSet {
            switch alertTitle {
            case let attr as NSAttributedString:
                titleLab.attributedText = attr
            default:
                titleLab.text = alertTitle.description
            }
        }
    }
    
    var InputPlaceholder:CustomStringConvertible = "" {
        didSet {
            switch InputPlaceholder {
            case let attr as NSAttributedString:
                textInput.placeholder = attr.description
            default:
                textInput.placeholder = InputPlaceholder.description
            }
        }
    }
    
    //输入框回调
    var selectItemHadler:((Int,String) -> Void)?
    
    var actions:[AlertAction] = [] {
        didSet {
            setupPageItemSize()
            if isViewLoaded {
                setupPageLayout()
            }
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: false, completion: completion)
    }
    
}

extension AppAlertInputViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlertMenuCollectionCell.normalIdentifier, for: indexPath) as! AlertMenuCollectionCell
        cell.cornerRadius = cornerRadius/2
        let action = actions[indexPath.row]
        cell.text = action.title
        switch action.style {
        case .cancel:
            cell.textColor = .black
            cell.backgroundColor = .white
        default:
            cell.backgroundColor = tintColor
            cell.textColor = UIColor.white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        dismiss(animated: false) { [unowned self] in
            self.selectItemHadler?(indexPath.row,textInput.text ?? "")
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}
