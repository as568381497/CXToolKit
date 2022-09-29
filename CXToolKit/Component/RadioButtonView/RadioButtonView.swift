//
//  RadioButtonView.swift
//  EAT
//
//  Created by 陈鑫 on 2022/4/1.
//

import UIKit

struct RadioButtonModel {
    var title:String = ""
    var image:Any = ""
    var introduceText:String = ""
}

//当前点击的第几个选项的反馈
protocol RadioButtonViewDelegate: AnyObject {
    
    func didSelectItemAt(_ radioView:RadioButtonView, didSelect index:Int)
    
}

class RadioButtonView: UIView {

  
    weak var delegate:RadioButtonViewDelegate?
    
    var cellSize:CGSize = CGSize(width: 0, height: 0)
    //当前index
    var seleterIndex:Int = 0
    
    //偏移
    var offset:CGPoint = .zero {
        didSet {
            flowLayout.sectionInset = UIEdgeInsets(top: offset.y, left: offset.x, bottom: offset.y, right: offset.x)
            flowLayout.invalidateLayout()
        }
    }
    
    //滚动方向
    var direction: UICollectionView.ScrollDirection = .horizontal {
        didSet {
            
            if direction == .vertical {
                flowLayout.minimumInteritemSpacing = 10
            }
            
            flowLayout.scrollDirection = direction
            flowLayout.invalidateLayout()
        }
    }
    
    //数据源
    private var tags:[RadioButtonModel] = []
    
    private lazy var flowLayout:UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .zero
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        return flowLayout
    }()
    
    private lazy var listView:UICollectionView = {
        let listView = UICollectionView(frame: bounds, collectionViewLayout: flowLayout)
        listView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        listView.backgroundColor = UIColor.clear
        listView.alwaysBounceHorizontal = true
        listView.showsHorizontalScrollIndicator = false
        listView.bounces = false
        listView.dataSource = self
        listView.delegate = self
        [RadioButtonCell.normalIdentifier].forEach { (identifier) in
            listView.register(UINib(nibName: identifier, bundle: .main), forCellWithReuseIdentifier: identifier)
         }
        return listView
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
        
        addSubview(listView)
        reloadTags([])
        
    }
    
    /// Data Source
    func reloadTags(_ items:[RadioButtonModel]) {
       
        tags = items
        listView.reloadData()
    }
    

}

extension RadioButtonView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
      
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RadioButtonCell.normalIdentifier, for: indexPath)

        switch cell {

        case let dishCell as RadioButtonCell:

            dishCell.tag = indexPath.row
            dishCell.model = tags[indexPath.row]
            dishCell.isSelectedImage = seleterIndex == indexPath.row ? true : false

        default:
            break
        }


        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return self.cellSize
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //check
        if indexPath.row == seleterIndex {
            return
        }
        
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        
        
        switch cell {
        case let radioCell as RadioButtonCell:
            
            //将之前的变回去
            if let oldRadioCell = listView.cellForItem(at: IndexPath(row: seleterIndex, section: 0)) as? RadioButtonCell{
                
                oldRadioCell.isSelectedImage = false
              
            }
            
            radioCell.isSelectedImage = true
            seleterIndex = indexPath.row
            
            delegate?.didSelectItemAt(self, didSelect: seleterIndex)
            
            
        default: break
            
        }
    }




}

