# 🍕 먹캣 Mucket

### 레시피, 요리 기록, 맛집을 한 곳에 담다.

![image](https://github.com/user-attachments/assets/67bbc902-3d4c-4232-add7-2034d337ae5f)

---

## 🐱 앱 소개

### 먹캣은 어떤 앱인가요?

나만의 요리 포켓, 먹캣!

오늘의 추천 요리부터 나만의 요리 기록, 그리고 나만 알고싶은 맛집까지!

이제 하나의 앱에서 모두 즐겨보세요!

---

## ⭐️ 주요 기능

### 레시피 검색

매일매일 새로운 요리를 추천해드려요.

사진, 재료, 만드는 법, 영양 정보까지 한눈에!

검색으로 원하는 요리도 손쉽게 찾을 수 있어요.

<img width="200" alt="Onboarding" src="https://github.com/user-attachments/assets/2d411c55-4029-4a2f-b649-ef3369ec0d31"> 
<img width="200" alt="Main" src="https://github.com/user-attachments/assets/1bb7d252-49a4-4b0e-bcaa-3135831652dc"> 
<img width="200" alt="Detail" src="https://github.com/user-attachments/assets/1c477b41-d0c7-4960-be00-eaf55be9d21c">
<img width="200" alt="Detail" src="https://github.com/user-attachments/assets/a3f5acbc-c762-4ecc-b95c-10906c429a5f">



### 내가 만든 요리 저장

내가 만든 요리를 사진과 함께 기록하고,

별점도 주고, 요리 중 떠오른 팁도 메모해보세요.

참고한 요리 영상도 앱에서 바로 재생 가능!

<img width="250" alt="Onboarding" src="https://github.com/user-attachments/assets/1b78f753-839a-44e9-99c8-4ef1df2e2fc4"> 
<img width="250" alt="Main" src="https://github.com/user-attachments/assets/4b39d536-61a2-47e5-b189-aafd100d2ba6"> 
<img width="250" alt="Detail" src="https://github.com/user-attachments/assets/d04b894a-c96a-4b2b-ae15-940872ec81f8">


### 나만의 맛집 저장

나만의 맛집을 쉽게 검색해서 저장할 수 있어요.

앱 안의 맛집 지도에서 나만의 장소를 저장해두세요!

<img width="250" alt="Onboarding" src="https://github.com/user-attachments/assets/101097ce-43ae-4b22-a12f-e353a7698d94"> 
<img width="250" alt="Main" src="https://github.com/user-attachments/assets/d6a28153-773c-4855-a58a-e280391369ab"> 
<img width="250" alt="Detail" src="https://github.com/user-attachments/assets/131cbc29-ad7d-43e1-a9a4-fb2385aa00e2">


---

# ⚙️ Project

## 🧑‍💻 개발 인원 및 기간

### 개발 인원

- 1인 개발
    - https://github.com/WooFeather

### 개발 기간

- 기획 및 디자인: 4일
    - 25/03/25 ~ 25/03/27
    
- 핵심 개발 기간(1차 릴리즈): 11일
    - 25/03/28 ~25/04/07
      
- 1.1.0 업데이트(지도기능 추가): 4일
    - 25/04/09 ~ 25/04/12
      
- 추가 업데이트(25/04/20일 기준 1.1.2 업데이트 완료): 진행중

## 💻 기술 스택

### 사용한 기술

- 아키텍쳐/디자인 패턴
    - MVVM
    - Repository
    - Router
    - DI 및 DIP
    - BaseViewController 및 BaseView
      
- 프레임워크
    - UIKit
    - SwiftUI
    - CoreLocation
      
- 라이브러리
    - ReactorKit
    - RxSwift
    - Realm
    - KakaoMapsSDK
    - YouTubePlayerKit
    - Snapkit
    - Toast
    - Cosmos

### 기술설명

- **ReactorKit을 사용한 비동기 처리**
    - ReactorKit을 통해 단방향 데이터 흐름 패턴 비동기 처리를 구현했습니다.
    - 비즈니스 로직은 Reactor안에서 일어나고, View는 State가 변경되었을때만 자동으로 업데이트 되기 때문에 뷰와 로직을 분리하고, 자연스럽게 비동기 처리를 할 수 있었습니다.
      
- **커스텀 이미지 캐싱**
    - 검색한 레시피의 사진들을 효율적으로 관리하기 위해서 이미지 캐싱 기능을 구현했습니다.
    - Kingfisher라이브러리를 사용하지 않고, NSCache를 이용해 DiskCache와 MemoryCache를 커스텀으로 구현함으로써 앱 내의 미지를 효율적으로 관리했습니다.
      
- **Swift Concurrency 기반 네트워크 처리**
    - URLSession과 async/await 패턴을 적용해 네트워크 비동기 코드를 작성했으며, NWPathMonitor를 통해 네트워크 단절 상황에 대응했습니다.
    - Router패턴과 Repository패턴을 적극 도입하여 서로 다른 API를 사용할때 코드의 중복을 줄이고, 유지보수를 용이하게 했습니다.
      
- **모델 계층 분리**
    - 네트워크 응답 모델과 Realm모델에 DTO - Entity - Repository 패턴을 적용해, 원본 데이터와 앱에서 사용하는 데이터를 분리하여 유지보수를 용이하게 했습니다.
    - 특히 네트워크 코드의 경우 프로토콜로 추상화를 해서 실제 네트워크 통신 이전에 MockData를 사용함으로써 유연성을 높였습니다.
      
- **Realm을 통한 데이터 저장**
    - 원본 Object와는 별개로 Entity를 만들어서, 데이터의 변경에 대해 유연하게 대응했으며, 테스트 용이서을 증대시켰습니다.
    - Realm의 DB Scheme이 달라진 경우 마이그레이션 작업을 통해 사용자의 불편함을 감소시켰습니다.

---

## 😈 트러블 슈팅

### 테이블 뷰 크기 동적 조절

- 문제 상황
    - 레시피 상세정보를 보여주는 뷰는 스크롤뷰 안에 ‘요리 과정’이 테이블뷰로 표시되는 형태로 구성되어있습니다.
    - 요리 과정은 각 레시피별로 다르기 때문에 테이블뷰의 높이를 동적으로 조정해야 하는 상황이었습니다.
    - 다음과 같은 코드로 테이블뷰의 높이를 동적으로 조정하는 코드를 작성했습니다.
    
    ```swift
    // RecipeDetailView
    
    // ...
    
    makingTableView.snp.makeConstraints { make in
        make.top.equalTo(makingHeaderLabel.snp.bottom).offset(12)
        make.leading.trailing.equalToSuperview()
        make.height.equalTo(800)
        make.bottom.equalToSuperview().offset(-32)
    }
    ```
    
    ```swift
    // RecipeDetailViewController
    
    // ...
    
    // 셀 구성 끝난 직후
    private func updateTableViewHeight() {
        recipeDetailView.makingTableView.reloadData()
        
        DispatchQueue.main.async {
            self.recipeDetailView.makingTableView.layoutIfNeeded()
            let height = self.recipeDetailView.makingTableView.contentSize.height
    
            self.recipeDetailView.makingTableView.snp.updateConstraints {
                $0.height.equalTo(height)
            }
        }
    }
    ```
    
    - 이렇게 할 경우 특정 셀 이후로 여전히 잘리는 현상이 발생했습니다.
- 해결 시도
    - TableView의 높이를 동적으로 조정하기엔 한계가 있다고 판단했습니다.
    - TableView의 높이를 고정해놓고, 해당 TableView가 스크롤이 가능하게 해서, 모든 높이에 대응하도록 했습니다.
    - 다만, 이렇게 했을 경우 ScrollView 안에 또 다른 Scroll이 되는 뷰가 생기면서 사용자가 스크롤 하는 영역에 있어서 혼란을 겪을 수 있다고 판단했습니다.
- 해결
    - TableView를 사용하는 것이 아니라 StackView를 사용하는 것으로 수정했습니다.
    - 네트워크 응답값을 받아올 때, ‘요리 과정’ 데이터를 stackView에 addArrangedSubview 해줌으로써 ’요리 과정’ 개수에 따라 뷰를 동적으로 구성할 수 있었습니다.
    
    ```swift
    // RecipeDetailView
    
    //...
    
    makingStackView.snp.makeConstraints { make in
        make.top.equalTo(makingHeaderLabel.snp.bottom).offset(12)
        make.horizontalEdges.equalToSuperview()
        make.bottom.equalToSuperview()
    }
    ```
    
    ```swift
    // RecipeDetailViewController
    
    // ...
    
    reactor.state
        .map { $0.manualSteps }
        .distinctUntilChanged()
        .bind(with: self) { owner, steps in
            // 기존 뷰들 제거
            owner.recipeDetailView.makingStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    
            for step in steps {
    		        // Cell 대신에 커스텀뷰 생성
                let view = DetailStepView()
                view.configure(step: step)
                // makingStackView.addArrangedSubview(view)를 통해 stackView에 데이터 추가
                owner.recipeDetailView.makingStackView.addArrangedSubview(view)
            }
        }
        .disposed(by: disposeBag)
    ```
    

### HTTP 응답

- 문제 상황
    - 공공데이터의 특성상 서버로부터 HTTPS가 아닌 HTTP 기반의 이미지 URL의 응답을 받게 되었습니다.
    - ATS 정책상 해당 URL의 이미지를 표시할 수 없었습니다.
    
    ```swift
    // 콘솔에 뜬 에러 메세지
    
    Task <81481162-E1B5-48CF-9F00-125451601174>.<26> finished with error [-1022] Error Domain=NSURLErrorDomain Code=-1022 "The resource could not be loaded because the App Transport Security policy requires the use of a secure connection." UserInfo={NSLocalizedDescription=The resource could not be loaded because the App Transport Security policy requires the use of a secure connection., NSErrorFailingURLStringKey=http://www.foodsafetykorea.go.kr/uploadimg/cook/10_00671_2.png, NSErrorFailingURLKey=http://www.foodsafetykorea.go.kr/uploadimg/cook/10_00671_2.png, _NSURLErrorRelatedURLSessionTaskErrorKey=(
        "LocalDataTask <81481162-E1B5-48CF-9F00-125451601174>.<26>"
    ), _NSURLErrorFailingURLSessionTaskErrorKey=LocalDataTask <81481162-E1B5-48CF-9F00-125451601174>.<26>, NSUnderlyingError=0x600000c6e340 {Error Domain=kCFErrorDomainCFNetwork Code=-1022 "(null)"}}
    ```
    
- 해결 시도
    - Info.plist에서 예외 URL을 설정해주었습니다.
    
    ![image](https://github.com/user-attachments/assets/446057ea-f830-46d0-b85f-3d358865fa3f)

    
    - 하지만, 이렇게 설정해주어도 여전히 같은 문제가 발생했습니다.
- 해결
    - 다음과 같은 extension을 만들어, URL을 받아올 때 HTTP를 HTTPS로 바꿔주는 동작을 만들어 적용했습니다.
    
    ```swift
    extension String {
        func toHTTPS() -> String {
            self.replacingOccurrences(of: "http://", with: "https://")
        }
    }
    ```
    
    ```swift
    // 사용 예시
    
    func configureData(entity: RecipeEntity) {
        if let url = entity.imageURL {
            let imageURL = URL(string: url.toHTTPS())
            Task {
                do {
                    let image = try await ImageCacheManager.shared.load(url: imageURL, saveOption: .onlyMemory)
                    thumbImageView.image = image
                } catch {
                    print("이미지 로드 실패")
                    thumbImageView.image = .placeholderSmall
                }
            }
        } else {
            thumbImageView.image = .placeholderSmall
        }
    }
    ```
    

### 서버의 요청 파라미터 변경 대응

- 문제 상황
    - 메인 화면에서 테마요리를 fetch해오는 기능에 DecodingError가 발생했습니다.
    
    ```swift
    ❌ Decode error: keyNotFound(CodingKeys(stringValue: "row", intValue: nil), Swift.DecodingError.Context(codingPath: [CodingKeys(stringValue: "COOKRCP01", intValue: nil)], debugDescription: "No value associated with key CodingKeys(stringValue: \"row\", intValue: nil) (\"row\").", underlyingError: nil))
    ❌ Response JSON:
     {"COOKRCP01":{"total_count":"0","RESULT":{"MSG":"SQL 문장 오류입니다.","CODE":"ERROR-601"}}}
    테마리스트 로딩 실패 decodingError
    ```
    
    - 에러 메세지를 확인해보니 SQL 문장의 오류로 row라는 값이 오지 않는것을 알 수 있었습니다.
    - 다른 네트워크 통신 코드의 경우 문제가 없었으며, Router의 구성을 보면 `RCP_PAT2=\(type)` 파라미터에 문제가 있다고 추측했습니다.
    
    ```swift
    // RecipeRouter
    
    // ...
    
    var path: String {
        switch self {
        case .fetchAll:
            return "/\(apiKey)/COOKRCP01/json/1/1000"
        case .searchRecipe(let startIndex, let count, let name):
            return "/\(apiKey)/COOKRCP01/json/\(startIndex)/\(count)/RCP_NM=\(name)"
        case .fetchThemedRecipe(let type):
            return "/\(apiKey)/COOKRCP01/json/1/1000/RCP_PAT2=\(type)"
        }
    }
    ```
    
    - Insomnia에서 확인해보니 역시 다른 파라미터에는 문제가 없었으며, `RCP_PAT2` 파라미터를 사용했을때 문제가 발생함을 알 수 있었습니다.
- 해결 시도
    - 해당 API 제공처의 공지사항을 확인해보고, 관련 내용에 대해 문의글을 남겼습니다.
- 해결
    - API 제공처로부터 답변이 오기 전까지 클라이언트 단에서 필터링을 적용했습니다.
    - 일단 fetchAll을 통해 모든 데이터를 불러온 이후에, 응답값에서 `RCP_PAT2` 에 따라서 필터링을 해주었습니다.
    
    ```swift
    // 기존 코드
    private func fetchThemeList(type: String) -> Observable<[RecipeEntity]> {
        return Observable.create { [weak self] observer in
            Task {
                do {
    		            // fetchTheme을 통해 RCP_PAT2 파라미터를 통해 네트워크 통신
    								let theme = try await self?.repository.fetchTheme(type: type) ?? []
                    observer.onNext(Array(theme.shuffled().prefix(10)))
                    observer.onCompleted()
                } catch {
                    print("테마리스트 로딩 실패", error)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        .retry(1)
    
    ```
    
    ```swift
    // 수정 코드
    private func fetchThemeList(type: String) -> Observable<[RecipeEntity]> {
        return Observable.create { [weak self] observer in
            Task {
                do {
                    let all = try await self?.repository.fetchAll() ?? []
                    let theme = all.filter { $0.type?.contains(type) ?? true }
                    observer.onNext(Array(theme.shuffled().prefix(10)))
                    observer.onCompleted()
                } catch {
                    print("테마리스트 로딩 실패", error)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
        .retry(1)
    }
    ```
    

---

## 📓 프로젝트 회고

### 리펙토링 및 추가 기능개발 계획

- ReactorKit 코드로 구현되지 않은 부분 리펙토링
- 이미지 캐싱 정책 적용
- 다국어 대응
- 재료 검색 및 지도에서 필터링 기능 등 기타 추가기능 개발
