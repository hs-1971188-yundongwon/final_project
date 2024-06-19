# 프로젝트 명칭

## 1. 프로젝트 정의
Swift 언어와 OpenWeather API를 활용하여 사용자의 현재 위치를 기반으로 실시간 날씨 정보와 일주일간의 일기예보를 제공하는 애플리케이션

## 2. 프로젝트 구현 기능
- **현재 위치 날씨 제공**: 사용자의 현재 위치를 자동으로 감지하고, 해당 지역의 현재 날씨 상황을 제공합니다.
- **시간별 날씨 변화 제공**: 사용자 위치의 날씨 변화를 1시간 간격으로 업데이트하여 제공합니다.
- **주간 일기예보 제공**: 사용자의 현재 위치에 대한 일주일간의 날씨 예보를 보여줍니다.

## 3. 프로젝트 구조
![스크린샷 2024-06-17 195043](https://github.com/hs-1971188-yundongwon/final_project/assets/115438439/a658a056-aaef-4864-993f-e435cb9334d7)

## 4. 결과물
![스크린샷 2024-06-17 135553](https://github.com/hs-1971188-yundongwon/final_project/assets/115438439/df308b67-f380-4a43-958f-9120de635d95)
![스크린샷 2024-06-17 194121](https://github.com/hs-1971188-yundongwon/final_project/assets/115438439/0cd770ae-995b-4d9b-9a49-e5522c4d048b)

---
# 코드 설명

## CurrentViewController.swift 코드 설명

### 클래스 및 함수 설명

#### `CurrentViewController`
- `UIViewController`를 상속받는 메인 뷰 컨트롤러 클래스로, 위치 기반 날씨 정보를 제공합니다.

#### `setupLocationManager()`
- 위치 서비스를 초기화하고 사용자의 위치 접근 권한을 요청합니다.

#### `setBackgroundImage()`
- 뷰의 배경 이미지를 설정합니다.

#### `locationManager(_:didUpdateLocations:)`
- 위치가 업데이트 될 때 호출되어, 최신 위치에 기반한 날씨 정보를 요청합니다.

#### `locationManager(_:didFailWithError:)`
- 위치 정보를 얻는 데 실패했을 때 호출되며, 오류 메시지를 출력합니다.

### Extensions 설명

### `UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout`
- 컬렉션 뷰의 데이터 소스 및 델리게이트를 구현합니다.

#### `collectionView(_:numberOfItemsInSection:)`
- 섹션별 아이템 개수를 반환합니다.

#### `collectionView(_:cellForItemAt:)`
- 각 셀에 대한 설정을 수행합니다. 시간별 날씨 정보를 각 셀에 표시합니다.

### Networking 관련 함수

#### `getWeeklyWeatherInfo(location:)`
- 주어진 위치의 일주일간 날씨 정보를 비동기적으로 요청하고, 결과를 파싱하여 화면을 업데이트합니다.

#### `getWeatherInfo(location:)`
- 특정 위치에 대한 현재 날씨 정보를 요청합니다. 응답을 받아 뷰의 각 요소를 업데이트합니다.

### 데이터 처리 및 UI 업데이트

#### `makeUpWeatherInformation(jsonData:)`
- 서버로부터 받은 JSON 데이터를 파싱하여 날씨 정보를 구성하고, 해당 정보를 바탕으로 UI를 업데이트합니다.

#### `getWeatherIcon(for:)`
- 날씨 조건 코드에 따라 해당하는 날씨 아이콘 이미지를 반환합니다.

## WeekViewController.swift 코드 설명

### 클래스 설명

#### `WeekViewController`
- `UIViewController`를 상속받는 클래스로, 위치 기반의 일주일간 날씨 정보를 제공합니다. `UITableViewDataSource` 및 `UITableViewDelegate` 프로토콜과 `CLLocationManagerDelegate` 프로토콜을 구현하여 위치 업데이트와 테이블 뷰 관리를 담당합니다.

### 주요 메소드 및 구현

#### `viewDidLoad()`
- 뷰 컨트롤러의 뷰가 메모리에 로드된 후 초기 설정을 수행합니다. 테이블 뷰의 데이터 소스와 델리게이트를 설정하고, 배경 이미지를 설정하며, 위치 매니저를 설정합니다.

#### `setBackgroundImage()`
- 뷰의 전체 배경으로 이미지를 설정하는 메소드입니다. `UIImageView`를 사용하여 배경 이미지를 적용합니다.

#### `setupLocationManager()`
- 위치 관리자(`CLLocationManager`)를 설정하고, 위치 사용 권한을 요청합니다. 위치 서비스가 활성화된 경우, 위치 업데이트를 시작합니다.

#### `locationManager(_:didUpdateLocations:)`
- 위치 정보가 업데이트 되었을 때 호출됩니다. 새로운 위치 정보를 받으면 일주일간의 날씨 정보를 요청하는 `getWeeklyWeatherInfo` 메소드를 호출합니다.

#### `locationManager(_:didFailWithError:)`
- 위치 정보 획득에 실패했을 때 오류를 로깅합니다.

#### `getWeeklyWeatherInfo(location:)`
- 주어진 위치에 대한 일주일간의 날씨 정보를 비동기적으로 API를 통해 요청합니다. 데이터를 성공적으로 받아오면 JSON을 파싱하여 `WeeklyWeather` 구조체에 저장하고 테이블 뷰를 리로드합니다.

### 테이블 뷰 관련 메소드

#### `tableView(_:numberOfRowsInSection:)`
- 테이블 뷰의 섹션당 행의 개수를 반환합니다. `WeeklyWeather` 모델의 `daily` 배열의 길이를 기준으로 합니다.

#### `tableView(_:cellForRowAt:)`
- 각 테이블 뷰 셀을 구성합니다. 특정 날짜의 최소, 최대 기온과 날씨 아이콘을 셀에 표시합니다.

## WeatherCollectionViewCell.swift 코드 설명

### 개요
`WeatherCollectionViewCell` 클래스는 날씨 관련 정보를 표시하는 컬렉션 뷰 셀을 정의합니다. 이 클래스는 UIKit을 활용하여 사용자 인터페이스 요소를 관리하며, 날씨 데이터를 시각적으로 표현합니다.

## 구조체 `WeatherHourlyData`
- 날짜(`Date`), 온도(`Double`), 그리고 날씨 아이콘 이름(`String`)을 포함하는 날씨 시간별 데이터를 저장하는 구조체입니다.

## 클래스 `WeatherCollectionViewCell`
- `UICollectionViewCell`을 상속받아, 날씨 데이터를 표시하기 위한 레이블과 이미지 뷰를 포함합니다.
  - `@IBOutlet weak var dataLabel: UILabel!`: 날짜나 시간을 표시하는 레이블.
  - `@IBOutlet weak var imageIcon: UIImageView!`: 날씨 아이콘을 표시하는 이미지 뷰.
  - `@IBOutlet weak var tempertureLabel: UILabel!`: 온도를 표시하는 레이블.

## Extension `WeatherCollectionViewCell`
- 날씨 상태에 따라 적절한 아이콘을 반환하는 메소드 `updateWeatherIcon(conditionID: Int) -> UIImage?`를 포함합니다.
  - 이 메소드는 날씨 조건 코드(`conditionID`)를 기반으로 하여 날씨 아이콘을 선택하고, 해당 아이콘 이미지를 반환합니다.

## MyTableViewCell.swift 코드 설명

### 개요
- `UITableViewCell`을 상속받는 커스텀 테이블 뷰 셀 클래스입니다. 일주일간의 날씨 정보를 표시하는 데 사용됩니다.

### 메서드
- `awakeFromNib()`: 셀이 인터페이스 파일에서 깨어난 후 초기 설정을 수행합니다. 여기서는 셀의 배경을 투명하게 설정합니다.

### 속성
- `@IBOutlet weak var dataLabel: UILabel!`: 날짜 정보를 표시합니다.
- `@IBOutlet weak var minLabel: UILabel!`: 해당 날짜의 최저 기온을 표시합니다.
- `@IBOutlet weak var maxLabel: UILabel!`: 해당 날짜의 최고 기온을 표시합니다.
- `@IBOutlet weak var weatherIconImageView: UIImageView!`: 날씨 상태에 해당하는 아이콘 이미지를 표시합니다.

## WeatherModel.swift 코드 설명

### 개요
`WeatherModel`은 OpenWeatherMap API에서 제공하는 날씨 데이터를 효과적으로 파싱하고 저장하기 위한 데이터 모델을 정의하는 파일입니다. 이 파일은 다양한 날씨 데이터를 포함하는 구조체들을 포함하고 있으며, 각 구조체는 JSON 데이터와의 변환을 용이하게 하기 위해 `Codable` 프로토콜을 채택합니다.

### 모델 구조

#### `WeeklyWeather`
- 일주일 동안의 날씨 정보를 담고 있는 배열인 `daily`를 포함합니다.

#### `DailyWeather`
- 특정 날의 날씨를 나타내며, 날짜(`dt`), 온도(`temp`), 날씨 상태(`weather`)를 포함합니다.

#### `Temperature`
- 최저(`min`) 및 최고(`max`) 온도 정보를 저장합니다.

#### `Weather`
- 날씨 상태를 나타내는 식별자(`id`)와 아이콘 이름(`icon`)을 포함합니다.

#### `CurrentHourlyWeather`
- 시간별 날씨 정보를 저장하는 `hourly` 배열을 포함합니다.

#### `hourlyWeather`
- 특정 시간의 날씨 정보를 나타내며, 시간(`dt`), 현재 온도(`temp`), 날씨 상태(`weather`)를 포함합니다.

---
#앱 소개 영상
[![Watch the video](https://img.youtube.com/vi/uakwwYSS6Ns/maxresdefault.jpg)](https://youtu.be/uakwwYSS6Ns)
