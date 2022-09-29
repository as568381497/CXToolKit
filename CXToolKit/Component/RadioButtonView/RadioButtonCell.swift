//
//  RadioButtonCell.swift
//  EAT
//
//  Created by 陈鑫 on 2022/4/1.
//

import Foundation
import UIKit
import Kingfisher

class RadioButtonCell: UICollectionViewCell {
    
    
    static let normalIdentifier = "RadioButtonCell"

    @IBOutlet weak var titileLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellIcon: UIImageView!
    @IBOutlet weak var textLabel: UILabel!

    //是否选中
    var isSelectedImage:Bool = false {
        didSet{
            if isSelectedImage {


                cellImage.image = UIImage(named: "radio_seleter")

            }else{


                cellImage.image = UIImage(named: "radio_no_seleter")
            }
        }
    }

    //数据model
    var model:RadioButtonModel = RadioButtonModel(){
        didSet{

            titileLabel.text = model.title
            imageUrl = model.image
            textLabel.text = model.introduceText

        }
    }
    
    
    var imageUrl:Any = "" {
        didSet {
            switch imageUrl {
            case let imageName as String:
                if imageName.hasPrefix("http") {
                    cellIcon.kf.setImage(with: URL(string: imageName))
                } else {
                    cellIcon.image = UIImage(named: imageName)
                }
            case let imageBody as UIImage:
                cellIcon.image = imageBody
            case let imageData as Data:
                cellIcon.image = UIImage(data: imageData)
            default:
                break
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupStyle()
    }


    private func setupView() {

    }

    private func setupStyle() {


    }
    
    
}
