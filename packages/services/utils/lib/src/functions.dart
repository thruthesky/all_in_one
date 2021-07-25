import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
// import 'package:x_flutter/x_flutter.dart';

/// Get.arguments 함수를 간단하게 쓰도록 도와주는 함수
///
/// 예제) String a = getArg('a', 'apple'); // a 값이 없으면 apple 이 지정된다. 기본 값은 null.
dynamic getArg(String name, [dynamic defaultValue]) {
  return Get.arguments == null || Get.arguments[name] == null ? defaultValue : Get.arguments[name];
}

Future<bool> confirm(String title, String content) async {
  final re = await showDialog<bool>(
    context: Get.context!,
    builder: (context) {
      return AlertDialog(
        content: Text('선택한 파일을 삭제하시겠습니까?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: true),
            child: Text('예'),
          ),
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text('아니오'),
          )
        ],
      );
    },
  );
  if (re == true) {
    return true;
  } else {
    return false;
  }
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
    if (e == 'error_image_not_selected') {
    } else {
      alert('에러', e);
    }
  } else if (e is PlatformException) {
    /// 사용자가 취소를 한 경우, 에러 표시 하지 않음.
    ///
    /// 사진 업로드 등에서, 여러 차례 취소를 한 경우.
    if (e.code == 'multiple_request') {
    } else {
      alert('에러', "${e.code}: ${e.message!}");
    }
  } else if (e.runtimeType.toString() == '_TypeError') {
    final errstr = e.toString();
    if (errstr.contains('Future') && errstr.contains('is not a subtype of type')) {
      alert(
          'Await 실수', '개발자 실수입니다.\n\nFuture 에서 async 를 한 다음, await 을 하지 않았습니다.\n\n' + e.toString());
    } else {
      alert('개발자 코딩 실수', '타입 에러: ' + e.toString());
    }
  } else if (e.runtimeType.toString() == "NoSuchMethodError") {
    if (e.toString().contains("Closure call with mismatched arguments")) {
      alert('개발자 실수', '클로져 함수가 받아들이는 인자 개 수와 호출 함수의 파라미터 개 수가 다릅니다.\n\n$e');
    } else {
      alert('개발자 실수', "NoSuchMethodError; $e");
    }
  } else if (e?.message != null) {
    if (e.message is String) {
      alert('Assertion 에러 발생', e.message);
    }
  } else {
    alert('에러', e);
  }
}

class CurrencyModel {
  late String koreanName;
  late String alpha2;
  late String alpha3;
  late String currencyCode;
  late String currencyKoreanName;
  late String currencySymbol;
  CurrencyModel(Map<String, String> json) {
    koreanName = json['koreanName']!;
    alpha2 = json['alpha2']!;
    alpha3 = json['alpha3']!;
    currencyCode = json['currencyCode']!;
    currencyKoreanName = json['currencyKoreanName']!;
    currencySymbol = json['currencySymbol']!;
  }
}

