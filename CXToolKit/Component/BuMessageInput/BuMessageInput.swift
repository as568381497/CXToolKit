//
//  BuMessageInput.swift
//  EAT
//
//  Created by 陈鑫 on 2021/11/9.
//

import UIKit

//弹框操作 type
enum MessageClickType {
    //默认不处理
    case userDefault
    //权限, devicePush 通知权限,
    case userPsuerPermissions
}


class BuMessageInput: UIView {
    
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageButton: UIButton!
    
    //操作类型
    var messageType:MessageClickType = .userDefault
    
    class func BumessageInput(type:MessageClickType) -> BuMessageInput {
        if let view = Bundle.main.loadNibNamed("\(BuMessageInput.self)", owner: self, options: nil)?.first as? BuMessageInput {
            view.messageType = type
            return view
        }

        return BuMessageInput()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    @IBAction func clickMessageButton(_ sender: UIButton) {
        
        switch messageType {
        case .userPsuerPermissions:
            
            let url = URL(string: UIApplication.openSettingsURLString)

                if UIApplication.shared.canOpenURL(url! ) {
                    UIApplication.shared.open(url!, options: [ : ], completionHandler: nil)

                }
       
        default:
            return
        }
        
        
    }
    
    
    //删除
    @IBAction func ClickClockButton(_ sender: UIButton) {
        
        let that = self
        
        UIView.animate(withDuration: 0.5) {
            that.frame = CGRect(x: -that.frame.width, y: that.frame.origin.y, width: that.frame.width, height: that.frame.height)
        } completion: { animateFlish in
            that.removeFromSuperview()
        }
        
    }
    

}
