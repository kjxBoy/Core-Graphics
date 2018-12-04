//
//  ViewController.swift
//  Flo
//
//  Created by apple on 2018/12/3.
//  Copyright © 2018年 kang. All rights reserved.
//

import UIKit
// public和open的区别
// struct 和 class 的区别
// 泛型的使用场景
// reduce函数
// 隐式动画
class ViewController: UIViewController {

    //Counter outlets
    @IBOutlet weak var counterView: CounterView!
    @IBOutlet weak var counterLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        counterLabel.text = String(counterView.counter)
    }

    @IBAction func pushButtonPressed(_ button: PushButton) {
        if button.isAddButton {
            counterView.counter += 1
        } else {
            if counterView.counter > 0 {
                counterView.counter -= 1
            }
        }
        counterLabel.text = String(counterView.counter)
    }

   

}

