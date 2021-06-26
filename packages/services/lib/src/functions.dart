import 'package:flutter/material.dart';
import 'package:flutter/services.dart' as S;
import 'package:get/get.dart';
import 'package:x_flutter/x_flutter.dart';

/// Get.arguments 함수를 간단하게 쓰도록 도와주는 함수
///
/// 예제) String a = getArg('a', 'apple'); // a 값이 없으면 apple 이 지정된다. 기본 값은 null.
dynamic getArg(String name, [dynamic defaultValue]) {
  return Get.arguments == null || Get.arguments[name] == null ? defaultValue : Get.arguments[name];
}

// 알림창을 띄운다
//
// 알림창은 예/아니오의 선택이 없다. 그래서 리턴값이 필요없다.
Future<void> alert(String title, String content) async {
  return showDialog(
    context: Get.context!,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [TextButton(onPressed: () => Get.back(result: true), child: Text('확인'))],
    ),
  );
}

/// 에러 핸들링
///
/// 모든 종류의 에러를 다 핸들링한다.
/// 따라서, 이 함수를 호출하기 전에 미리 에러가 어떤 종류의 에러인지 전처리할 필요 없이, 그냥 이 함수에 에러를 전달하면 된다.
error(e) {
  print('service.dart > 에러 발생: $e');
  if (e is String) {
    // 사진 업로드에서, 사용자가 사진을 선택하지 않은 경우, 에러 표시하지 않음.
    if (e == IMAGE_NOT_SELECTED) {
    } else {
      alert('에러', e);
    }
  } else if (e is S.PlatformException) {
    /// 사용자가 취소를 한 경우, 에러 표시 하지 않음.
    ///
    /// 사진 업로드 등에서, 여러 차례 취소를 한 경우.
    if (e.code == 'multiple_request') {
    } else {
      alert('에러', "${e.code}: ${e.message!}");
    }
  } else if (e.message != null && e.message is String) {
    alert('Assertion 에러 발생', e.message);
  } else {
    alert('에러', e);
  }
}

