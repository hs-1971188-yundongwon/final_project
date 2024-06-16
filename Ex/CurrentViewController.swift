//
//  CurrentViewController.swift
//  Ex
//
//  Created by dongwon on 2024/05/22.
//

import UIKit
import CoreLocation

class CurrentViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var collectionview: UICollectionView!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    
    var locationManager = CLLocationManager()
    var currentHourlyWeather: CurrentHourlyWeather?

    let weatherSite = "https://api.openweathermap.org/data/2.5/weather"
    let pollutionSite = "https://api.openweathermap.org/data/2.5/air_pollution"
    let weatherKey = "30615eae9b4b4d225f11da0a0c5a4232"
    let hourlySite = "https://api.openweathermap.org/data/3.0/onecall?"
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        collectionview.dataSource = self
        collectionview.delegate = self
        
        
        setBackgroundImage()
        collectionview.backgroundColor = UIColor.clear
        
        stackView.layer.borderWidth = 1.0
        stackView.layer.borderColor = UIColor.white.cgColor
        collectionview.layer.borderWidth = 1.0
        collectionview.layer.borderColor = UIColor.white.cgColor
        
        stackView.layer.cornerRadius = 10
        collectionview.layer.cornerRadius = 10
        
    }
    
    func setBackgroundImage() {
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = UIImage(named: "background")
        backgroundImageView.contentMode = .scaleAspectFill
        view.insertSubview(backgroundImageView, at: 0)
    }
  
    func setupLocationManager() {
            locationManager.delegate = self
            // 거리 정확도
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            // 위치 사용 허용 알림
            locationManager.requestWhenInUseAuthorization()
            // 위치 사용을 허용하면 현재 위치 정보를 가져옴
            if CLLocationManager.locationServicesEnabled() {
               locationManager.startUpdatingLocation()
            }
            else {
                print("위치 서비스 허용 off")
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.last {
                locationManager.stopUpdatingLocation()  // Stop location updates if not needed continuously
                getWeatherInfo(location: location.coordinate)
                //getAirPollutionData(location: location.coordinate)
                getWeeklyWeatherInfo(location: location.coordinate)
            }
        if let location = locations.first {
            print("위치 업데이트!")
            print("위도 : \(location.coordinate.latitude)")
            print("경도 : \(location.coordinate.longitude)")
        }
    }
        
    
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Failed to find user's location: \(error.localizedDescription)")
        }
    
    
}

extension CurrentViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as? WeatherCollectionViewCell else {
                return UICollectionViewCell()
            }

            if let hourlyWeather = currentHourlyWeather?.hourly[indexPath.row], let weather = hourlyWeather.weather.first {
                
                let date = Date(timeIntervalSince1970: TimeInterval(hourlyWeather.dt))
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .none
                dateFormatter.timeStyle = .short
                dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
                let localTime = dateFormatter.string(from: date)
                    
                cell.dataLabel.text = localTime
                cell.tempertureLabel.text = String(format: " %.2f°C", hourlyWeather.temp - 273.15)
                            
                cell.imageIcon.image = cell.updateWeatherIcon(conditionID: weather.id)
            }

            return cell
    }
}

extension CurrentViewController {
    func getWeeklyWeatherInfo(location: CLLocationCoordinate2D) {
        var urlStr = hourlySite
        urlStr += "lat=\(location.latitude)&lon=\(location.longitude)"
        urlStr += "&exclude=current,minutely,daily&appid=\(weatherKey)"
        
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

                self.currentHourlyWeather = try decoder.decode(CurrentHourlyWeather.self, from: jsonData)
                DispatchQueue.main.async {
                    self.collectionview.reloadData()
                }
            } catch {
                print("JSON Parsing Error: \(error)")
            }
        }
        dataTask.resume()
    }
}
extension CurrentViewController {
        func getWeatherInfo(location: CLLocationCoordinate2D) {
            var urlStr = "\(weatherSite)?lat=\(location.latitude)&lon=\(location.longitude)&appid=\(weatherKey)"
            urlStr += "&" + "appid=" + weatherKey
            
            print("weather \(urlStr)")
            let request = URLRequest(url: URL(string: urlStr)!) // Default method is GET
            let session = URLSession(configuration: .default)
            let dataTask = session.dataTask(with: request) { (data, response, error) in
                guard let jsonData = data else {
                    if let error = error {
                        print("Error: \(error)")
                    }
                    return
                }
                let (tempMin,tempMax, image, currentTemp, description, locationName) = self.makeUpWeatherInformation(jsonData: jsonData)
                    DispatchQueue.main.async {
                        self.minLabel.text = tempMin
                        self.maxLabel.text = tempMax
                        self.weatherImage.image = image
                        self.currentTemp.text = currentTemp
                        self.weatherDescription.text = description
                        self.currentLocation.text = locationName // 위치 정보를 표시하는 레이블 업데이트
                }
            }
            dataTask.resume()
        }
    }

extension CurrentViewController {
        func makeUpWeatherInformation(jsonData: Data) -> (String, String, UIImage?, String, String, String) {
            let jsonObjct = try! JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
            
            let weather = jsonObjct["weather"] as! [Any]
            let weather0 = weather[0] as! [String: Any]
            //let icon = weather0["icon"] as! String
            let description = weather0["description"] as! String
            let id = weather0["id"] as! Int
            
            let main = jsonObjct["main"] as! [String: Any]
            let temp = round((main["temp"] as! Double - 273.15) * 10) / 10
            let temp_min = round((main["temp_min"] as! Double - 273.15) * 10) / 10
            let temp_max = round((main["temp_max"] as! Double - 273.15) * 10) / 10
            var currentTemp = "\(temp)°C\n"
            
            var tempMin = "min: \(temp_min)° "
            var tempMax = "max: \(temp_max)°"
            
            let location = jsonObjct["name"] as! String
            
            let image = getWeatherIcon(for: id)
                    
            return (tempMin, tempMax, image, currentTemp, description, location)
        }
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

