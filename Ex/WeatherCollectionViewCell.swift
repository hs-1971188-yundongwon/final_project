//
//  WeatherCollectionViewCell.swift
//  Ex
//
//  Created by dongwon on 2024/06/02.
//

import UIKit
import Foundation

struct WeatherHourlyData {
    let date: Date
    let temperature: Double
    let icon: String
}

class WeatherCollectionViewCell:UICollectionViewCell {

    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var imageIcon: UIImageView!
    @IBOutlet weak var tempertureLabel: UILabel!
    
}

extension WeatherCollectionViewCell {
    func updateWeatherIcon(conditionID: Int) -> UIImage? {
        switch conditionID {
        case let x where x < 600:
            return UIImage(named: "rain_1x")
        case 600...699:
            return UIImage(named: "snow_1x")
        case 800:
            return UIImage(named: "sun_1x")
        case 801...802:
            return UIImage(named: "sunc_1x")
        case 803:
            return UIImage(named: "ptcl_1x")
        case 804:
            return UIImage(named: "cloud_1x")
        default:
            return nil
        }
    }
}
