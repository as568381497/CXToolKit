//
//  TextCollectionViewCell.swift
//  EAT
//
//  Created by 王振兴 on 2021/5/2.
//

import UIKit

class TextCollectionViewCell: UICollectionViewCell {

    static let normalIdentifier = "TextCollectionViewCell"

    @IBOutlet weak var textLab: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setStyle()
    }
    
    private func setStyle() {
        textLab.textColor = .black
    }

    var text:CustomStringConvertible? {
        didSet {
            switch text {
            case let attr as NSAttributedString:
                textLab.attributedText = attr
            default:
                let style = NSMutableParagraphStyle()
                style.lineSpacing = 8
                style.lineBreakMode = .byCharWrapping
                let options:[NSAttributedString.Key:Any] = [
                    .foregroundColor: UIColor.black,
                    .paragraphStyle: style
                ]
                textLab.attributedText = NSAttributedString(string: text?.description ?? "暂无", attributes: options)
            }
        }
    }
    
    var textString:String = ""{
        didSet{
            textLab.text = textString
        }
    }
    
}
