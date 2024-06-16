//
//  MyTableViewCell.swift
//  Ex
//
//  Created by dongwon on 2024/05/22.
//

import UIKit

    class MyTableViewCell: UITableViewCell {
        override func awakeFromNib() {
               super.awakeFromNib()
               self.backgroundColor = UIColor.clear // 셀의 배경을 투명하게 설정
           }
       
        @IBOutlet weak var dataLabel: UILabel!
        @IBOutlet weak var minLabel: UILabel!
        @IBOutlet weak var maxLabel: UILabel!
        @IBOutlet weak var weatherIconImageView: UIImageView!
    }
