//
//  AppAlertViewController.swift
//  CXToolKit
//
//  Created by 陈鑫 on 2022/10/27.
//

import Foundation
import UIKit

class AppAlertViewController: BaseViewController {
    
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
    
    lazy var messageLab:UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
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
        contentView.addSubview(messageLab)
    }
    
    override func setupPageLayout() {
        super.setupPageLayout()
        let bounds = self.view.bounds
        var contentSize = self.contentSize
        let spacer:CGFloat = 22
        let safeSize = CGSize(width: contentSize.width - spacer * 2, height: contentSize.height - spacer * 2)
        contentView.bounds = CGRect(x: 0,y: 0, width: contentSize.width, height: contentSize.height)
        titleLab.frame = CGRect(x: spacer, y: spacer, width: safeSize.width, height: spacer * 1.5)
        if var messageRect = messageLab.attributedText?.boundingRect(with: CGSize(width: safeSize.width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil), messageRect.size.width > 0 {
            messageRect.origin = CGPoint(x: spacer, y: titleLab.frame.maxY + spacer/2)
            messageRect.size.height = max(spacer, messageRect.size.height)
            messageRect.size.width = safeSize.width
            messageLab.frame = messageRect
        } else {
            messageLab.frame = titleLab.frame
        }
        
        messageLab.frame = CGRect(x: messageLab.frame.origin.x, y: messageLab.frame.origin.y, width: messageLab.frame.size.width, height: messageLab.frame.size.height * 1.8)
        
        let extensinY = messageLab.frame.maxY
        let extensionHeight = min(self.extensionHeight, max(bounds.size.height * 0.8 - extensinY, 60)) + spacer * 1.5
        contentSize.height = extensinY + extensionHeight
        listView.frame = CGRect(x: 0, y: extensinY, width: contentSize.width, height: extensionHeight)
        contentView.frame = CGRect(x: (bounds.size.width - contentSize.width)/2, y: (bounds.size.height - contentSize.height)/2, width: contentSize.width, height: contentSize.height)
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
        messageLab.textColor = .black
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
    
    var alertMessage:CustomStringConvertible = "" {
        didSet {
            switch alertMessage {
            case let attr as NSAttributedString:
                messageLab.attributedText = attr
            default:
                let style = NSMutableParagraphStyle()
                style.lineBreakMode = .byWordWrapping
                style.lineSpacing = 0
                style.alignment = .center
                let options:[NSAttributedString.Key:Any] = [
                    .paragraphStyle: style
                ]
                messageLab.attributedText = NSAttributedString(string: alertMessage.description, attributes: options)
            }
        }
    }
    
    var selectItemHadler:((Int) -> Void)?
    
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

extension AppAlertViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlertMenuCollectionCell.normalIdentifier, for: indexPath) as! AlertMenuCollectionCell
        cell.cornerRadius = itemSize.height / 2
        let action = actions[indexPath.row]
        cell.text = action.title
        switch action.style {
        case .cancel:
            cell.textColor = .black
            cell.backgroundColor = .white
        default:
            cell.backgroundColor = .clear
            cell.textColor = UIColor.white
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return itemSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dismiss(animated: false) { [unowned self] in
            self.selectItemHadler?(indexPath.row)
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}

struct AlertAction {
    var title:String
    var index:Int
    var style:UIAlertAction.Style
}

class AlertMenuCollectionCell : UICollectionViewCell {
    
    static let normalIdentifier = "AlertMenuCollectionCell"
    
    var cornerRadius:CGFloat = 12 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = true
        }
    }
    var font:UIFont = .systemFont(ofSize: 14) {
        didSet {
            titleLab.font = font
        }
    }
    var textColor:UIColor = UIColor.white {
        didSet {
            titleLab.textColor = textColor
        }
    }
    
    lazy var titleLab:UILabel = {
        let label = UILabel(frame: bounds.insetBy(dx: 4, dy: 4))
        label.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = UIColor.white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        contentView.addSubview(titleLab)
    }
    
    var text:String = "" {
        didSet {
            titleLab.text = text
        }
    }
    
}

