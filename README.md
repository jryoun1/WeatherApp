# WeatherApp

> 날씨 OpenAPI를 활용하여 위치를 기반으로 현재 날씨와 5일치 예보를 보여주는 날씨앱 구현하기 



## Index

- [기능](#기능)
- [설계 및 구현](#설계-및-구현)
- [Trouble shooting](#Trouble-shooting)
- [관련 학습 내용](#관련-학습-내용)

<p>
  <img src="https://user-images.githubusercontent.com/45090197/126947562-802a54bc-d820-4165-9c91-91b2453a683e.gif" width="260" height="550">
  <img src="https://user-images.githubusercontent.com/45090197/126941873-fe1c0369-b2cb-45e9-b48d-efbef0149f53.gif" width="260" height="550">
  <img src="https://user-images.githubusercontent.com/45090197/126942966-cda863c0-35f8-479b-af87-479696dd4506.gif" width="260" height="550"> 
</p>
<br>


## 기능
- [날씨 정보](#날씨-정보)
- [정보 새로 고침](#정보-새로-고침)
- [다크모드 대응](#다크모드-대응)
- [사용자 위치 권한 선택에 따른 대응](#사용자-위치-권한-선택에-따른-대응)

<br>

### 날씨 정보

현재 위치를 기기에서 가져오고, 이를 바탕으로 OpenWeatherMap API를 통해서 날씨정보를 받아와서 보여주는 기능 <br>
<img src="https://user-images.githubusercontent.com/45090197/126947562-802a54bc-d820-4165-9c91-91b2453a683e.gif" width="300" height="630"> 

<br>

### 정보 새로 고침
화면을 위에서 아래로 끌었다 놓으면 날씨 정보들을 새로 고치는 기능 <br>
<img src="https://user-images.githubusercontent.com/45090197/126941838-97107b86-d934-4f53-90f6-271810f60863.gif" width="300" height="630"> 

<br>

### 다크모드 대응
일반 모드와 다크 모드인 경우에 배경화면과 글자색의 변화를 주어서 다크모드에 대응할 수 있는 기능 <br>
<img src="https://user-images.githubusercontent.com/45090197/126941873-fe1c0369-b2cb-45e9-b48d-efbef0149f53.gif" width="300" height="630"> 

<br>

### 사용자 위치 권한 선택에 따른 대응
사용자 위치 정보를 얻기 위한 권한 요청 시, 이를 허가하지 않는 경우 설정 창으로 보내주는 기능 <br>
오른쪽 = Xcode Simulator / 왼쪽 = iPhone XR 실제 기기 <br>

<p>
  <img src="https://user-images.githubusercontent.com/45090197/126942966-cda863c0-35f8-479b-af87-479696dd4506.gif" width="300" height="630">
  <img src="https://user-images.githubusercontent.com/45090197/126945699-829efa90-63c6-45d0-9673-7f516bbb2048.gif" width="300" height="630">
</p>

<br>

## 설계 및 구현

### 날씨 모델, View, Controller - MVC 

![image-20210723223021699](https://user-images.githubusercontent.com/45090197/126943355-e33260a7-4790-4036-8f63-8b0add9e9951.png)

- MVC pattern 적용 [👉🏻공부한 내용으로 이동](#MVC-Design-pattern)
- MainTableViewController에서 TableView를 구현 방법
  - 2개의 cell을 사용해서 2개의 섹션으로 구현하는 방법
  - 1개의 섹션으로 1개의 cell과 TableViewHeaderView로 구현하는 방법 ✅

이유는 TableView의 위쪽에 표현되는 현재 날씨의 경우에는 cell이 여러 번 반복되는 것이 아니라 한 번만 나타나고 사용되기 때문에 Cell로 만드는 것보다는 TableViewHeaderView를 사용하여 구현

<br>

### 역할 분배

#### view 관련

|            class             |                             역할                             |
| :--------------------------: | :----------------------------------------------------------: |
| `WeatherTableViewHeaderView` | MainViewContoller의 weatherTableView에서 현재 날씨를 나타내는 테이블 뷰 헤더뷰를 구성한다 |
|    `WeatherTableViewCell`    | MainViewController의 weatherTableView에서 5일치의 날씨를 나타내는 테이블 뷰 셀을 구성한다 |
|     `MainViewController`     | LocationManager를 사용해서 현재 위치를 얻고, NetworkManager를 통해서 날씨 데이터를 받아서 사용자의 화면에 보여준다 |

#### Network 관련

|    class/enum    |                      역할                      |
| :--------------: | :--------------------------------------------: |
|   `WeatherAPI`   |            OpenWeatherMap API 분류             |
| `NetworkManager` | 네트워킹 통해 날씨 정보와 날씨 이미지 가져온다 |
|   `ConfigURL`    |       네트워킹에 필요한 URL을 반환해준다       |

#### Error 관련

|      enum/extension      |                             역할                             |
| :----------------------: | :----------------------------------------------------------: |
|      `WeatherError`      | WeatherApp에서 발생할 수 있는 에러 종류 및 에러 메시지 분류  |
| `UIViewController+Error` | MainViewController에서 에러가 발생했음을 알릴 필요가 있는 경우 Alert 창을 띄워주도록 구현 |

#### Utilities

|     class/struct      |                             역할                             |
| :-------------------: | :----------------------------------------------------------: |
|   `LocationManager`   | CLLocationManager 사용하여 현재 위치를 가져오고, 위치 사용 권한 체크 및 주소 변환하여 반환 |
| `CustomDateFormatter` | 주어진 dt (unix, UTC) 데이터를 사용하여 원하는 문자열 형식으로 변환해주는 역할 |
|    `SettingOpener`    | 사용자가 위치 사용 권한 요청을 거부한 경우, 설정 창으로 app을 스위칭하는 역할 |
|  `ImageCacheManager`  | 날씨 이미지를 매번 받지 않기 위해서, 처음에만 서버로부터 받아오고 이후에 memory cache에 저장 및 사용 |

<br>

### 현재 위치 받아오기

> `LocationManager` 사용

위치를 받아오는 과정 👉🏻 [공부한 내용으로 이동](#CLLocationManger,-CLLocationManagerDelegate)

1. `CLLocationManager` 객체 생성
2. delegate와 location 데이터 정확도 설정  : `configureLocationManager()` 함수에서 `desiredAccuracy` 프로퍼티 설정
3. 사용자 위치정보 권한 받기 : `requestAuthorization()` 함수에서 `requestWhenInUseAuthorization()`
4. 권한 체크 : `checkLocationAuthorization()` 함수
   - `CLAuthorizationStatus` = `.authorizedAlways` / `.authorizedWhenInUse` 인 경우 허가
5. 위치 요청: `requestLocation()` 함수
   - delegate의 `didUpdateLocation` 함수 호출
6. Delegate 함수 : `didUpdateLocation` 내부에서는 `.stopUpdatingLocation()` 과 `convertLocationToAddress()` 호출

<br>

### 날씨 정보 받아오기 & 파싱하기 - OpenWeatherMap API / URLSession / Decodable

> `NetworkManager` 와 `configureURL` 사용 
>
> [Current weather data API](https://openweathermap.org/current) / [5 day weather forecast API](https://openweathermap.org/forecast5#JSON)

- URLSession 활용하여 네트워크 통신 👉🏻 [공부한 내용으로 이동](#URL-Loading-System)
- Decodable : `Data` → `CurrentWeather`, `ForecastWeatherList` 변환
  - `CurrentWeather`, `ForecastWeatherList` 는 `Decodable` 프로토콜 준수
  - `JSONDecoder` 를 사용하여 디코딩

<br>

### 날씨 이미지 캐싱

> ImageCacheManager 사용

1. NSCache를 가지는 ImageCacheManager singleton 클래스로 생성 
   - Singleton 으로 구현한 이유는 앱 내부에서 memory cache에 저장하고 불러오는 것은 app 내부의 여러 곳에서 사용될 수 있음
   - 따라서 하나의 인스턴스로 memory cache에 저장하거나 불러오도록 하는 것이 적절하다고 판단
2. 날씨 이미지를 가져오기 전에 캐싱된 데이터에 해당 이미지가 있는지 검사
   - 있다면 이미지를 사용
   - 없다면 3번 과정 수행
3. 네트워크 통신을 하여 비동기처리로 이미지를 가져와서 사용
4. ImageCacheManager의 캐시에 새롭게 가져온 이미지를 저장

👉🏻 [공부한 내용으로 이동](#Cache)

<br>

### API 데이터 기반 시간 변환

> CustomDateFormatter 사용

API 에서 받은 dateTime (UTC 표준, unix) → 현재 위치의 시간을 한국어로 변환

- `unix` : 시스템이 시간을 표현하는 방법이며, 1970년 1월 1일 목요일(UTC)로부터 이후 경과된 시간을 나타냄
- `TimeInterval` : Double 타입의 별칭 <br>
  ```swift
  typealias TimeInterval = Double
  ```
1. `dt` TimeInterval (utc 단위 시간) → `NSDate` 타입으로 변경
2. CustomDataFormatter 사용해서 한국어, 원하는 형식의 String으로 변환

<br>

### 다크 모드 대응

- 다크모드와 일반모드에 따라 MainViewController의 weatherTableView 배경 변경
- 다크모드와 일반모드에 따른 weatherTableView 내부 글씨색 변경

<br>

### 정보 새로 고침

- iOS 10 이전 버전에서는 TableView에 `view` 에 등록, 이후 버전에서는 TableView에 `refreshControl` 프로퍼티 존재하므로 대입 가능
- `UIRefreshControl` 사용하여 구현

```swift
final class MainViewController: UIViewController {
  	override func viewDidLoad() {
      setupRefresh()
    }
		private func setupRefresh() {
        let refresh: UIRefreshControl = UIRefreshControl()
        refresh.addTarget(self, action: #selector(updateUI(refresh: )), for: .valueChanged)
      	//refresh.attributedTitle = NSAttributedString(string: "새로고침")
        refresh.tintColor = .gray
        weatherTableView.refreshControl = refresh
    }
    
    @objc private func updateUI(refresh: UIRefreshControl) {
        locationManager.requestAuthorization()
        refresh.endRefreshing()
        weatherTableView.reloadData()
    }
}
```

<br>

## Trouble shooting

[1️⃣ 위치 정보와 관련해서 사용자에게 위치 정보 수집 권한을 거절했을 때 발생하는 문제](#위치-정보와-관련해서-사용자에게-위치-정보-수집-권한을-거절했을-때-발생하는-문제) <br>

[2️⃣ Utility의 타입에 대해서](#utility의-타입에-대해서) <br>

[3️⃣ 날씨 정보 및 이미지를 받아오는 비동기처리에서의 에러 핸들링 방법](#날씨-정보-및-이미지를-받아오는-비동기처리에서의-에러-핸들링-방법) <br>

[4️⃣ 테이블 뷰 내부에서 비동기적처리로 인한 이미지 로딩 문제](#테이블-뷰-내부에서-비동기적처리로-인한-이미지-로딩-문제) <br>

[5️⃣ 테스트 가능하도록 코드 작성하기 🤔](#테스트-가능하도록-코드-작성) <br>

<br>

### 위치 정보와 관련해서 사용자에게 위치 정보 수집 권한을 거절했을 때 발생하는 문제

- 문제상황

  - 사용자의 위치 정보를 얻기 위해서는 사용자로부터 위치 정보 수집 권한을 요청하게 되는데, 이때 만약 사용자가 거절하는 경우에는 사용자에게 권한 설정을 다시 할 수 있도록 설정 창으로 보내주어야 하는지 아니면 사용자의 의견을 존중해서 앱이 실행 되지 않아야할까에 대한 고민 발생

- 해결 방법 

  - 기획에 따라서 다르겠지만, 실제로 서비스에서는 위치 정보를 동의하지 않는 사람들이 많을 수도 있기 때문에 날씨 정보를 자신의 현재 위치가 아닌 원하는 위치를 검색해서 받아올 수 있게 될 수도 있다. 그렇기 때문에 거절 당할 경우에는 **default 데이터를 보여주는 형식으로 수정**하였다. 또한 사용자가 거절을 하게 되면, **"정확한 날씨 정보를 받아오기 위해서는 현재 위치 권한이 필요합니다. 설정창으로 이동할까요"라는 경고 문구와 함께 경고창을 띄워주며 이동 버튼과 취소 버튼을 만들어주면** 실수로 거절한 사용자도 쉽게 다시 위치 정보 수집 권한 요청에 대한 상태를 변경할 수 있도록 수정하였다. 

<br>

### Utility의 타입에 대해서

- 문제상항

  - WeatherApp 프로젝트 내부에는 NetworkManager, ImageCacheManager, LocationManager와 같이 많은 Utility가 존재한다. 
    - `NetworkManager` : singleton으로 구현
    - `ImageCacheManager` : singleton으로 구현
    - `LocationManager` : class와 global function으로 구현
  - 물론 현재는 화면이 하나이고 메모리에 해당 객체들이 시작부터 끝까지 남아있어도 크게 상관이 없지만, 만약 다른 화면들이 추가되고 App이 확장된다면 과연 해당 타입의 객체들이 메모리에 항상 남아있어야할까에 대한 의문이 생기게 되었다. 따라서 각 타입을 singleton class, struct, class 중에서 어떤 것을 사용하는 것이 효율적이며, 내부의 프로퍼티나 메소드의 경우에도 static, global 로 구현하냐에 대한 고민 사항이 발생하였다. 

- 해결 방법

  - 이를 해결하기 위해서는 먼저 각각의 Utility들의 특징을 파악해야만 했다. 
    - `NetworkManager` 타입의 경우에는 내부에 상태를 저장하는 프로퍼티는 없기 때문에 singleton보다는 struct 타입으로 수정하였고, init() 함수로 URLSession을 사용자가 커스텀해서 인스턴스를 생성할 수 있도록 수정하였다. 
    - `ImageCacheManager` 타입은 memory cache를 app 전체에서 어떻게 사용할 것인가에 따라서 다르게 구현할 수 있을 것 같은데, 추후에 app이 확장되어 화면들이 추가되었을 때에도 한 번 다운 받은 날씨 이미지를 사용할 수 있게 하기 위해서 singleton 으로 그래도 유지하였다. 
    - `LocationManager` 타입은 내부에 현재 위치를 주소로 변경한 `currentAddress` property를 가지고 있으므로  추가로 app이 확장되어 화면이 늘어나도 참조를 통해서 값을 확인할 수 있도록 class 타입을 유지하였다.

<br>

### 날씨 정보 및 이미지를 받아오는 비동기처리에서의 에러 핸들링 방법

- 문제상황

  - URLSession의 `dataTask(with:)` 의 경우에는 completionHandler를 비동기적으로 호출하게 되는데, `throws` 키워드의 경우에는 비동기적으로 return 하는 작업을 처리할 때는 사용할 수 없기 때문에 만약 네트워크 통신 중에 에러가 발생하게 되면 이를 어떻게 해결할 수 있을지에 대한 의문

- 해결 방법

  - `Result Type` 을 활용하여 네트워킹 처리를 하는 비동기작업에서의 에러 핸들링을 진행하였다. 

    ```swift
    // Result Type
    @frozen enum Result<Success, Failure> where Failure: Error
    ```

    실제 처리를 진행할 때는 네트워킹 처리가 성공인 경우에는 `Data` 타입을 넘겨주고, 그렇지 않고 에러가 발생하는 경우는 `WeatherError` 타입의 에러를 넘겨줄 수 있도록 구현하였다. 이때 typealias를 사용하여 의미가 더 명확해질 수 있게 하였다. 

    ```swift
    final class NetworkManager {
      	/*..*/
        typealias resultHandler = (Result<Data?, WeatherError>) -> Void
      	
      	/*..*/
        private func communicateToServer(with request: URLRequest, completion: @escaping resultHandler) {
            let session: URLSession = URLSession.shared
            let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                
                if let _ = error {
                    return completion(.failure(.failTransportData))
                }
                
                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                    return completion(.failure(.failGetData))
                }
                
                guard let data = data else {
                    return completion(.failure(.failGetData))
                }
                return completion(.success(data))
            }
            dataTask.resume()
        }
    }
    ```

⚠️  `throws` 를 통한 비동기처리가 어려운 이유

1. 비동기처리 작업이 포함된 메소드에 `throws` 를 사용하게 되면, `throws` 가 메소드 내의 비동기처리과정의 결과(에러 발생)를 기다리는 것이 아니라 메소드 호출 시점에 시행되기 때문에 에러 발생 가능 시점보다 먼저 throw가 되어서 에러를 처리할 수 없게 된다

2. `throws` 를 활용한 에러처리를 진행하는 경우, 아래와 completion에 throws가 담겨있는 function 타입을 담아야한다. 이 방법은 completion에서 타입에 대한 try문을 반환하면서 타입 내부에서 throw를 또 진행하게 되므로 에러 처리가 복잡하다

   ```swift
   enum APIError: Error { 
     case failTransportData
     case failGetData
   }
   
   struct WeatherData {
     init(fromData: Data) throws { }
   }
   
   typealias WeatherDataBuilder = Void throws -> WeatherData // throws가 담긴 function 타입
   
   func loadData(completion: @escaping WeatherDataBuilder -> Void) { 
     let request = URLRequest(url: "https://https://openweathermap.org/current")
     let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
       completion({ WeatherDataBuilder in
         if let error = error { throw APIError.failTransportData }
         guard let data = data else { throw APIError.failGetData }
         return try WeatherData(fromData: data)
       })
     }.resume()
   }
   
   loadData { (weatherDataBuilder: WeatherDataBuilder) in
     do {
       let weatherData = try weatherDataBuilder()
     } catch {
       print("데이터를 가져오는 도중에 비동기처리 \(error) 발생")
     }
   }
   ```

<br>

### 테이블 뷰 내부에서 비동기적처리로 인한 이미지 로딩 문제

- 문제상황

  - 날씨 이미지 데이터를 다운로드 받아서 화면에 표시하는 동안, 사용자가 화면을 위아래로 스크롤 해서 움직일 수 있다. 그렇게 되면 화면에 표시해야할 cell의 index가 바뀌게 되어, 실제 다운로드 받은 이미지의 cell index와 현재 화면에 표시되기 위해서 `cellForRowAt` 함수에서 호출하고 있는 cell의 index가 다를 수 있기 때문에 이미지가 다른 cell에 들어가게 되는 문제가 발생하게 된다.

- 해결 방법

  - `cellForRowAt` 함수 내부에서 현재 표시될 cell의 index와 이미지 다운로드가 끝났을 때의 index가 일치하는 상황에서만 이미지를 세팅해 줄 수 있도록 `DispatchQueue.main.async` 내부에서 처리해주었다. 

    ```swift
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let weatherTableViewCell = tableView.dequeueReusableCell(withIdentifier: WeatherTableViewCell.cellID, for: indexPath) as? WeatherTableViewCell else {
                return UITableViewCell()
            }
            
            if let forecastWeatherData = forecastWeatherList?.list[indexPath.row],
               let imageID = forecastWeatherData.weather.first?.icon {
                weatherTableViewCell.setupCellData(data: forecastWeatherData)
                
                DispatchQueue.main.async {
                    if let index: IndexPath = tableView.indexPath(for: weatherTableViewCell){
                        if index.row == indexPath.row {
                            weatherTableViewCell.weatherImageView.loadImage(imageID)
                        }
                    }
                }
            }
            
            return weatherTableViewCell
        }
    ```

  - 그리고 날씨 이미지를 매번 네트워킹 통신을 통해서 비동적으로 받아오는 것보다는 캐시를 활용하여 화면이 버벅일 수 있는 문제도 같이 해결할 수 있도록 하였다. 

    ```swift
    final class ImageCacheManager {
        static let shared = NSCache<NSString, UIImage>()
        private init() {}
    }
    
    extension UIImageView {
        func loadImage(_ imageID: String) {
            let cacheKey = NSString(string: imageID)
          	// 다운 받으려고 하는 이미지가 이미 캐시 안에 있는 경우 
            if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
                self.image = cachedImage
                return
            }
            
          	// 캐시 내부에 이미지가 없는 경우 네트워크 통신을 통해서 이미지를 받아온다
            NetworkManager.shared.loadImage(imageID: imageID) { result in
                switch result {
                case .success(let data):
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async { [weak self] in
                            // 캐시에 다운 받은 이미지를 저장
                            ImageCacheManager.shared.setObject(image, forKey: cacheKey)
                            self?.image = image
                        }
                    }
                case .failure:
                    self.image = UIImage()
                    return
                }
            }
        }
    }
    ```

<br>

### 테스트 가능하도록 코드 작성

#### [UIApplication.shared에 의존적인 코드를 Unit Test 가능할 수 있도록 수정]

- 문제 상황

  에러를 핸들링하는 과정에서 `사용자 위치 권한 반대` 에 대한 에러를 처리하는 로직이 제대로 작동하나 테스트 코드를 작성하려고 한다. 이때 `UITest` 형태로 진행하게 되면 시간이 오래 걸리고, UIApplication.shared에 의존적이며, App을 설정 창으로 전환시키는데 사용되는 URL을 검사할 수 있는 방법이 없기 때문에 test가 가능하도록 코드를 수정해야한다. 

  ```swift
  /* UIViewController+Error.swift 
  
  	사용자가 위치 권한을 반대하는 경우에는 
  	"위치 정보를 허용해야만 날씨 데이터를 받아올 수 있습니다.설정화면으로 이동할까요?" 
    메시지와 함께 Alert창이 뜨게되고 여기서 이동버튼을 누르면 설정 창으로 이동하는 코드 부분 */
  extension UIViewController { 
    //...
    //MARK: - LocationAuthorizationRequest fail
      private func showAuthorizationAlert(about error: WeatherError) {
          // ...
          let okAction = UIAlertAction(title: "이동", style: .default) { _ in
              self.openSetting()
          }
      }
      
      private func openSetting() {
          if let url = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(url)
          }
      }
  }
  ```

- 해결 방법

  ViewController로부터 해당 로직과 동작을 캡슐화하면서 분리하기 위해서 `SettingOpener` 클래스 생성하고, `URLOpening` 프로토콜을 생성하여 기존의 UIApplication의 `open()` 메소드와 동일한 함수를 가지도록 한다. 이때 `SettingOpener` 클래스 **init() 함수에서 `uRLOpener` 과 `openSettingsURLString` 을 매개변수로 전달할 수 있도록 하여, mockURLOpener와 App을 설정 창으로 전환시키는데 사용되는 URL을 사용자가 임의의 input으로 줄 수 있도록 구현하여 테스트가 가능한 코드로 수정**하였다. 그리고 **매개변수의 default 값을 설정하여 기존의 코드는 변경하지 않아도 정상적으로 작동**할 수 있도록 하였다.  

  ```swift
  protocol URLOpening {
      func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?)
  }
  extension UIApplication: URLOpening { }
  
  final class SettingOpener {
      private var openSettingsURLString: String
      private let urlOpener: URLOpening
      
      init(urlOpener: URLOpening = UIApplication.shared, openSettingsURLString: String = UIApplication.openSettingsURLString) {
          self.urlOpener = urlOpener
          self.openSettingsURLString = openSettingsURLString
      }
      
      func open() {
          if let url = URL(string: self.openSettingsURLString) {
              urlOpener.open(url, options: [:], completionHandler: nil)
          }
      }
  }
  
  /* test code */
  final class MockURLOpener: URLOpening {
          var opendURL: URL?
          
          func open(_ url: URL, options: [UIApplication.OpenExternalURLOptionsKey : Any], completionHandler completion: ((Bool) -> Void)?) {
              opendURL = url
          }
  }
  
  final class SettingOpenerTests: XCTestCase {
      var urlOpener: MockURLOpener!
      
      override func setUpWithError() throws {
          urlOpener = MockURLOpener()
      }
      
      func testSettingOpenerWhenItOpenedSetting() {
          let settingOpener = SettingOpener(urlOpener: urlOpener)
          settingOpener.open()
          
          XCTAssertEqual(urlOpener.opendURL, URL(string: "app-settings:"))
      }
  }
  ```

<br>

## 관련 학습 내용

### MVC Design pattern

UIKit app의 구조는 MVC 디자인 패턴을 기반으로 되어있다. <br>

MVC는  `Model, View, Controller` 를 의미하며 각각의 객체는 목적에 따라서 구분된다. 

#### 역할

- `Model` 객체 : app의 데이터와 비지니스 로직을 관리 
- `View` 객체 : 데이터를 보여주거나 UI를 담당
- `Controller` 객체 : Model 과 View 사이의 다리 역할을 하며 View로부터 사용자의 action을 받아 Model에게 어떠한 작업을 해야하는지 알려주거나, Model의 변화를 View에게 전달하여 업데이트하게 중재

#### 소통 방법

- View → Controller
Controller는 **View에서 발생할 수 있는 action에 대해 target을 생성**한다. 그리고 View에서 사용자에 의해서 action이 발생하면 Controller의 target이 이를 감지하고 작업을 수행한다. 또한 **View는 delegate pattern의 delegate와 datasource를 이용해 Controller에게 어떤 작업을 수행해야하는지** 알릴 수도 있다. 예로 UITableView의 UITableViewDelegate, UITableViewDatasource가 있다.

- Model → Controller
Model은 Observer pattern의 **Notification과 KVO(Key Value Observation)을 통해서** Controller에게 알려준다. 이에 Notification과 KVO는 일을 수행하는 객체가 진행하던 작업이 끝나면 자신들을 구독 중인 객체들에게 신호를 보낸다. 즉, Model에서 작업이 완료되었을 때, Controller에게 신호를 보내게 된다. 

#### 장점

- 다른 패턴에 비해서 코드량이 적음 
- 모두에게 친숙하기 때문에 직접 코드를 작성하지 않은 개발자도 쉽게 유지보수 할 수 있음
- 역할 분담을 고려한 구조를 빠르게 구현 할 수 있음 

#### 단점

- Massive view controller가 작성됨
- Model을 제외하고 View와 Controller는 Unit Test를 수행하기 어렵움

[👉🏻 MVC 패턴에 대한 학습 블로그로 가기](https://jryoun1.github.io/design%20pattern/MVCDesignPattern/)

<br>

### CLLocationManger, CLLocationManagerDelegate

Core Location은 Framework로 **기기의 지리적인 location이나 orientation을 획득하는데 사용**한다. <br>

`CLLocationManager ` 클래스 객체를 활용하여 Core Location 서비스를 구성하고, 시작하고 중지할 수 있다. CLLocationManager  **객체의 메서드를 사용하기 전에 반드시 delegate 객체를 설정해야한다.** <br>

`CLLocationMangerDelegate` 는 **location manager객체로부터 이벤트를 받을 때 사용하는 메서드**들이다. location manager는 이 delegate의 메서드들을 앱의 location 관련된 이벤트들을 보고할 때 사용하게 된다. 따라서 **앱의 특정 객체에 이 프로토콜을 구현하고 메서드들을 사용해서 앱을 업데이트 할 수 있다.** <br>

앱에서 요청할 수 있는 권한 (아래 말고도 선택되지 않거나, 거절의 경우도 존재)

- **When In Use** : app이 사용되고 있는 동안에 location service와 이벤트들을 받을 수 있다.
  일반적으로 iOS 앱들은 **foreground** 나 **background에서 위치 사용 표시가 활성화 된 상태**로 사용되고 있다면 `in use` 상태에 있다고 한다.
- **Always** : 사용자가 app이 실행되는지 몰라도 location service와 이벤트들을 받을 수 있다.
  만약 **app이 실행되지 않았어도 시스템이 앱을 실행시켜 event를 전달**해준다.

>  모든 경우에 대해서 거절 혹은 실패에 대해서도 핸들링을 할 수 있어야한다. 

##### ❗️Info.plist

Property List Key에 `NSLocationWhenInUseUsageDescription`, `NSLocationAlwaysAndWhenInUseUsageDescription` 에
**왜 앱이 사용자의 위치 정보에 접근해야하는지 원인**을 작성해 주어야한다. 해당 문구를 정확히 작성하여 어떠한 이유로 데이터를 수집하는지 사용자에게 알려주어야한다. 

만약 **foreground에서만 사용자의 위치에 접근하는 경우**에는`NSLocationWhenInUseUsageDescription` 만 작성해주면 된다. 앱이 **background에서도 사용자의 위치에 접근해야하는 경우**에는`NSLocationAlwaysAndWhenInUseUsageDescription` 를 작성해주면 된다.

[👉🏻 CLLocation에 대한 학습 블로그로 가기](https://jryoun1.github.io/swift/CoreLocation/)

##### ⚠️ CLGeocoder

CLLocationManager를 사용해서 기기의 위도와 경도를 찾으면 이를 주소로 바꿔주는 방법은 Apple에서 제공하는 CLGeocoder를 사용하면 된다. `CLGeocoder` 는 위도와 경도를 우리가 친숙한 지역의 이름으로 변경해주거나, 반대로 친숙한 지역의 이름을 위도와 경도로 변경할 수 있다. <br>
이때 ` reverseGeocodeLocation(_:completionHandler:)` 함수를 사용해 CLLocation을 변환할 수 있다. 

[👉🏻 Apple document  CLGeocoder 사용 방법](https://developer.apple.com/documentation/corelocation/converting_between_coordinates_and_user-friendly_place_names)

<br>

### URL Loading System

> 표준 Internet protocols를 사용해서 URL과 상호작용하고 서버와 통신하는 시스템

#### URLSession

> URL로 request를 전송하거나 받는 업무들을 조직화놓은 객체

- `URLSessionConfiguration` : URSession의 행동과 정책을 정의해주는 설정 객체
  - `default`
  - `ephemeral` : 디스크에 캐시나 쿠키 기록 X
  - `background` : app이 돌아가지 않는 background에서 upload와 download 수행
- `URLSessionTask` : URLSession에서 수행하는 작업으로 URLSession 인스턴스는 하나 이상의 URLSessionTask 객체를 생성하여 사용
  - `URLSessionDataTask` : GET request를 통해서 데이터를 받아오는 일
  - `URLSessionUploadTask` : POST/PUT request를 통해 파일을 업로드 하는 일
  - `URLSessionDownloadTask` : 서버로부터 파일이나 데이터를 다운받아오는 일
  - `URLSessionStreamTask` : 호스트나 포트 또는 네트워크 서비스 객체에서 TCP/IP 연결해주는 일
- Task의 상태
  - `suspended` : task가 생성될 때 초기 상태
  - `active`
  - `canceled`
  - `completed` 
- 데이터를 반환하는 방법 (비동기적 작업이므로, 작업이 끝남을 알려주는 방법)
  - `completionHandler` 를 사용하는 `dataTask(with:)` 메소드를 사용하는 방법
  - `delegate` 의 메소드를 사용하는 방법
    - `urlSession(_:dataTask:didReceive:completionHandler:)` : HTTP status codedㅘ mime 타입 검증
    - `urlSession(_:dataTask:didReceive:)` : data 객체들을 receivedData 버퍼에 저장
    - `urlSession(_:task:didCompleteWithError:)` : 전송 수준의 에러 확인 



#### URLSession을 사용해서 data가져오기

```swift
func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask

// 실제 사용방법 
   let task = URLSession.shared.dataTask(with: url) { data, response, error in 
        // 전송 에러가 있는지 검사
        if let _ = error { return }
                                                     
        // 상태 코드가 200~299사이에 있는 성공과 관련된 코드인지 확인
        guard let httpResponse = response as? HTTPURLRespionse,
             (200...299).contains(httpResponse.statusCode) else { return }
                                                     
        // 결과 타입이 기대한 타입과 같은지 체크하고 맞다면 
				// UI 관련된 작업은 dispatchQueue.main에서 실행
        if let mimeType = httpResponse.mimeTpye, mimeType == "text/html",
           let data = data, let string = String(data: data, encoding: .utf8) {
                DispatchQueue.main.sync {
                     self.webView.loadHTMLString(string, baseURL: url)
                }
           }                                       
     }
     task.resume()
}
```

- `URLSession.shared` : singleton URLSession 인스턴스로 간단한 request를 할 때 사용
- `data` : bytes(성공) or nil(에러 발생)
- `response` : response의 구현체, HTTPURLResponse로 타입 캐스팅 가능 
- `error` : 값(에러 발생) or nil(성공)
- `task.resume()` : suspend 상태의 task를 실행시킴

[👉🏻 URLSession에 대해서 공부한 블로그 가기](https://jryoun1.github.io/swift/URLSession/)

<br>

### GCD (Grand Central Dispatch)

> 멀티 코어와 멀티 프로세싱 환경에서 최적화된 프로그래밍을 할 수 있도록 Apple이 개발한 기술

비동기 처리를 할 때, main queue 말고도 background queue로 작업을 보내고 싶을 때 사용한다. <br>

<table>
    <thead>
        <tr>
            <th>큐의 종류</th>
            <th>생성 코드</th>
            <th>특징</th>
          	<th>직렬/동시</th>
        </tr>
    </thead>
    <tbody>
        <tr>
          	<td>.main</td>
            <td>DispatchQueue.main</td>
          	<td>메인 큐 = 메인쓰레드<br> (UI업데이트 내용 처리하는 큐)</td>
          	<td>Serial(직렬)</td>
        </tr>
        <tr>
            <td>.global</td>
            <td>DispatchQueue.global(qos:)</td>
          	<td>6가지 Qos<br>(작업에 따라 Qos설정 가능)</td>
          	<td>Concurrent(동시)</td>
        </tr>
        <tr>
            <td>custom<br>프라이빗</td>
            <td>DispatchQueue(label:"")</td>
          	<td>Qos 추론 / Qos 설정가능</td>
          	<td>디폴트: Serial(직렬)<br> attribute로 동시도 설정 가능</td>
        </tr>
    </tbody>
</table>

비동기적으로 처리할 때 **UI와 관련된 코드는 반드시 `DispatchQueue.main` 안에서 수행**되어야한다. <br>
반면 **네트워킹과 같은 작업들은 메인쓰레드가 아닌 backgorund queue인 global에서 실행되는 것을 권장**한다. <br>

<br>

### Cache

> 데이터나 값을 미리 복사해 놓는 임시 장소를 가리킨다. 

iOS에서는 메모리 캐시와 디스크 캐시 2가지 종류의 캐시를 사용한다. <br>

#### Memory Cache

- iOS에서 자체적으로 제공해주는 캐시
- App을 끄면 캐시에 저장된 내용이 사라짐
- **NSCache**를 통해 사용 가능
- 처리속도가 빠르지만 저장 공간이 작다

#### Disk Cache

- 캐시에 저장할 데이터를 기기 내부에 아카이빙 하는 방식으로 App을 껐다가 켜도 데이터가 사라지지 않고 남아있다
- **FileManager**를 통해 사용 가능
- App을 삭제할 때 캐시에 저장된 데이터를 삭제하게 만들수도 있고, 그렇지 않고 계속 남아있게 만들수도 있다
  - **UserDefault**를 사용하여 간단하게 저장하면, App 삭제시 데이터도 같이 삭제됨
  - **파일 경로에 이미지를 저장**하면, App이 삭제되어도 캐시가 남아있게 됨 (보통 파일 경로에 이미지 저장)
- 저장 공간은 상대적으로 크지만, 파일 입출력으로 인해 처리 속도가 메모리 캐시보다는 느리다 <br>
  (그러나 네트워크 통신을 통해서 다운로드 하는 것 보다는 훨씬 빠름)
- 예시로 카카오톡에서 이미지나 동영상을 디바이스에 저장하지 않고 눈으로 보기 위해 다운 받은 경우, Disk caching 되어 앱을 종료했다가 다시 실행해도 볼 수 있게 된다

#### NSCache

리소스가 부족하면 삭제될 수도 있는 임시 key, value 쌍을 일시적으로 저장하는 가변 콜렉션이다. <br>

```swift
class NSCache<KeyType, ObjectType> : NSObject where KeyType : AnyObject, ObjectType : AnyObject
```

NSCache는 주로 **생성하는데 비용이 많이 드는 임시 데이터를 저장하는데 사용**된다. 재생성하거나, 다시 계산할 필요가 없으므로 **성능상의 이점**을 가져갈 수 있다. **그러나 메모리가 부족한 경우에는 언제든지 삭제**될 수 있고, 삭제되면 필요할 때 다시 생성하거나 계산되어야한다

#### Memory Cache 사용 순서

1. key와 value 타입을 정해서 NSCache<KeyType, ObjectType> 를 선언
2. 이미지를 가져오기 전에 캐싱된 데이터에 해당 이미지가 있는지 검사
   - 있다면 이미지를 사용
   - 없다면 3번으로 이동
3. 네트워크 통신을 하여 비동기처리로 이미지를 가져와서 사용
4. 선언한 캐시에 새롭게 가져온 이미지를 저장

[👉🏻 캐시에 대한 학습 블로그 가기](https://jryoun1.github.io/swift/Cache/) <br>

<br>

### escaping closure 와 Result Type

#### escaping closure

`Escaping closure` 는 클로저가 함수의 인자로 전달됐을 때, 함수의 실행이 종료된 후에 실행되는 클로저이다. <br>

날씨 데이터와 이미지를 다운받기 위한 네트워크 처리할 때 사용한 `dataTask()` 메서드의 경우에도 `@escaping` 키워드를 가지고 있다. <br>

```swift
open func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
```

클로저가 함수로부터 **escape**한다는 것은 해당 함수의 인자로 클로저가 전달되지만, **함수가 반환된 후 실행되는 것**을 의미한다. 클로저의 escaping은 **A 함수가 마무리 된 상태에서만 B 함수가 실행되도록 함수를 작성할 수 있다는 점**에서 유용하다. 즉, escaping closure를 활용하면 함수 사이에 실행 순서를 정할 수 있다. <br>

따라서 `dataTask()` 메소드에서도 서버와의 작업이 끝마친 뒤에 `(Data?, URLResponse?, Error?) -> Void ` 클로저가 실행되는 것이다. <br>

[👉🏻 escaping closure에 대한 학습 블로그 가기](https://jryoun1.github.io/swift/escapingClosure/)

#### Result Type

`Result Type` 은 Enum 타입이며 성공이나 실패에 대한 값인데, 각각의 케이스에 대한 연관된 값을 표현한다고 한다. 

```swift
@frozen public enum Result<Success, Failure> where Failure : Error {
    // 성공인 경우에는 성공 타입의 데이터를 가짐
    case success(Success)
    // 실패인 경우에는 Error 프로토콜을 따르는 에러 타입을 가짐
    case failure(Failure)
}
```

`Result Type` 을 사용해서 비동기 작업에서의 에러를 핸들링할 수 있다.  
