//
//  WheatherModel.swift
//  Ex
//
//  Created by dongwon on 2024/05/22.
//

import Foundation

struct WeeklyWeather: Codable {
    let daily: [DailyWeather]
}

struct DailyWeather: Codable {
    let dt: Int
    let temp: Temperature
    let weather: [Weather]
}

struct Temperature: Codable {
    let min: Double
    let max: Double
}

struct Weather: Codable {
    let id: Int
    let icon: String
}

struct CurrentHourlyWeather : Codable  {
    let hourly: [hourlyWeather]
}

struct hourlyWeather: Codable {
    let dt: Int
    let temp: Double
    let weather: [Weather]
}

