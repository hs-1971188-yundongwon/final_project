//
//  WeekViewController.swift
//  Ex
//
//  Created by dongwon on 2024/05/22.
//

import UIKit
import CoreLocation

class WeekViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate{
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let weatherSite = "https://api.openweathermap.org/data/3.0/onecall"
    let weatherKey = "30615eae9b4b4d225f11da0a0c5a4232"
    
    //https://api.openweathermap.org/data/3.0/onecall?lat=37.785834&lon=-12.406417&exclude=curent,minutely,daily&appid=30615eae9b4b4d225f11da0a0c5a4232
    
    var locationManager = CLLocationManager()
    var weeklyWeather: WeeklyWeather?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        setBackgroundImage()
        setupLocationManager()
        tableView.backgroundColor = UIColor.clear
        
        tableView.layer.borderColor = UIColor.white.cgColor
        tableView.layer.borderWidth = 2.0
    }
    
    func setBackgroundImage() {
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = UIImage(named: "background")
        backgroundImageView.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImageView, at: 0)
    }
    
    func setupLocationManager() {
           locationManager.delegate = self
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           locationManager.requestWhenInUseAuthorization()
           
           if CLLocationManager.locationServicesEnabled() {
               locationManager.startUpdatingLocation()
           } else {
               print("Location services are not enabled")
           }
       }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                manager.stopUpdatingLocation()  // 위치 업데이트 중지
                getWeeklyWeatherInfo(location: location.coordinate)
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Failed to find user's location: \(error.localizedDescription)")
        }
    
    func getWeeklyWeatherInfo(location: CLLocationCoordinate2D) {
        var urlStr = weatherSite
        urlStr += "?lat=\(location.latitude)&lon=\(location.longitude)"
        urlStr += "&exclude=current,minutely,hourly&appid=\(weatherKey)"
        
        
        print("url \(urlStr)")
        guard let url = URL(string: urlStr) else {
            print("Invalid URL")
            return
        }
        
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            guard let jsonData = data else {
                if let error = error {
                    print("Error: \(error)")
                }
                return
            }
            
            do {
                let decoder = JSONDecoder()
                self.weeklyWeather = try decoder.decode(WeeklyWeather.self, from: jsonData)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("JSON Parsing Error: \(error)")
            }
        }
        dataTask.resume()
    }
    
    func getWeatherIcon(for condition: Int) -> UIImage? {
            switch condition {
            case let x where x < 600: // Rain
                return UIImage(named: "rain_1x")
            case 600...699: // Snow
                return UIImage(named: "snow_1x")
            case 800: // Clear
                return UIImage(named: "sun_1x")
            case 801...802: // Light clouds
                return UIImage(named: "sunc_1x")
            case 803: // Partly cloudy
                return UIImage(named: "ptcl_1x")
            case 804: // Overcast
                return UIImage(named: "cloud_1x")
            default:
                return UIImage(named: "sun_1x")
            }
        }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weeklyWeather?.daily.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! MyTableViewCell
               
            if let dailyWeather = weeklyWeather?.daily[indexPath.row] {
                let date = Date(timeIntervalSince1970: TimeInterval(dailyWeather.dt))
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd"
                   
                cell.dataLabel.text = dateFormatter.string(from: date)
                cell.minLabel.text = String(format: "%.0f°C", round(dailyWeather.temp.min - 273.15))
                cell.maxLabel.text = String(format: "%.0f°C", round(dailyWeather.temp.max - 273.15))
                   
                if let weatherConditionId = dailyWeather.weather.first?.id {
                               cell.weatherIconImageView.image = getWeatherIcon(for: weatherConditionId)
                           }
                       }
               
               return cell
           }
    
}