/// 국가 코드 2 자리를 입력하면, 통화 코드(3자리 영문)와 한글로 된 국가 이름과, 통화명 리턴한다.
Map<String, String> countryCurrency(String countryCode) {
  const List<Map<String, String>> names = [
    {"koreanName": "아프가니스탄", "alpha2": "AF", "currencyCode": "AFN", "currencyKoreanName": ""},
    {"koreanName": "알바니아", "alpha2": "AL", "currencyCode": "ALL", "currencyKoreanName": "렉"},
    {"koreanName": "남극", "alpha2": "AQ", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "알제리", "alpha2": "DZ", "currencyCode": "DZD", "currencyKoreanName": "디나르"},
    {"koreanName": "아메리칸사모아", "alpha2": "AS", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "안도라", "alpha2": "AD", "currencyCode": "EUR", "currencyKoreanName": "유로"},
    {"koreanName": "앙골라", "alpha2": "AO", "currencyCode": "AOA", "currencyKoreanName": ""},
    {"koreanName": "앤티가 바부다", "alpha2": "AG", "currencyCode": "XCD", "currencyKoreanName": "달러"},
    {"koreanName": "아제르바이잔", "alpha2": "AZ", "currencyCode": "AZN", "currencyKoreanName": ""},
    {"koreanName": "아르헨티나", "alpha2": "AR", "currencyCode": "ARS", "currencyKoreanName": "페소"},
    {"koreanName": "오스트레일리아", "alpha2": "AU", "currencyCode": "AUD", "currencyKoreanName": "달러"},
    {"koreanName": "오스트리아", "alpha2": "AT", "currencyCode": "EUR", "currencyKoreanName": "유로"},
    {"koreanName": "바하마", "alpha2": "BS", "currencyCode": "BSD", "currencyKoreanName": "달러"},
    {"koreanName": "바레인", "alpha2": "BH", "currencyCode": "BHD", "currencyKoreanName": "디나르"},
    {"koreanName": "방글라데시", "alpha2": "BD", "currencyCode": "BDT", "currencyKoreanName": "타카"},
    {"koreanName": "아르메니아", "alpha2": "AM", "currencyCode": "AMD", "currencyKoreanName": ""},
    {"koreanName": "바베이도스", "alpha2": "BB", "currencyCode": "BBD", "currencyKoreanName": "달러"},
    {"koreanName": "벨기에", "alpha2": "BE", "currencyCode": "EUR", "currencyKoreanName": "유로"},
    {"koreanName": "버뮤다", "alpha2": "BM", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "부탄", "alpha2": "BT", "currencyCode": "BTN", "currencyKoreanName": "눌트럼"},
    {"koreanName": "볼리비아", "alpha2": "BO", "currencyCode": "BOB", "currencyKoreanName": "볼리비아노"},
    {"koreanName": "보스니아 헤르체고비나", "alpha2": "BA", "currencyCode": "BAM", "currencyKoreanName": ""},
    {"koreanName": "보츠와나", "alpha2": "BW", "currencyCode": "BWP", "currencyKoreanName": "풀라"},
    {"koreanName": "부베 섬", "alpha2": "BV", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "브라질", "alpha2": "BR", "currencyCode": "BRL", "currencyKoreanName": "레알"},
    {"koreanName": "벨리즈", "alpha2": "BZ", "currencyCode": "BZD", "currencyKoreanName": "달러"},
    {"koreanName": "영국령 인도양 지역", "alpha2": "IO", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "솔로몬 제도", "alpha2": "SB", "currencyCode": "SBD", "currencyKoreanName": "달러"},
    {"koreanName": "영국령 버진아일랜드", "alpha2": "VG", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "브루나이", "alpha2": "BN", "currencyCode": "BND", "currencyKoreanName": "달러"},
    {"koreanName": "불가리아", "alpha2": "BG", "currencyCode": "BGN", "currencyKoreanName": "레프"},
    {"koreanName": "미얀마", "alpha2": "MM", "currencyCode": "MMK", "currencyKoreanName": "차트"},
    {"koreanName": "부룬디", "alpha2": "BI", "currencyCode": "BIF", "currencyKoreanName": "프랑"},
    {"koreanName": "벨라루스", "alpha2": "BY", "currencyCode": "BYN", "currencyKoreanName": ""},
    {"koreanName": "캄보디아", "alpha2": "KH", "currencyCode": "KHR", "currencyKoreanName": "리엘"},
    {"koreanName": "카메룬", "alpha2": "CM", "currencyCode": "XAF", "currencyKoreanName": "(BEAC)"},
    {"koreanName": "캐나다", "alpha2": "CA", "currencyCode": "CAD", "currencyKoreanName": "달러"},
    {"koreanName": "카보베르데", "alpha2": "CV", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "케이맨 제도", "alpha2": "KY", "currencyCode": "KYD", "currencyKoreanName": "달러"},
    {
      "koreanName": "중앙아프리카 공화국",
      "alpha2": "CF",
      "currencyCode": "XAF",
      "currencyKoreanName": "(BEAC)"
    },
    {"koreanName": "스리랑카", "alpha2": "LK", "currencyCode": "LKR", "currencyKoreanName": "루피"},
    {"koreanName": "차드", "alpha2": "TD", "currencyCode": "XAF", "currencyKoreanName": "(BEAC)"},
    {"koreanName": "칠레", "alpha2": "CL", "currencyCode": "CLP", "currencyKoreanName": "페소"},
    {"koreanName": "중화인민공화국", "alpha2": "CN", "currencyCode": "CNY", "currencyKoreanName": "위안"},
    {"koreanName": "중화민국", "alpha2": "TW", "currencyCode": "TWD", "currencyKoreanName": "달러"},
    {"koreanName": "크리스마스 섬", "alpha2": "CX", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "코코스 제도", "alpha2": "CC", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "콜롬비아", "alpha2": "CO", "currencyCode": "COP", "currencyKoreanName": "페소"},
    {"koreanName": "코모로", "alpha2": "KM", "currencyCode": "KMF", "currencyKoreanName": "프랑"},
    {"koreanName": "마요트", "alpha2": "YT", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "콩고 공화국", "alpha2": "CG", "currencyCode": "XAF", "currencyKoreanName": "(BEAC)"},
    {"koreanName": "콩고 민주 공화국", "alpha2": "CD", "currencyCode": "CDF", "currencyKoreanName": ""},
    {"koreanName": "쿡 제도", "alpha2": "CK", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "코스타리카", "alpha2": "CR", "currencyCode": "CRC", "currencyKoreanName": "콜론"},
    {"koreanName": "크로아티아", "alpha2": "HR", "currencyCode": "HRK", "currencyKoreanName": "쿠나"},
    {"koreanName": "쿠바", "alpha2": "CU", "currencyCode": "CUP", "currencyKoreanName": "페소"},
    {"koreanName": "키프로스", "alpha2": "CY", "currencyCode": "EUR", "currencyKoreanName": "유로"},
    {"koreanName": "체코", "alpha2": "CZ", "currencyCode": "CZK", "currencyKoreanName": "코루나"},
    {"koreanName": "베냉", "alpha2": "BJ", "currencyCode": "XOF", "currencyKoreanName": "(BCEAO)"},
    {"koreanName": "덴마크", "alpha2": "DK", "currencyCode": "DKK", "currencyKoreanName": "크로네"},
    {"koreanName": "도미니카 연방", "alpha2": "DM", "currencyCode": "XCD", "currencyKoreanName": "달러"},
    {"koreanName": "도미니카 공화국", "alpha2": "DO", "currencyCode": "DOP", "currencyKoreanName": "페소"},
    {"koreanName": "에콰도르", "alpha2": "EC", "currencyCode": "USD", "currencyKoreanName": "달러"},
    {"koreanName": "엘살바도르", "alpha2": "SV", "currencyCode": "USD", "currencyKoreanName": "달러"},
    {"koreanName": "적도 기니", "alpha2": "GQ", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "에티오피아", "alpha2": "ET", "currencyCode": "ETB", "currencyKoreanName": "비르"},
    {"koreanName": "에리트레아", "alpha2": "ER", "currencyCode": "ERN", "currencyKoreanName": ""},
    {"koreanName": "에스토니아", "alpha2": "EE", "currencyCode": "EUR", "currencyKoreanName": "유로"},
    {"koreanName": "페로 제도", "alpha2": "FO", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "포클랜드 제도", "alpha2": "FK", "currencyCode": "", "currencyKoreanName": ""},
    {
      "koreanName": "사우스조지아 사우스샌드위치 제도",
      "alpha2": "GS",
      "currencyCode": "",
      "currencyKoreanName": ""
    },
    {"koreanName": "피지", "alpha2": "FJ", "currencyCode": "FJD", "currencyKoreanName": "달러"},
    {"koreanName": "핀란드", "alpha2": "FI", "currencyCode": "EUR", "currencyKoreanName": "유로"},
    {"koreanName": "올란드 제도", "alpha2": "AX", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "프랑스", "alpha2": "FR", "currencyCode": "EUR", "currencyKoreanName": "유로"},
    {"koreanName": "프랑스령 기아나", "alpha2": "GF", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "프랑스령 폴리네시아", "alpha2": "PF", "currencyCode": "XPF", "currencyKoreanName": "프랑"},
    {"koreanName": "프랑스령 남부와 남극 지역", "alpha2": "TF", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "지부티", "alpha2": "DJ", "currencyCode": "DJF", "currencyKoreanName": "프랑"},
    {"koreanName": "가봉", "alpha2": "GA", "currencyCode": "XAF", "currencyKoreanName": "(BEAC)"},
    {"koreanName": "조지아", "alpha2": "GE", "currencyCode": "GEL", "currencyKoreanName": ""},
    {"koreanName": "감비아", "alpha2": "GM", "currencyCode": "GMD", "currencyKoreanName": "달라시"},
    {"koreanName": "팔레스타인", "alpha2": "PS", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "독일", "alpha2": "DE", "currencyCode": "EUR", "currencyKoreanName": "유로"},
    {"koreanName": "가나", "alpha2": "GH", "currencyCode": "GHS", "currencyKoreanName": "세디"},
    {"koreanName": "지브롤터", "alpha2": "GI", "currencyCode": "GIP", "currencyKoreanName": ""},
    {"koreanName": "키리바시", "alpha2": "KI", "currencyCode": "AUD", "currencyKoreanName": "달러"},
    {"koreanName": "그리스", "alpha2": "GR", "currencyCode": "EUR", "currencyKoreanName": "유로"},
    {"koreanName": "그린란드", "alpha2": "GL", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "그레나다", "alpha2": "GD", "currencyCode": "XCD", "currencyKoreanName": "달러"},
    {"koreanName": "과들루프", "alpha2": "GP", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "괌", "alpha2": "GU", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "과테말라", "alpha2": "GT", "currencyCode": "GTQ", "currencyKoreanName": "퀘찰"},
    {"koreanName": "기니", "alpha2": "GN", "currencyCode": "GNF", "currencyKoreanName": "프랑"},
    {"koreanName": "가이아나", "alpha2": "GY", "currencyCode": "GYD", "currencyKoreanName": "달러"},
    {"koreanName": "아이티", "alpha2": "HT", "currencyCode": "HTG", "currencyKoreanName": "구르드"},
    {"koreanName": "허드 맥도널드 제도", "alpha2": "HM", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "바티칸 시국", "alpha2": "VA", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "온두라스", "alpha2": "HN", "currencyCode": "HNL", "currencyKoreanName": "렘피라"},
    {"koreanName": "홍콩", "alpha2": "HK", "currencyCode": "HKD", "currencyKoreanName": "달러"},
    {"koreanName": "헝가리", "alpha2": "HU", "currencyCode": "HUF", "currencyKoreanName": "포린트"},
    {"koreanName": "아이슬란드", "alpha2": "IS", "currencyCode": "ISK", "currencyKoreanName": "크로네"},
    {"koreanName": "인도", "alpha2": "IN", "currencyCode": "INR", "currencyKoreanName": "루피"},
    {"koreanName": "인도네시아", "alpha2": "ID", "currencyCode": "IDR", "currencyKoreanName": "루피아"},
    {"koreanName": "이란", "alpha2": "IR", "currencyCode": "IRR", "currencyKoreanName": "리알"},
    {"koreanName": "이라크", "alpha2": "IQ", "currencyCode": "IQD", "currencyKoreanName": "디나르"},
    {"koreanName": "아일랜드", "alpha2": "IE", "currencyCode": "EUR", "currencyKoreanName": "유로"},
    {"koreanName": "이스라엘", "alpha2": "IL", "currencyCode": "ILS", "currencyKoreanName": "셰켈"},
    {"koreanName": "이탈리아", "alpha2": "IT", "currencyCode": "EUR", "currencyKoreanName": "유로"},
    {
      "koreanName": "코트디부아르",
      "alpha2": "CI",
      "currencyCode": "XOF",
      "currencyKoreanName": "(BCEAO)"
    },
    {"koreanName": "자메이카", "alpha2": "JM", "currencyCode": "JMD", "currencyKoreanName": ""},
    {"koreanName": "일본", "alpha2": "JP", "currencyCode": "JPY", "currencyKoreanName": "엔"},
    {"koreanName": "카자흐스탄", "alpha2": "KZ", "currencyCode": "KZT", "currencyKoreanName": "텡게"},
    {"koreanName": "요르단", "alpha2": "JO", "currencyCode": "JOD", "currencyKoreanName": "디나르"},
    {"koreanName": "케냐", "alpha2": "KE", "currencyCode": "KES", "currencyKoreanName": "실링"},
    {"koreanName": "조선민주주의인민공화국", "alpha2": "KP", "currencyCode": "KPW", "currencyKoreanName": "원"},
    {"koreanName": "대한민국", "alpha2": "KR", "currencyCode": "KRW", "currencyKoreanName": "원"},
    {"koreanName": "쿠웨이트", "alpha2": "KW", "currencyCode": "KWD", "currencyKoreanName": "디나르"},
    {"koreanName": "키르기스스탄", "alpha2": "KG", "currencyCode": "KGS", "currencyKoreanName": "솜"},
    {"koreanName": "라오스", "alpha2": "LA", "currencyCode": "LAK", "currencyKoreanName": ""},
    {"koreanName": "레바논", "alpha2": "LB", "currencyCode": "LBP", "currencyKoreanName": ""},
    {"koreanName": "레소토", "alpha2": "LS", "currencyCode": "LSL", "currencyKoreanName": ""},
    {"koreanName": "라트비아", "alpha2": "LV", "currencyCode": "LVL", "currencyKoreanName": ""},
    {"koreanName": "라이베리아", "alpha2": "LR", "currencyCode": "LRD", "currencyKoreanName": ""},
    {"koreanName": "리비아", "alpha2": "LY", "currencyCode": "LYD", "currencyKoreanName": ""},
    {"koreanName": "리히텐슈타인", "alpha2": "LI", "currencyCode": "CHF", "currencyKoreanName": "프랑"},
    {"koreanName": "리투아니아", "alpha2": "LT", "currencyCode": "EUR", "currencyKoreanName": "유로"},
    {"koreanName": "룩셈부르크", "alpha2": "LU", "currencyCode": "EUR", "currencyKoreanName": "유로"},
    {"koreanName": "마카오", "alpha2": "MO", "currencyCode": "MOP", "currencyKoreanName": "파타카"},
    {"koreanName": "마다가스카르", "alpha2": "MG", "currencyCode": "MGA", "currencyKoreanName": ""},
    {"koreanName": "말라위", "alpha2": "MW", "currencyCode": "MWK", "currencyKoreanName": "콰차"},
    {"koreanName": "말레이시아", "alpha2": "MY", "currencyCode": "MYR", "currencyKoreanName": "링깃"},
    {"koreanName": "몰디브", "alpha2": "MV", "currencyCode": "MVR", "currencyKoreanName": "루피야"},
    {"koreanName": "말리", "alpha2": "ML", "currencyCode": "XOF", "currencyKoreanName": "(BCEAO)"},
    {"koreanName": "몰타", "alpha2": "MT", "currencyCode": "EUR", "currencyKoreanName": "유로"},
    {"koreanName": "마르티니크", "alpha2": "MQ", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "모리타니", "alpha2": "MR", "currencyCode": "MRO", "currencyKoreanName": "우기야"},
    {"koreanName": "모리셔스", "alpha2": "MU", "currencyCode": "MUR", "currencyKoreanName": "루피"},
    {"koreanName": "멕시코", "alpha2": "MX", "currencyCode": "MXN", "currencyKoreanName": "페소"},
    {"koreanName": "모나코", "alpha2": "MC", "currencyCode": "EUR", "currencyKoreanName": "유로"},
    {"koreanName": "몽골", "alpha2": "MN", "currencyCode": "MNT", "currencyKoreanName": "투그릭"},
    {"koreanName": "몰도바", "alpha2": "MD", "currencyCode": "MDL", "currencyKoreanName": "레우"},
    {"koreanName": "몬테네그로", "alpha2": "ME", "currencyCode": "EUR", "currencyKoreanName": "유로"},
    {"koreanName": "몬트세랫", "alpha2": "MS", "currencyCode": "XCD", "currencyKoreanName": "달러"},
    {"koreanName": "모로코", "alpha2": "MA", "currencyCode": "MAD", "currencyKoreanName": "디르함"},
    {"koreanName": "모잠비크", "alpha2": "MZ", "currencyCode": "MZN", "currencyKoreanName": ""},
    {"koreanName": "오만", "alpha2": "OM", "currencyCode": "OMR", "currencyKoreanName": "리알"},
    {"koreanName": "나미비아", "alpha2": "NA", "currencyCode": "NAD", "currencyKoreanName": "달러"},
    {"koreanName": "나우루", "alpha2": "NR", "currencyCode": "AUD", "currencyKoreanName": "달러"},
    {"koreanName": "네팔", "alpha2": "NP", "currencyCode": "NPR", "currencyKoreanName": "루피"},
    {"koreanName": "네덜란드", "alpha2": "NL", "currencyCode": "EUR", "currencyKoreanName": "유로"},
    {"koreanName": "네덜란드령 안틸레스", "alpha2": "AN", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "아루바", "alpha2": "AW", "currencyCode": "AWG", "currencyKoreanName": "플로린"},
    {"koreanName": "누벨칼레도니", "alpha2": "NC", "currencyCode": "XPF", "currencyKoreanName": "프랑"},
    {"koreanName": "바누아투", "alpha2": "VU", "currencyCode": "VUV", "currencyKoreanName": "바투"},
    {"koreanName": "뉴질랜드", "alpha2": "NZ", "currencyCode": "NZD", "currencyKoreanName": "달러"},
    {"koreanName": "니카라과", "alpha2": "NI", "currencyCode": "NIO", "currencyKoreanName": "코르도바"},
    {"koreanName": "니제르", "alpha2": "NE", "currencyCode": "XOF", "currencyKoreanName": "(BCEAO)"},
    {"koreanName": "나이지리아", "alpha2": "NG", "currencyCode": "NGN", "currencyKoreanName": "나이라"},
    {"koreanName": "니우에", "alpha2": "NU", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "노퍽 섬", "alpha2": "NF", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "노르웨이", "alpha2": "NO", "currencyCode": "NOK", "currencyKoreanName": "크로네"},
    {"koreanName": "북마리아나 제도", "alpha2": "MP", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "미국령 군소 제도", "alpha2": "UM", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "미크로네시아 연방", "alpha2": "FM", "currencyCode": "USD", "currencyKoreanName": "달러"},
    {"koreanName": "마셜 제도", "alpha2": "MH", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "팔라우", "alpha2": "PW", "currencyCode": "USD", "currencyKoreanName": "달러"},
    {"koreanName": "파키스탄", "alpha2": "PK", "currencyCode": "PKR", "currencyKoreanName": "루피"},
    {"koreanName": "파나마", "alpha2": "PA", "currencyCode": "PAB", "currencyKoreanName": "발보아"},
    {"koreanName": "파푸아 뉴기니", "alpha2": "PG", "currencyCode": "PGK", "currencyKoreanName": "키나"},
    {"koreanName": "파라과이", "alpha2": "PY", "currencyCode": "PYG", "currencyKoreanName": "과라니"},
    {"koreanName": "페루", "alpha2": "PE", "currencyCode": "PEN", "currencyKoreanName": "누에보솔"},
    {"koreanName": "필리핀", "alpha2": "PH", "currencyCode": "PHP", "currencyKoreanName": "페소"},
    {"koreanName": "핏케언 제도", "alpha2": "PN", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "폴란드", "alpha2": "PL", "currencyCode": "PLN", "currencyKoreanName": "즈워티"},
    {"koreanName": "포르투갈", "alpha2": "PT", "currencyCode": "EUR", "currencyKoreanName": "유로"},
    {"koreanName": "기니비사우", "alpha2": "GW", "currencyCode": "XOF", "currencyKoreanName": "(BCEAO)"},
    {"koreanName": "동티모르", "alpha2": "TL", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "푸에르토리코", "alpha2": "PR", "currencyCode": "USD", "currencyKoreanName": "달러"},
    {"koreanName": "카타르", "alpha2": "QA", "currencyCode": "QAR", "currencyKoreanName": "리알"},
    {"koreanName": "레위니옹", "alpha2": "RE", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "루마니아", "alpha2": "RO", "currencyCode": "RON", "currencyKoreanName": "레우"},
    {"koreanName": "러시아", "alpha2": "RU", "currencyCode": "RUB", "currencyKoreanName": "루블"},
    {"koreanName": "르완다", "alpha2": "RW", "currencyCode": "RWF", "currencyKoreanName": "프랑"},
    {"koreanName": "세인트헬레나", "alpha2": "SH", "currencyCode": "SHP", "currencyKoreanName": "파운드"},
    {"koreanName": "세인트키츠 네비스", "alpha2": "KN", "currencyCode": "XCD", "currencyKoreanName": "달러"},
    {"koreanName": "앵귈라", "alpha2": "AI", "currencyCode": "XCD", "currencyKoreanName": "달러"},
    {"koreanName": "세인트루시아", "alpha2": "LC", "currencyCode": "XCD", "currencyKoreanName": "달러"},
    {"koreanName": "생피에르 미클롱", "alpha2": "PM", "currencyCode": "", "currencyKoreanName": ""},
    {
      "koreanName": "세인트빈센트 그레나딘",
      "alpha2": "VC",
      "currencyCode": "XCD",
      "currencyKoreanName": "달러"
    },
    {"koreanName": "산마리노", "alpha2": "SM", "currencyCode": "EUR", "currencyKoreanName": "유로"},
    {"koreanName": "상투메 프린시페", "alpha2": "ST", "currencyCode": "STD", "currencyKoreanName": "도브라"},
    {"koreanName": "사우디아라비아", "alpha2": "SA", "currencyCode": "SAR", "currencyKoreanName": "리얄"},
    {"koreanName": "세네갈", "alpha2": "SN", "currencyCode": "XOF", "currencyKoreanName": "(BCEAO)"},
    {"koreanName": "세르비아", "alpha2": "RS", "currencyCode": "RSD", "currencyKoreanName": ""},
    {"koreanName": "세이셸", "alpha2": "SC", "currencyCode": "SCR", "currencyKoreanName": "루피"},
    {"koreanName": "시에라리온", "alpha2": "SL", "currencyCode": "SLL", "currencyKoreanName": "레온"},
    {"koreanName": "싱가포르", "alpha2": "SG", "currencyCode": "SGD", "currencyKoreanName": "달러"},
    {"koreanName": "슬로바키아", "alpha2": "SK", "currencyCode": "EUR", "currencyKoreanName": "유로"},
    {"koreanName": "베트남", "alpha2": "VN", "currencyCode": "VND", "currencyKoreanName": "동"},
    {"koreanName": "슬로베니아", "alpha2": "SI", "currencyCode": "EUR", "currencyKoreanName": "유로"},
    {"koreanName": "소말리아", "alpha2": "SO", "currencyCode": "SOS", "currencyKoreanName": "실링"},
    {"koreanName": "남아프리카 공화국", "alpha2": "ZA", "currencyCode": "ZAR", "currencyKoreanName": "랜드"},
    {"koreanName": "짐바브웨", "alpha2": "ZW", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "스페인", "alpha2": "ES", "currencyCode": "EUR", "currencyKoreanName": "유로"},
    {"koreanName": "남수단", "alpha2": "SS", "currencyCode": "SDG", "currencyKoreanName": "파운드"},
    {"koreanName": "서사하라", "alpha2": "EH", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "수단", "alpha2": "SD", "currencyCode": "SDG", "currencyKoreanName": "파운드"},
    {"koreanName": "수리남", "alpha2": "SR", "currencyCode": "SRD", "currencyKoreanName": ""},
    {"koreanName": "스발바르 얀마옌", "alpha2": "SJ", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "스와질란드", "alpha2": "SZ", "currencyCode": "SZL", "currencyKoreanName": "릴랑게니"},
    {"koreanName": "스웨덴", "alpha2": "SE", "currencyCode": "SEK", "currencyKoreanName": "크로나"},
    {"koreanName": "스위스", "alpha2": "CH", "currencyCode": "CHF", "currencyKoreanName": "프랑"},
    {"koreanName": "시리아", "alpha2": "SY", "currencyCode": "SYP", "currencyKoreanName": "파운드"},
    {"koreanName": "타지키스탄", "alpha2": "TJ", "currencyCode": "TJS", "currencyKoreanName": ""},
    {"koreanName": "타이", "alpha2": "TH", "currencyCode": "THB", "currencyKoreanName": "바트"},
    {"koreanName": "토고", "alpha2": "TG", "currencyCode": "XOF", "currencyKoreanName": "(BCEAO)"},
    {"koreanName": "토켈라우", "alpha2": "TK", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "통가", "alpha2": "TO", "currencyCode": "TOP", "currencyKoreanName": "팡가"},
    {"koreanName": "트리니다드 토바고", "alpha2": "TT", "currencyCode": "TTD", "currencyKoreanName": "달러"},
    {"koreanName": "아랍에미리트", "alpha2": "AE", "currencyCode": "AED", "currencyKoreanName": "디르함"},
    {"koreanName": "튀니지", "alpha2": "TN", "currencyCode": "TND", "currencyKoreanName": "디나르"},
    {"koreanName": "터키", "alpha2": "TR", "currencyCode": "TRY", "currencyKoreanName": "리라"},
    {"koreanName": "투르크메니스탄", "alpha2": "TM", "currencyCode": "TMT", "currencyKoreanName": ""},
    {"koreanName": "터크스 케이커스 제도", "alpha2": "TC", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "투발루", "alpha2": "TV", "currencyCode": "AUD", "currencyKoreanName": "달러"},
    {"koreanName": "우간다", "alpha2": "UG", "currencyCode": "UGX", "currencyKoreanName": "실링"},
    {"koreanName": "우크라이나", "alpha2": "UA", "currencyCode": "UAH", "currencyKoreanName": "흐리브냐"},
    {"koreanName": "마케도니아 공화국", "alpha2": "MK", "currencyCode": "MKD", "currencyKoreanName": "디나르"},
    {"koreanName": "이집트", "alpha2": "EG", "currencyCode": "EGP", "currencyKoreanName": "파운드"},
    {"koreanName": "영국", "alpha2": "GB", "currencyCode": "GBP", "currencyKoreanName": "파운드"},
    {"koreanName": "건지 섬", "alpha2": "GG", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "저지 섬", "alpha2": "JE", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "맨 섬", "alpha2": "IM", "currencyCode": "", "currencyKoreanName": ""},
    {"koreanName": "탄자니아", "alpha2": "TZ", "currencyCode": "TZS", "currencyKoreanName": "실링"},
    {"koreanName": "미국", "alpha2": "US", "currencyCode": "USD", "currencyKoreanName": "달러"},
    {"koreanName": "미국령 버진아일랜드", "alpha2": "VI", "currencyCode": "", "currencyKoreanName": ""},
    {
      "koreanName": "부르키나파소",
      "alpha2": "BF",
      "currencyCode": "XOF",
      "currencyKoreanName": "(BCEAO)"
    },
    {"koreanName": "우루과이", "alpha2": "UY", "currencyCode": "UYU", "currencyKoreanName": "페소"},
    {"koreanName": "우즈베키스탄", "alpha2": "UZ", "currencyCode": "UZS", "currencyKoreanName": "솜"},
    {"koreanName": "베네수엘라", "alpha2": "VE", "currencyCode": "VEF", "currencyKoreanName": "후에르떼"},
    {"koreanName": "왈리스 퓌튀나", "alpha2": "WF", "currencyCode": "XPF", "currencyKoreanName": "프랑"},
    {"koreanName": "사모아", "alpha2": "WS", "currencyCode": "WST", "currencyKoreanName": "탈라"},
    {"koreanName": "예멘", "alpha2": "YE", "currencyCode": "YER", "currencyKoreanName": "리알"},
    {"koreanName": "잠비아", "alpha2": "ZM", "currencyCode": "ZMW", "currencyKoreanName": ""}
  ];
  countryCode = countryCode.toUpperCase();
  return names.firstWhere((e) => e['alpha2'] == countryCode,
      orElse: () => {"koreanName": "", "currencyKoreanName": ""});
}
