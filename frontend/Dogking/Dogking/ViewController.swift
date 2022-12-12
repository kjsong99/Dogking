//
//  ViewController.swift
//  Dogking
//
//  Created by 송경진 on 2022/12/01.
//

import UIKit
//import SnapKit
class ViewController: UIViewController {

    let imageArray : [UIImage] = [UIImage(named: "MainCardView")!, UIImage(named: "NameInputView")!, UIImage(named: "PasswordInputView")!, UIImage(named: "PasswordConfirmView")!, UIImage(named: "NameInputView")!, UIImage(named: "StartView")!]
    let frame = CGRect(x: 32, y: 53, width: 350, height: 700)
    

    func setLayout(index : Int){
        //여기서 index에 따른 layout 설정 해주기
    }

    func initialLayout(){
        //Component들 추가
        let cardView = CardView(frame: frame, images: imageArray )

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "Background Color")!
        initialLayout()
        
    }
    
   

}
