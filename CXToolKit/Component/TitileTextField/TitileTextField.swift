//
//  TitileTextField.swift
//  EAT
//
//  Created by 陈鑫 on 2022/11/10.
//

import Foundation
import UIKit

protocol TitileTextFieldDelegate: AnyObject {
    
    func FieldDidChange(_ field:TitileTextField)
}


class TitileTextField: UIView {
    
    //记录的预加载的文字
    var textArr:[String] = []
    
    weak var delegate:TitileTextFieldDelegate?
    
    lazy var listView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let listView = UICollectionView(frame: CGRect(x: 20, y: self.frame.height, width: self.frame.width - 40, height: 90), collectionViewLayout: flowLayout)
        return listView
    }()
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    
    var titileString:String = ""{
        didSet{
            titleLabel.text = titileString
        }
    }
    
    class func activityView() -> TitileTextField {
        if let view = Bundle.main.loadNibNamed("\(TitileTextField.self)", owner: self, options: nil)?.first as? TitileTextField {
            return view
        }
        return TitileTextField()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        listView.register(UINib(nibName: TextCollectionViewCell.normalIdentifier, bundle: .main), forCellWithReuseIdentifier:TextCollectionViewCell.normalIdentifier)
        
        setupView()
        setupStyle()
    }
    
    private func setupStyle() {
        
        lineView.setDashLineLayer(width: 1, length: 4, spacer: 2, color: .gray, isHorizonal: true)
        listView.backgroundColor = .white
        listView.isScrollEnabled = false
        inputField.tintColor = UIColor.black
    }
    
    private func setupView() {
        
        inputField.delegate = self
        inputField.returnKeyType = .continue
        listView.dataSource = self
        listView.delegate = self
        
        
        
        
    }
    
    
}


extension TitileTextField: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout ,UITextFieldDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return textArr.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 26)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       
        return 6
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TextCollectionViewCell.normalIdentifier, for: indexPath) as! TextCollectionViewCell
        cell.backgroundColor = .clear
        cell.textString = textArr[indexPath.row]
        cell.textLab.textColor = .black
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        inputField.text = textArr[indexPath.row]
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.x, width: self.frame.width, height: self.frame.height - 90)
        delegate?.FieldDidChange(self)
        listView.removeFromSuperview()
       
    }

    
    /// UITextFieldDelegate
    ///
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textArr.count == 0{
            return
        }

        
        listView.frame = CGRect(x: 20, y: self.frame.height, width: self.frame.width - 40, height: 90)
        self.addSubview(listView)
        self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.x, width: self.frame.width, height: self.frame.height + 90)
        
        listView.setLayerShadow(color: .black.withAlphaComponent(0.3), shadowRadius:8, cornerRadius:10)
        
    }
    
   
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        
        if self.frame.height > 90{
            self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.x, width: self.frame.width, height: self.frame.height - 90)
        }
        
        delegate?.FieldDidChange(self)
        listView.removeFromSuperview()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true

    }
    
}