/// 국가 코드 2 자리를 입력하면, 통화 코드(3자리 영문)와 한글로 된 국가 이름과, 통화명 리턴한다.
CurrencyModel countryCurrency(String countryCode) {
  const List<Map<String, String>> names = [
    {
      "koreanName": "아프가니스탄",
      "alpha2": "AF",
      "alpha3": "AFG",
      "currencyCode": "AFN",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "알바니아",
      "alpha2": "AL",
      "alpha3": "ALB",
      "currencyCode": "ALL",
      "currencyKoreanName": "렉",
      "currencySymbol": "L"
    },
    {
      "koreanName": "남극",
      "alpha2": "AQ",
      "alpha3": "ATA",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "알제리",
      "alpha2": "DZ",
      "alpha3": "DZA",
      "currencyCode": "DZD",
      "currencyKoreanName": "디나르",
      "currencySymbol": "دج"
    },
    {
      "koreanName": "아메리칸사모아",
      "alpha2": "AS",
      "alpha3": "ASM",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "안도라",
      "alpha2": "AD",
      "alpha3": "AND",
      "currencyCode": "EUR",
      "currencyKoreanName": "유로",
      "currencySymbol": "€"
    },
    {
      "koreanName": "앙골라",
      "alpha2": "AO",
      "alpha3": "AGO",
      "currencyCode": "AOA",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "앤티가 바부다",
      "alpha2": "AG",
      "alpha3": "ATG",
      "currencyCode": "XCD",
      "currencyKoreanName": "달러",
      "currencySymbol": "EC\$"
    },
    {
      "koreanName": "아제르바이잔",
      "alpha2": "AZ",
      "alpha3": "AZE",
      "currencyCode": "AZN",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "아르헨티나",
      "alpha2": "AR",
      "alpha3": "ARG",
      "currencyCode": "ARS",
      "currencyKoreanName": "페소",
      "currencySymbol": "\$"
    },
    {
      "koreanName": "오스트레일리아",
      "alpha2": "AU",
      "alpha3": "AUS",
      "currencyCode": "AUD",
      "currencyKoreanName": "달러",
      "currencySymbol": "\$"
    },
    {
      "koreanName": "오스트리아",
      "alpha2": "AT",
      "alpha3": "AUT",
      "currencyCode": "EUR",
      "currencyKoreanName": "유로",
      "currencySymbol": "€"
    },
    {
      "koreanName": "바하마",
      "alpha2": "BS",
      "alpha3": "BHS",
      "currencyCode": "BSD",
      "currencyKoreanName": "달러",
      "currencySymbol": "B\$"
    },
    {
      "koreanName": "바레인",
      "alpha2": "BH",
      "alpha3": "BHR",
      "currencyCode": "BHD",
      "currencyKoreanName": "디나르",
      "currencySymbol": ".د.ب"
    },
    {
      "koreanName": "방글라데시",
      "alpha2": "BD",
      "alpha3": "BGD",
      "currencyCode": "BDT",
      "currencyKoreanName": "타카",
      "currencySymbol": "Tk"
    },
    {
      "koreanName": "아르메니아",
      "alpha2": "AM",
      "alpha3": "ARM",
      "currencyCode": "AMD",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "바베이도스",
      "alpha2": "BB",
      "alpha3": "BRB",
      "currencyCode": "BBD",
      "currencyKoreanName": "달러",
      "currencySymbol": "BBD"
    },
    {
      "koreanName": "벨기에",
      "alpha2": "BE",
      "alpha3": "BEL",
      "currencyCode": "EUR",
      "currencyKoreanName": "유로",
      "currencySymbol": "€"
    },
    {
      "koreanName": "버뮤다",
      "alpha2": "BM",
      "alpha3": "BMU",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "부탄",
      "alpha2": "BT",
      "alpha3": "BTN",
      "currencyCode": "BTN",
      "currencyKoreanName": "눌트럼",
      "currencySymbol": "Nu."
    },
    {
      "koreanName": "볼리비아",
      "alpha2": "BO",
      "alpha3": "BOL",
      "currencyCode": "BOB",
      "currencyKoreanName": "볼리비아노",
      "currencySymbol": "Bs"
    },
    {
      "koreanName": "보스니아 헤르체고비나",
      "alpha2": "BA",
      "alpha3": "BIH",
      "currencyCode": "BAM",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "보츠와나",
      "alpha2": "BW",
      "alpha3": "BWA",
      "currencyCode": "BWP",
      "currencyKoreanName": "풀라",
      "currencySymbol": "P"
    },
    {
      "koreanName": "부베 섬",
      "alpha2": "BV",
      "alpha3": "BVT",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "브라질",
      "alpha2": "BR",
      "alpha3": "BRA",
      "currencyCode": "BRL",
      "currencyKoreanName": "레알",
      "currencySymbol": "R\$"
    },
    {
      "koreanName": "벨리즈",
      "alpha2": "BZ",
      "alpha3": "BLZ",
      "currencyCode": "BZD",
      "currencyKoreanName": "달러",
      "currencySymbol": "BZ\$"
    },
    {
      "koreanName": "영국령 인도양 지역",
      "alpha2": "IO",
      "alpha3": "IOT",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "솔로몬 제도",
      "alpha2": "SB",
      "alpha3": "SLB",
      "currencyCode": "SBD",
      "currencyKoreanName": "달러",
      "currencySymbol": "SI\$"
    },
    {
      "koreanName": "영국령 버진아일랜드",
      "alpha2": "VG",
      "alpha3": "VGB",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "브루나이",
      "alpha2": "BN",
      "alpha3": "BRN",
      "currencyCode": "BND",
      "currencyKoreanName": "달러",
      "currencySymbol": "B\$"
    },
    {
      "koreanName": "불가리아",
      "alpha2": "BG",
      "alpha3": "BGR",
      "currencyCode": "BGN",
      "currencyKoreanName": "레프",
      "currencySymbol": "лв"
    },
    {
      "koreanName": "미얀마",
      "alpha2": "MM",
      "alpha3": "MMR",
      "currencyCode": "MMK",
      "currencyKoreanName": "차트",
      "currencySymbol": "K"
    },
    {
      "koreanName": "부룬디",
      "alpha2": "BI",
      "alpha3": "BDI",
      "currencyCode": "BIF",
      "currencyKoreanName": "프랑",
      "currencySymbol": "FBu"
    },
    {
      "koreanName": "벨라루스",
      "alpha2": "BY",
      "alpha3": "BLR",
      "currencyCode": "BYN",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "캄보디아",
      "alpha2": "KH",
      "alpha3": "KHM",
      "currencyCode": "KHR",
      "currencyKoreanName": "리엘",
      "currencySymbol": "KHR"
    },
    {
      "koreanName": "카메룬",
      "alpha2": "CM",
      "alpha3": "CMR",
      "currencyCode": "XAF",
      "currencyKoreanName": "(BEAC)",
      "currencySymbol": "BEAC"
    },
    {
      "koreanName": "캐나다",
      "alpha2": "CA",
      "alpha3": "CAN",
      "currencyCode": "CAD",
      "currencyKoreanName": "달러",
      "currencySymbol": "C\$"
    },
    {
      "koreanName": "카보베르데",
      "alpha2": "CV",
      "alpha3": "CPV",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "케이맨 제도",
      "alpha2": "KY",
      "alpha3": "CYM",
      "currencyCode": "KYD",
      "currencyKoreanName": "달러",
      "currencySymbol": "\$"
    },
    {
      "koreanName": "중앙아프리카 공화국",
      "alpha2": "CF",
      "alpha3": "CAF",
      "currencyCode": "XAF",
      "currencyKoreanName": "(BEAC)",
      "currencySymbol": "BEAC"
    },
    {
      "koreanName": "스리랑카",
      "alpha2": "LK",
      "alpha3": "LKA",
      "currencyCode": "LKR",
      "currencyKoreanName": "루피",
      "currencySymbol": "ரூ"
    },
    {
      "koreanName": "차드",
      "alpha2": "TD",
      "alpha3": "TCD",
      "currencyCode": "XAF",
      "currencyKoreanName": "(BEAC)",
      "currencySymbol": "BEAC"
    },
    {
      "koreanName": "칠레",
      "alpha2": "CL",
      "alpha3": "CHL",
      "currencyCode": "CLP",
      "currencyKoreanName": "페소",
      "currencySymbol": "\$"
    },
    {
      "koreanName": "중화인민공화국",
      "alpha2": "CN",
      "alpha3": "CHN",
      "currencyCode": "CNY",
      "currencyKoreanName": "위안",
      "currencySymbol": "¥"
    },
    {
      "koreanName": "중화민국",
      "alpha2": "TW",
      "alpha3": "TWN",
      "currencyCode": "TWD",
      "currencyKoreanName": "달러",
      "currencySymbol": "NT\$"
    },
    {
      "koreanName": "크리스마스 섬",
      "alpha2": "CX",
      "alpha3": "CXR",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "코코스 제도",
      "alpha2": "CC",
      "alpha3": "CCK",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "콜롬비아",
      "alpha2": "CO",
      "alpha3": "COL",
      "currencyCode": "COP",
      "currencyKoreanName": "페소",
      "currencySymbol": "\$"
    },
    {
      "koreanName": "코모로",
      "alpha2": "KM",
      "alpha3": "COM",
      "currencyCode": "KMF",
      "currencyKoreanName": "프랑",
      "currencySymbol": "KMF"
    },
    {
      "koreanName": "마요트",
      "alpha2": "YT",
      "alpha3": "MYT",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "콩고 공화국",
      "alpha2": "CG",
      "alpha3": "COG",
      "currencyCode": "XAF",
      "currencyKoreanName": "(BEAC)",
      "currencySymbol": "BEAC"
    },
    {
      "koreanName": "콩고 민주 공화국",
      "alpha2": "CD",
      "alpha3": "COD",
      "currencyCode": "CDF",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "쿡 제도",
      "alpha2": "CK",
      "alpha3": "COK",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "코스타리카",
      "alpha2": "CR",
      "alpha3": "CRI",
      "currencyCode": "CRC",
      "currencyKoreanName": "콜론",
      "currencySymbol": "₡"
    },
    {
      "koreanName": "크로아티아",
      "alpha2": "HR",
      "alpha3": "HRV",
      "currencyCode": "HRK",
      "currencyKoreanName": "쿠나",
      "currencySymbol": "kn"
    },
    {
      "koreanName": "쿠바",
      "alpha2": "CU",
      "alpha3": "CUB",
      "currencyCode": "CUP",
      "currencyKoreanName": "페소",
      "currencySymbol": "\$MN"
    },
    {
      "koreanName": "키프로스",
      "alpha2": "CY",
      "alpha3": "CYP",
      "currencyCode": "EUR",
      "currencyKoreanName": "유로",
      "currencySymbol": "€"
    },
    {
      "koreanName": "체코",
      "alpha2": "CZ",
      "alpha3": "CZE",
      "currencyCode": "CZK",
      "currencyKoreanName": "코루나",
      "currencySymbol": "Kč"
    },
    {
      "koreanName": "베냉",
      "alpha2": "BJ",
      "alpha3": "BEN",
      "currencyCode": "XOF",
      "currencyKoreanName": "(BCEAO)",
      "currencySymbol": "BCEAO"
    },
    {
      "koreanName": "덴마크",
      "alpha2": "DK",
      "alpha3": "DNK",
      "currencyCode": "DKK",
      "currencyKoreanName": "크로네",
      "currencySymbol": "kr"
    },
    {
      "koreanName": "도미니카 연방",
      "alpha2": "DM",
      "alpha3": "DMA",
      "currencyCode": "XCD",
      "currencyKoreanName": "달러",
      "currencySymbol": "EC\$"
    },
    {
      "koreanName": "도미니카 공화국",
      "alpha2": "DO",
      "alpha3": "DOM",
      "currencyCode": "DOP",
      "currencyKoreanName": "페소",
      "currencySymbol": "RD\$"
    },
    {
      "koreanName": "에콰도르",
      "alpha2": "EC",
      "alpha3": "ECU",
      "currencyCode": "USD",
      "currencyKoreanName": "달러",
      "currencySymbol": "\$"
    },
    {
      "koreanName": "엘살바도르",
      "alpha2": "SV",
      "alpha3": "SLV",
      "currencyCode": "USD",
      "currencyKoreanName": "달러",
      "currencySymbol": "\$"
    },
    {
      "koreanName": "적도 기니",
      "alpha2": "GQ",
      "alpha3": "GNQ",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "에티오피아",
      "alpha2": "ET",
      "alpha3": "ETH",
      "currencyCode": "ETB",
      "currencyKoreanName": "비르",
      "currencySymbol": "Br"
    },
    {
      "koreanName": "에리트레아",
      "alpha2": "ER",
      "alpha3": "ERI",
      "currencyCode": "ERN",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "에스토니아",
      "alpha2": "EE",
      "alpha3": "EST",
      "currencyCode": "EUR",
      "currencyKoreanName": "유로",
      "currencySymbol": "€"
    },
    {
      "koreanName": "페로 제도",
      "alpha2": "FO",
      "alpha3": "FRO",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "포클랜드 제도",
      "alpha2": "FK",
      "alpha3": "FLK",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "사우스조지아 사우스샌드위치 제도",
      "alpha2": "GS",
      "alpha3": "SGS",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "피지",
      "alpha2": "FJ",
      "alpha3": "FJI",
      "currencyCode": "FJD",
      "currencyKoreanName": "달러",
      "currencySymbol": "FJ\$"
    },
    {
      "koreanName": "핀란드",
      "alpha2": "FI",
      "alpha3": "FIN",
      "currencyCode": "EUR",
      "currencyKoreanName": "유로",
      "currencySymbol": "€"
    },
    {
      "koreanName": "올란드 제도",
      "alpha2": "AX",
      "alpha3": "ALA",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "프랑스",
      "alpha2": "FR",
      "alpha3": "FRA",
      "currencyCode": "EUR",
      "currencyKoreanName": "유로",
      "currencySymbol": "€"
    },
    {
      "koreanName": "프랑스령 기아나",
      "alpha2": "GF",
      "alpha3": "GUF",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "프랑스령 폴리네시아",
      "alpha2": "PF",
      "alpha3": "PYF",
      "currencyCode": "XPF",
      "currencyKoreanName": "프랑",
      "currencySymbol": "F"
    },
    {
      "koreanName": "프랑스령 남부와 남극 지역",
      "alpha2": "TF",
      "alpha3": "ATF",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "지부티",
      "alpha2": "DJ",
      "alpha3": "DJI",
      "currencyCode": "DJF",
      "currencyKoreanName": "프랑",
      "currencySymbol": "Fdj"
    },
    {
      "koreanName": "가봉",
      "alpha2": "GA",
      "alpha3": "GAB",
      "currencyCode": "XAF",
      "currencyKoreanName": "(BEAC)",
      "currencySymbol": "BEAC"
    },
    {
      "koreanName": "조지아",
      "alpha2": "GE",
      "alpha3": "GEO",
      "currencyCode": "GEL",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "감비아",
      "alpha2": "GM",
      "alpha3": "GMB",
      "currencyCode": "GMD",
      "currencyKoreanName": "달라시",
      "currencySymbol": "D"
    },
    {
      "koreanName": "팔레스타인",
      "alpha2": "PS",
      "alpha3": "PSE",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "독일",
      "alpha2": "DE",
      "alpha3": "DEU",
      "currencyCode": "EUR",
      "currencyKoreanName": "유로",
      "currencySymbol": "€"
    },
    {
      "koreanName": "가나",
      "alpha2": "GH",
      "alpha3": "GHA",
      "currencyCode": "GHS",
      "currencyKoreanName": "세디",
      "currencySymbol": "GHS"
    },
    {
      "koreanName": "지브롤터",
      "alpha2": "GI",
      "alpha3": "GIB",
      "currencyCode": "GIP",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "키리바시",
      "alpha2": "KI",
      "alpha3": "KIR",
      "currencyCode": "AUD",
      "currencyKoreanName": "달러",
      "currencySymbol": "\$"
    },
    {
      "koreanName": "그리스",
      "alpha2": "GR",
      "alpha3": "GRC",
      "currencyCode": "EUR",
      "currencyKoreanName": "유로",
      "currencySymbol": "€"
    },
    {
      "koreanName": "그린란드",
      "alpha2": "GL",
      "alpha3": "GRL",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "그레나다",
      "alpha2": "GD",
      "alpha3": "GRD",
      "currencyCode": "XCD",
      "currencyKoreanName": "달러",
      "currencySymbol": "EC\$"
    },
    {
      "koreanName": "과들루프",
      "alpha2": "GP",
      "alpha3": "GLP",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "괌",
      "alpha2": "GU",
      "alpha3": "GUM",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "과테말라",
      "alpha2": "GT",
      "alpha3": "GTM",
      "currencyCode": "GTQ",
      "currencyKoreanName": "퀘찰",
      "currencySymbol": "Q"
    },
    {
      "koreanName": "기니",
      "alpha2": "GN",
      "alpha3": "GIN",
      "currencyCode": "GNF",
      "currencyKoreanName": "프랑",
      "currencySymbol": "FG"
    },
    {
      "koreanName": "가이아나",
      "alpha2": "GY",
      "alpha3": "GUY",
      "currencyCode": "GYD",
      "currencyKoreanName": "달러",
      "currencySymbol": "GY\$"
    },
    {
      "koreanName": "아이티",
      "alpha2": "HT",
      "alpha3": "HTI",
      "currencyCode": "HTG",
      "currencyKoreanName": "구르드",
      "currencySymbol": ""
    },
    {
      "koreanName": "허드 맥도널드 제도",
      "alpha2": "HM",
      "alpha3": "HMD",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "바티칸 시국",
      "alpha2": "VA",
      "alpha3": "VAT",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "온두라스",
      "alpha2": "HN",
      "alpha3": "HND",
      "currencyCode": "HNL",
      "currencyKoreanName": "렘피라",
      "currencySymbol": "L"
    },
    {
      "koreanName": "홍콩",
      "alpha2": "HK",
      "alpha3": "HKG",
      "currencyCode": "HKD",
      "currencyKoreanName": "달러",
      "currencySymbol": "HK\$"
    },
    {
      "koreanName": "헝가리",
      "alpha2": "HU",
      "alpha3": "HUN",
      "currencyCode": "HUF",
      "currencyKoreanName": "포린트",
      "currencySymbol": "Ft"
    },
    {
      "koreanName": "아이슬란드",
      "alpha2": "IS",
      "alpha3": "ISL",
      "currencyCode": "ISK",
      "currencyKoreanName": "크로네",
      "currencySymbol": "kr"
    },
    {
      "koreanName": "인도",
      "alpha2": "IN",
      "alpha3": "IND",
      "currencyCode": "INR",
      "currencyKoreanName": "루피",
      "currencySymbol": "Rs."
    },
    {
      "koreanName": "인도네시아",
      "alpha2": "ID",
      "alpha3": "IDN",
      "currencyCode": "IDR",
      "currencyKoreanName": "루피아",
      "currencySymbol": "Rp"
    },
    {
      "koreanName": "이란",
      "alpha2": "IR",
      "alpha3": "IRN",
      "currencyCode": "IRR",
      "currencyKoreanName": "리알",
      "currencySymbol": ""
    },
    {
      "koreanName": "이라크",
      "alpha2": "IQ",
      "alpha3": "IRQ",
      "currencyCode": "IQD",
      "currencyKoreanName": "디나르",
      "currencySymbol": "ع.د"
    },
    {
      "koreanName": "아일랜드",
      "alpha2": "IE",
      "alpha3": "IRL",
      "currencyCode": "EUR",
      "currencyKoreanName": "유로",
      "currencySymbol": "€"
    },
    {
      "koreanName": "이스라엘",
      "alpha2": "IL",
      "alpha3": "ISR",
      "currencyCode": "ILS",
      "currencyKoreanName": "셰켈",
      "currencySymbol": "₪"
    },
    {
      "koreanName": "이탈리아",
      "alpha2": "IT",
      "alpha3": "ITA",
      "currencyCode": "EUR",
      "currencyKoreanName": "유로",
      "currencySymbol": "€"
    },
    {
      "koreanName": "코트디부아르",
      "alpha2": "CI",
      "alpha3": "CIV",
      "currencyCode": "XOF",
      "currencyKoreanName": "(BCEAO)",
      "currencySymbol": "BCEAO"
    },
    {
      "koreanName": "자메이카",
      "alpha2": "JM",
      "alpha3": "JAM",
      "currencyCode": "JMD",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "일본",
      "alpha2": "JP",
      "alpha3": "JPN",
      "currencyCode": "JPY",
      "currencyKoreanName": "엔",
      "currencySymbol": "¥"
    },
    {
      "koreanName": "카자흐스탄",
      "alpha2": "KZ",
      "alpha3": "KAZ",
      "currencyCode": "KZT",
      "currencyKoreanName": "텡게",
      "currencySymbol": "KZT"
    },
    {
      "koreanName": "요르단",
      "alpha2": "JO",
      "alpha3": "JOR",
      "currencyCode": "JOD",
      "currencyKoreanName": "디나르",
      "currencySymbol": "JOD"
    },
    {
      "koreanName": "케냐",
      "alpha2": "KE",
      "alpha3": "KEN",
      "currencyCode": "KES",
      "currencyKoreanName": "실링",
      "currencySymbol": "KSh"
    },
    {
      "koreanName": "조선민주주의인민공화국",
      "alpha2": "KP",
      "alpha3": "PRK",
      "currencyCode": "KPW",
      "currencyKoreanName": "원",
      "currencySymbol": "₩"
    },
    {
      "koreanName": "대한민국",
      "alpha2": "KR",
      "alpha3": "KOR",
      "currencyCode": "KRW",
      "currencyKoreanName": "원",
      "currencySymbol": "₩"
    },
    {
      "koreanName": "쿠웨이트",
      "alpha2": "KW",
      "alpha3": "KWT",
      "currencyCode": "KWD",
      "currencyKoreanName": "디나르",
      "currencySymbol": "د.ك"
    },
    {
      "koreanName": "키르기스스탄",
      "alpha2": "KG",
      "alpha3": "KGZ",
      "currencyCode": "KGS",
      "currencyKoreanName": "솜",
      "currencySymbol": "KGS"
    },
    {
      "koreanName": "라오스",
      "alpha2": "LA",
      "alpha3": "LAO",
      "currencyCode": "LAK",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "레바논",
      "alpha2": "LB",
      "alpha3": "LBN",
      "currencyCode": "LBP",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "레소토",
      "alpha2": "LS",
      "alpha3": "LSO",
      "currencyCode": "LSL",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "라트비아",
      "alpha2": "LV",
      "alpha3": "LVA",
      "currencyCode": "LVL",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "라이베리아",
      "alpha2": "LR",
      "alpha3": "LBR",
      "currencyCode": "LRD",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "리비아",
      "alpha2": "LY",
      "alpha3": "LBY",
      "currencyCode": "LYD",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "리히텐슈타인",
      "alpha2": "LI",
      "alpha3": "LIE",
      "currencyCode": "CHF",
      "currencyKoreanName": "프랑",
      "currencySymbol": "CHF"
    },
    {
      "koreanName": "리투아니아",
      "alpha2": "LT",
      "alpha3": "LTU",
      "currencyCode": "EUR",
      "currencyKoreanName": "유로",
      "currencySymbol": "€"
    },
    {
      "koreanName": "룩셈부르크",
      "alpha2": "LU",
      "alpha3": "LUX",
      "currencyCode": "EUR",
      "currencyKoreanName": "유로",
      "currencySymbol": "€"
    },
    {
      "koreanName": "마카오",
      "alpha2": "MO",
      "alpha3": "MAC",
      "currencyCode": "MOP",
      "currencyKoreanName": "파타카",
      "currencySymbol": "\$"
    },
    {
      "koreanName": "마다가스카르",
      "alpha2": "MG",
      "alpha3": "MDG",
      "currencyCode": "MGA",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "말라위",
      "alpha2": "MW",
      "alpha3": "MWI",
      "currencyCode": "MWK",
      "currencyKoreanName": "콰차",
      "currencySymbol": "MK"
    },
    {
      "koreanName": "말레이시아",
      "alpha2": "MY",
      "alpha3": "MYS",
      "currencyCode": "MYR",
      "currencyKoreanName": "링깃",
      "currencySymbol": "RM"
    },
    {
      "koreanName": "몰디브",
      "alpha2": "MV",
      "alpha3": "MDV",
      "currencyCode": "MVR",
      "currencyKoreanName": "루피야",
      "currencySymbol": "Rf"
    },
    {
      "koreanName": "말리",
      "alpha2": "ML",
      "alpha3": "MLI",
      "currencyCode": "XOF",
      "currencyKoreanName": "(BCEAO)",
      "currencySymbol": "BCEAO"
    },
    {
      "koreanName": "몰타",
      "alpha2": "MT",
      "alpha3": "MLT",
      "currencyCode": "EUR",
      "currencyKoreanName": "유로",
      "currencySymbol": "€"
    },
    {
      "koreanName": "마르티니크",
      "alpha2": "MQ",
      "alpha3": "MTQ",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "모리타니",
      "alpha2": "MR",
      "alpha3": "MRT",
      "currencyCode": "MRO",
      "currencyKoreanName": "우기야",
      "currencySymbol": "UM"
    },
    {
      "koreanName": "모리셔스",
      "alpha2": "MU",
      "alpha3": "MUS",
      "currencyCode": "MUR",
      "currencyKoreanName": "루피",
      "currencySymbol": "₨"
    },
    {
      "koreanName": "멕시코",
      "alpha2": "MX",
      "alpha3": "MEX",
      "currencyCode": "MXN",
      "currencyKoreanName": "페소",
      "currencySymbol": "\$"
    },
    {
      "koreanName": "모나코",
      "alpha2": "MC",
      "alpha3": "MCO",
      "currencyCode": "EUR",
      "currencyKoreanName": "유로",
      "currencySymbol": "€"
    },
    {
      "koreanName": "몽골",
      "alpha2": "MN",
      "alpha3": "MNG",
      "currencyCode": "MNT",
      "currencyKoreanName": "투그릭",
      "currencySymbol": "₮"
    },
    {
      "koreanName": "몰도바",
      "alpha2": "MD",
      "alpha3": "MDA",
      "currencyCode": "MDL",
      "currencyKoreanName": "레우",
      "currencySymbol": "MDL"
    },
    {
      "koreanName": "몬테네그로",
      "alpha2": "ME",
      "alpha3": "MNE",
      "currencyCode": "EUR",
      "currencyKoreanName": "유로",
      "currencySymbol": "€"
    },
    {
      "koreanName": "몬트세랫",
      "alpha2": "MS",
      "alpha3": "MSR",
      "currencyCode": "XCD",
      "currencyKoreanName": "달러",
      "currencySymbol": "EC\$"
    },
    {
      "koreanName": "모로코",
      "alpha2": "MA",
      "alpha3": "MAR",
      "currencyCode": "MAD",
      "currencyKoreanName": "디르함",
      "currencySymbol": "د.م."
    },
    {
      "koreanName": "모잠비크",
      "alpha2": "MZ",
      "alpha3": "MOZ",
      "currencyCode": "MZN",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "오만",
      "alpha2": "OM",
      "alpha3": "OMN",
      "currencyCode": "OMR",
      "currencyKoreanName": "리알",
      "currencySymbol": "ر.ع."
    },
    {
      "koreanName": "나미비아",
      "alpha2": "NA",
      "alpha3": "NAM",
      "currencyCode": "NAD",
      "currencyKoreanName": "달러",
      "currencySymbol": "N\$"
    },
    {
      "koreanName": "나우루",
      "alpha2": "NR",
      "alpha3": "NRU",
      "currencyCode": "AUD",
      "currencyKoreanName": "달러",
      "currencySymbol": "\$"
    },
    {
      "koreanName": "네팔",
      "alpha2": "NP",
      "alpha3": "NPL",
      "currencyCode": "NPR",
      "currencyKoreanName": "루피",
      "currencySymbol": "₨"
    },
    {
      "koreanName": "네덜란드",
      "alpha2": "NL",
      "alpha3": "NLD",
      "currencyCode": "EUR",
      "currencyKoreanName": "유로",
      "currencySymbol": "€"
    },
    {
      "koreanName": "네덜란드령 안틸레스",
      "alpha2": "AN",
      "alpha3": "ANT",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "아루바",
      "alpha2": "AW",
      "alpha3": "ABW",
      "currencyCode": "AWG",
      "currencyKoreanName": "플로린",
      "currencySymbol": "ƒ"
    },
    {
      "koreanName": "누벨칼레도니",
      "alpha2": "NC",
      "alpha3": "NCL",
      "currencyCode": "XPF",
      "currencyKoreanName": "프랑",
      "currencySymbol": "F"
    },
    {
      "koreanName": "바누아투",
      "alpha2": "VU",
      "alpha3": "VUT",
      "currencyCode": "VUV",
      "currencyKoreanName": "바투",
      "currencySymbol": "Vt"
    },
    {
      "koreanName": "뉴질랜드",
      "alpha2": "NZ",
      "alpha3": "NZL",
      "currencyCode": "NZD",
      "currencyKoreanName": "달러",
      "currencySymbol": "\$"
    },
    {
      "koreanName": "니카라과",
      "alpha2": "NI",
      "alpha3": "NIC",
      "currencyCode": "NIO",
      "currencyKoreanName": "코르도바",
      "currencySymbol": "C\$"
    },
    {
      "koreanName": "니제르",
      "alpha2": "NE",
      "alpha3": "NER",
      "currencyCode": "XOF",
      "currencyKoreanName": "(BCEAO)",
      "currencySymbol": "BCEAO"
    },
    {
      "koreanName": "나이지리아",
      "alpha2": "NG",
      "alpha3": "NGA",
      "currencyCode": "NGN",
      "currencyKoreanName": "나이라",
      "currencySymbol": "₦"
    },
    {
      "koreanName": "니우에",
      "alpha2": "NU",
      "alpha3": "NIU",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "노퍽 섬",
      "alpha2": "NF",
      "alpha3": "NFK",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "노르웨이",
      "alpha2": "NO",
      "alpha3": "NOR",
      "currencyCode": "NOK",
      "currencyKoreanName": "크로네",
      "currencySymbol": "kr"
    },
    {
      "koreanName": "북마리아나 제도",
      "alpha2": "MP",
      "alpha3": "MNP",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "미국령 군소 제도",
      "alpha2": "UM",
      "alpha3": "UMI",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "미크로네시아 연방",
      "alpha2": "FM",
      "alpha3": "FSM",
      "currencyCode": "USD",
      "currencyKoreanName": "달러",
      "currencySymbol": "\$"
    },
    {
      "koreanName": "마셜 제도",
      "alpha2": "MH",
      "alpha3": "MHL",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "팔라우",
      "alpha2": "PW",
      "alpha3": "PLW",
      "currencyCode": "USD",
      "currencyKoreanName": "달러",
      "currencySymbol": "\$"
    },
    {
      "koreanName": "파키스탄",
      "alpha2": "PK",
      "alpha3": "PAK",
      "currencyCode": "PKR",
      "currencyKoreanName": "루피",
      "currencySymbol": "Rs."
    },
    {
      "koreanName": "파나마",
      "alpha2": "PA",
      "alpha3": "PAN",
      "currencyCode": "PAB",
      "currencyKoreanName": "발보아",
      "currencySymbol": "B"
    },
    {
      "koreanName": "파푸아 뉴기니",
      "alpha2": "PG",
      "alpha3": "PNG",
      "currencyCode": "PGK",
      "currencyKoreanName": "키나",
      "currencySymbol": "K"
    },
    {
      "koreanName": "파라과이",
      "alpha2": "PY",
      "alpha3": "PRY",
      "currencyCode": "PYG",
      "currencyKoreanName": "과라니",
      "currencySymbol": ""
    },
    {
      "koreanName": "페루",
      "alpha2": "PE",
      "alpha3": "PER",
      "currencyCode": "PEN",
      "currencyKoreanName": "누에보솔",
      "currencySymbol": "S\/."
    },
    {
      "koreanName": "필리핀",
      "alpha2": "PH",
      "alpha3": "PHL",
      "currencyCode": "PHP",
      "currencyKoreanName": "페소",
      "currencySymbol": "₱"
    },
    {
      "koreanName": "핏케언 제도",
      "alpha2": "PN",
      "alpha3": "PCN",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "폴란드",
      "alpha2": "PL",
      "alpha3": "POL",
      "currencyCode": "PLN",
      "currencyKoreanName": "즈워티",
      "currencySymbol": "zł"
    },
    {
      "koreanName": "포르투갈",
      "alpha2": "PT",
      "alpha3": "PRT",
      "currencyCode": "EUR",
      "currencyKoreanName": "유로",
      "currencySymbol": "€"
    },
    {
      "koreanName": "기니비사우",
      "alpha2": "GW",
      "alpha3": "GNB",
      "currencyCode": "XOF",
      "currencyKoreanName": "(BCEAO)",
      "currencySymbol": "BCEAO"
    },
    {
      "koreanName": "동티모르",
      "alpha2": "TL",
      "alpha3": "TLS",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "푸에르토리코",
      "alpha2": "PR",
      "alpha3": "PRI",
      "currencyCode": "USD",
      "currencyKoreanName": "달러",
      "currencySymbol": "\$"
    },
    {
      "koreanName": "카타르",
      "alpha2": "QA",
      "alpha3": "QAT",
      "currencyCode": "QAR",
      "currencyKoreanName": "리알",
      "currencySymbol": "ر.ق"
    },
    {
      "koreanName": "레위니옹",
      "alpha2": "RE",
      "alpha3": "REU",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "루마니아",
      "alpha2": "RO",
      "alpha3": "ROU",
      "currencyCode": "RON",
      "currencyKoreanName": "레우",
      "currencySymbol": "L"
    },
    {
      "koreanName": "러시아",
      "alpha2": "RU",
      "alpha3": "RUS",
      "currencyCode": "RUB",
      "currencyKoreanName": "루블",
      "currencySymbol": "руб"
    },
    {
      "koreanName": "르완다",
      "alpha2": "RW",
      "alpha3": "RWA",
      "currencyCode": "RWF",
      "currencyKoreanName": "프랑",
      "currencySymbol": "RF"
    },
    {
      "koreanName": "세인트헬레나",
      "alpha2": "SH",
      "alpha3": "SHN",
      "currencyCode": "SHP",
      "currencyKoreanName": "파운드",
      "currencySymbol": "£"
    },
    {
      "koreanName": "세인트키츠 네비스",
      "alpha2": "KN",
      "alpha3": "KNA",
      "currencyCode": "XCD",
      "currencyKoreanName": "달러",
      "currencySymbol": "EC\$"
    },
    {
      "koreanName": "앵귈라",
      "alpha2": "AI",
      "alpha3": "AIA",
      "currencyCode": "XCD",
      "currencyKoreanName": "달러",
      "currencySymbol": "EC\$"
    },
    {
      "koreanName": "세인트루시아",
      "alpha2": "LC",
      "alpha3": "LCA",
      "currencyCode": "XCD",
      "currencyKoreanName": "달러",
      "currencySymbol": "EC\$"
    },
    {
      "koreanName": "생피에르 미클롱",
      "alpha2": "PM",
      "alpha3": "SPM",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "세인트빈센트 그레나딘",
      "alpha2": "VC",
      "alpha3": "VCT",
      "currencyCode": "XCD",
      "currencyKoreanName": "달러",
      "currencySymbol": "EC\$"
    },
    {
      "koreanName": "산마리노",
      "alpha2": "SM",
      "alpha3": "SMR",
      "currencyCode": "EUR",
      "currencyKoreanName": "유로",
      "currencySymbol": "€"
    },
    {
      "koreanName": "상투메 프린시페",
      "alpha2": "ST",
      "alpha3": "STP",
      "currencyCode": "STD",
      "currencyKoreanName": "도브라",
      "currencySymbol": "Db"
    },
    {
      "koreanName": "사우디아라비아",
      "alpha2": "SA",
      "alpha3": "SAU",
      "currencyCode": "SAR",
      "currencyKoreanName": "리얄",
      "currencySymbol": "ر.س"
    },
    {
      "koreanName": "세네갈",
      "alpha2": "SN",
      "alpha3": "SEN",
      "currencyCode": "XOF",
      "currencyKoreanName": "(BCEAO)",
      "currencySymbol": "BCEAO"
    },
    {
      "koreanName": "세르비아",
      "alpha2": "RS",
      "alpha3": "SRB",
      "currencyCode": "RSD",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "세이셸",
      "alpha2": "SC",
      "alpha3": "SYC",
      "currencyCode": "SCR",
      "currencyKoreanName": "루피",
      "currencySymbol": "SR"
    },
    {
      "koreanName": "시에라리온",
      "alpha2": "SL",
      "alpha3": "SLE",
      "currencyCode": "SLL",
      "currencyKoreanName": "레온",
      "currencySymbol": "Le"
    },
    {
      "koreanName": "싱가포르",
      "alpha2": "SG",
      "alpha3": "SGP",
      "currencyCode": "SGD",
      "currencyKoreanName": "달러",
      "currencySymbol": "S\$"
    },
    {
      "koreanName": "슬로바키아",
      "alpha2": "SK",
      "alpha3": "SVK",
      "currencyCode": "EUR",
      "currencyKoreanName": "유로",
      "currencySymbol": "€"
    },
    {
      "koreanName": "베트남",
      "alpha2": "VN",
      "alpha3": "VNM",
      "currencyCode": "VND",
      "currencyKoreanName": "동",
      "currencySymbol": "₫"
    },
    {
      "koreanName": "슬로베니아",
      "alpha2": "SI",
      "alpha3": "SVN",
      "currencyCode": "EUR",
      "currencyKoreanName": "유로",
      "currencySymbol": "€"
    },
    {
      "koreanName": "소말리아",
      "alpha2": "SO",
      "alpha3": "SOM",
      "currencyCode": "SOS",
      "currencyKoreanName": "실링",
      "currencySymbol": "So."
    },
    {
      "koreanName": "남아프리카 공화국",
      "alpha2": "ZA",
      "alpha3": "ZAF",
      "currencyCode": "ZAR",
      "currencyKoreanName": "랜드",
      "currencySymbol": "R"
    },
    {
      "koreanName": "짐바브웨",
      "alpha2": "ZW",
      "alpha3": "ZWE",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "스페인",
      "alpha2": "ES",
      "alpha3": "ESP",
      "currencyCode": "EUR",
      "currencyKoreanName": "유로",
      "currencySymbol": "€"
    },
    {
      "koreanName": "남수단",
      "alpha2": "SS",
      "alpha3": "SSD",
      "currencyCode": "SDG",
      "currencyKoreanName": "파운드",
      "currencySymbol": "SDG"
    },
    {
      "koreanName": "서사하라",
      "alpha2": "EH",
      "alpha3": "ESH",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "수단",
      "alpha2": "SD",
      "alpha3": "SDN",
      "currencyCode": "SDG",
      "currencyKoreanName": "파운드",
      "currencySymbol": "SDG"
    },
    {
      "koreanName": "수리남",
      "alpha2": "SR",
      "alpha3": "SUR",
      "currencyCode": "SRD",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "스발바르 얀마옌",
      "alpha2": "SJ",
      "alpha3": "SJM",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "스와질란드",
      "alpha2": "SZ",
      "alpha3": "SWZ",
      "currencyCode": "SZL",
      "currencyKoreanName": "릴랑게니",
      "currencySymbol": "SZL"
    },
    {
      "koreanName": "스웨덴",
      "alpha2": "SE",
      "alpha3": "SWE",
      "currencyCode": "SEK",
      "currencyKoreanName": "크로나",
      "currencySymbol": "kr"
    },
    {
      "koreanName": "스위스",
      "alpha2": "CH",
      "alpha3": "CHE",
      "currencyCode": "CHF",
      "currencyKoreanName": "프랑",
      "currencySymbol": "CHF"
    },
    {
      "koreanName": "시리아",
      "alpha2": "SY",
      "alpha3": "SYR",
      "currencyCode": "SYP",
      "currencyKoreanName": "파운드",
      "currencySymbol": "SYP"
    },
    {
      "koreanName": "타지키스탄",
      "alpha2": "TJ",
      "alpha3": "TJK",
      "currencyCode": "TJS",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "타이",
      "alpha2": "TH",
      "alpha3": "THA",
      "currencyCode": "THB",
      "currencyKoreanName": "바트",
      "currencySymbol": "฿"
    },
    {
      "koreanName": "토고",
      "alpha2": "TG",
      "alpha3": "TGO",
      "currencyCode": "XOF",
      "currencyKoreanName": "(BCEAO)",
      "currencySymbol": "BCEAO"
    },
    {
      "koreanName": "토켈라우",
      "alpha2": "TK",
      "alpha3": "TKL",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "통가",
      "alpha2": "TO",
      "alpha3": "TON",
      "currencyCode": "TOP",
      "currencyKoreanName": "팡가",
      "currencySymbol": "T\$"
    },
    {
      "koreanName": "트리니다드 토바고",
      "alpha2": "TT",
      "alpha3": "TTO",
      "currencyCode": "TTD",
      "currencyKoreanName": "달러",
      "currencySymbol": "TTD"
    },
    {
      "koreanName": "아랍에미리트",
      "alpha2": "AE",
      "alpha3": "ARE",
      "currencyCode": "AED",
      "currencyKoreanName": "디르함",
      "currencySymbol": "د.إ"
    },
    {
      "koreanName": "튀니지",
      "alpha2": "TN",
      "alpha3": "TUN",
      "currencyCode": "TND",
      "currencyKoreanName": "디나르",
      "currencySymbol": "د.ت"
    },
    {
      "koreanName": "터키",
      "alpha2": "TR",
      "alpha3": "TUR",
      "currencyCode": "TRY",
      "currencyKoreanName": "리라",
      "currencySymbol": "YTL"
    },
    {
      "koreanName": "투르크메니스탄",
      "alpha2": "TM",
      "alpha3": "TKM",
      "currencyCode": "TMT",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "터크스 케이커스 제도",
      "alpha2": "TC",
      "alpha3": "TCA",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "투발루",
      "alpha2": "TV",
      "alpha3": "TUV",
      "currencyCode": "AUD",
      "currencyKoreanName": "달러",
      "currencySymbol": "\$"
    },
    {
      "koreanName": "우간다",
      "alpha2": "UG",
      "alpha3": "UGA",
      "currencyCode": "UGX",
      "currencyKoreanName": "실링",
      "currencySymbol": "USh"
    },
    {
      "koreanName": "우크라이나",
      "alpha2": "UA",
      "alpha3": "UKR",
      "currencyCode": "UAH",
      "currencyKoreanName": "흐리브냐",
      "currencySymbol": ""
    },
    {
      "koreanName": "마케도니아 공화국",
      "alpha2": "MK",
      "alpha3": "MKD",
      "currencyCode": "MKD",
      "currencyKoreanName": "디나르",
      "currencySymbol": "MKD"
    },
    {
      "koreanName": "이집트",
      "alpha2": "EG",
      "alpha3": "EGY",
      "currencyCode": "EGP",
      "currencyKoreanName": "파운드",
      "currencySymbol": "ج.م"
    },
    {
      "koreanName": "영국",
      "alpha2": "GB",
      "alpha3": "GBR",
      "currencyCode": "GBP",
      "currencyKoreanName": "파운드",
      "currencySymbol": "£"
    },
    {
      "koreanName": "건지 섬",
      "alpha2": "GG",
      "alpha3": "GGY",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "저지 섬",
      "alpha2": "JE",
      "alpha3": "JEY",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "맨 섬",
      "alpha2": "IM",
      "alpha3": "IMN",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "탄자니아",
      "alpha2": "TZ",
      "alpha3": "TZA",
      "currencyCode": "TZS",
      "currencyKoreanName": "실링",
      "currencySymbol": "x"
    },
    {
      "koreanName": "미국",
      "alpha2": "US",
      "alpha3": "USA",
      "currencyCode": "USD",
      "currencyKoreanName": "달러",
      "currencySymbol": "\$"
    },
    {
      "koreanName": "미국령 버진아일랜드",
      "alpha2": "VI",
      "alpha3": "VIR",
      "currencyCode": "",
      "currencyKoreanName": "",
      "currencySymbol": ""
    },
    {
      "koreanName": "부르키나파소",
      "alpha2": "BF",
      "alpha3": "BFA",
      "currencyCode": "XOF",
      "currencyKoreanName": "(BCEAO)",
      "currencySymbol": "BCEAO"
    },
    {
      "koreanName": "우루과이",
      "alpha2": "UY",
      "alpha3": "URY",
      "currencyCode": "UYU",
      "currencyKoreanName": "페소",
      "currencySymbol": "UYU"
    },
    {
      "koreanName": "우즈베키스탄",
      "alpha2": "UZ",
      "alpha3": "UZB",
      "currencyCode": "UZS",
      "currencyKoreanName": "솜",
      "currencySymbol": "UZS"
    },
    {
      "koreanName": "베네수엘라",
      "alpha2": "VE",
      "alpha3": "VEN",
      "currencyCode": "VEF",
      "currencyKoreanName": "후에르떼",
      "currencySymbol": "VEF"
    },
    {
      "koreanName": "왈리스 퓌튀나",
      "alpha2": "WF",
      "alpha3": "WLF",
      "currencyCode": "XPF",
      "currencyKoreanName": "프랑",
      "currencySymbol": "F"
    },
    {
      "koreanName": "사모아",
      "alpha2": "WS",
      "alpha3": "WSM",
      "currencyCode": "WST",
      "currencyKoreanName": "탈라",
      "currencySymbol": "WS\$"
    },
    {
      "koreanName": "예멘",
      "alpha2": "YE",
      "alpha3": "YEM",
      "currencyCode": "YER",
      "currencyKoreanName": "리알",
      "currencySymbol": "YER"
    },
    {
      "koreanName": "잠비아",
      "alpha2": "ZM",
      "alpha3": "ZMB",
      "currencyCode": "ZMW",
      "currencyKoreanName": "",
      "currencySymbol": ""
    }
  ];
  countryCode = countryCode.toUpperCase();
  final found = names.firstWhere((e) => e['alpha2'] == countryCode,
      orElse: () => {
            "koreanName": "",
            "alpha2": "",
            "alpha3": "",
            "currencyCode": "",
            "currencyKoreanName": "",
            "currencySymbol": ""
          });
  return CurrencyModel(found);
}
