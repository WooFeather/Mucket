//
//  NetworkError.swift
//  Mucket
//
//  Created by 조우현 on 4/3/25.
//

import Foundation

enum NetworkError: Error {
    // 기본 에러
    case invalidURLError
    case networkError(Error)
    case invalidResponse
    case encodingError

    // API 응답 에러 (에러 코드 기반)
    case noDataError // ERROR-300
    case invalidParameterTypeError // ERROR-301
    case serviceNotFoundError // ERROR-310
    case startIndexNotFoundError // ERROR-331
    case endIndexNotFoundError // ERROR-332
    case tooManyRequestsError // ERROR-334
    case dataLimitExceededError // ERROR-336
    case serverError // ERROR-500
    case sqlError // ERROR-601
    case infoNoData // INFO-100
    case infoDataExists // INFO-200
    case infoDataUpdated // INFO-300
    case infoNoPermission // INFO-400

    var localizedDescription: String {
        switch self {
        case .invalidURLError:
            return "잘못된 URL입니다."
        case .networkError(let error):
            return "네트워크 오류: \(error.localizedDescription)"
        case .invalidResponse:
            return "잘못된 응답입니다."
        case .encodingError:
            return "데이터 디코딩에 실패했습니다."
        case .noDataError:
            return "필수 값이 누락되었습니다. 요청값을 참고하세요."
        case .invalidParameterTypeError:
            return "파라미터 값이 누락 혹은 유효하지 않습니다. 요청인자 중 TYPE을 확인하세요."
        case .serviceNotFoundError:
            return "해당하는 서비스를 찾을 수 없습니다. 요청인자 중 SERVICE를 확인하세요."
        case .startIndexNotFoundError:
            return "요청시작위치 값을 확인하세요. 요청인자 중 START_INDEX를 확인하세요."
        case .endIndexNotFoundError:
            return "요청종료위치 값을 확인하세요. 요청인자 중 END_INDEX를 확인하세요."
        case .tooManyRequestsError:
            return "종료위치보다 시작위치가 더 큽니다. 요청시작종료건수는 정수를 입력하세요."
        case .dataLimitExceededError:
            return "데이터로딩은 한번에 최대 1000건을 넘을 수 없습니다."
        case .serverError:
            return "서버 오류입니다."
        case .sqlError:
            return "SQL 문의 오류입니다."
        case .infoNoData:
            return "인증키가 유효하지 않습니다. 인증키가 없는 경우, 홈페이지에서 인증키를 신청하세요."
        case .infoDataExists:
            return "해당하는 데이터가 없습니다."
        case .infoDataUpdated:
            return "유효 호출건수를 이미 초과하였습니다."
        case .infoNoPermission:
            return "권한이 없습니다. 관리자에게 문의하세요."
        }
    }
}
