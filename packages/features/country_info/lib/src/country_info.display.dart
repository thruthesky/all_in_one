import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';
import 'package:x_flutter/x_flutter.dart';

class CountryInfoDisplay extends StatefulWidget {
  @override
  _CountryInfoDisplayState createState() => _CountryInfoDisplayState();
}

class _CountryInfoDisplayState extends State<CountryInfoDisplay> {
  CountryModel? country;
  String? dialCode;

  getCountry(CountryCode cc) async {
    try {
      dialCode = cc.dialCode;
      country = await Api.instance.country.get(countryCode: cc.code);
      setState(() {});
    } catch (e) {
      error(e);
    }
  }

  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          spaceXl,
          Text('국가를 선택하세요.'),
          spaceXs,
          Container(
            color: Colors.grey[100],
            child: CountryCodePicker(
              onChanged: (e) => getCountry(e),
              initialSelection: 'KR',
              showCountryOnly: true,
              showOnlyCountryWhenClosed: true,
              favorite: ['KR', 'US', 'JP', 'CN'],
              // Get the country information relevant to the initial selection
              onInit: (code) => getCountry(code!),
              // builder: (CountryCode? code) {
              //   return Text('yo');
              // },
            ),
          ),
          spaceSm,
          Divider(),
          spaceSm,
          if (dialCode != null) CenteredRow(left: Text('국가 전화 코드 : '), right: Text(dialCode!)),
          if (country != null) CountryInfoDisplayDetails(country: country!)
        ],
      ),
    );
  }
}

class CountryInfoDisplayDetails extends StatelessWidget {
  const CountryInfoDisplayDetails({
    Key? key,
    required this.country,
  }) : super(key: key);

  final CountryModel country;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CenteredRow(left: Text('국가 이름(한글) : '), right: Text(country.koreanName)),
        spaceXxs,
        CenteredRow(left: Text('국가 이름(영문) : '), right: Text(country.englishName)),
        spaceXxs,
        CenteredRow(left: Text('국가 이름(공식) : '), right: Text(country.officialName)),
        spaceXxs,
        CenteredRow(left: Text('두 자리 국가 코드(alpha2) : '), right: Text(country.alpha2)),
        spaceXxs,
        CenteredRow(left: Text('세 자리 국가 코드(alpha3) : '), right: Text(country.alpha3)),
        spaceXxs,
        CenteredRow(left: Text('통화 코드 : '), right: Text(country.currencyCode)),
        spaceXxs,
        CenteredRow(left: Text('통화 이름 : '), right: Text(country.currencyKoreanName)),
        spaceXxs,
        CenteredRow(left: Text('통화 심볼 : '), right: Text(country.currencySymbol)),
        spaceXxs,
        CenteredRow(left: Text('ISO 숫자 코드 : '), right: Text(country.numericCode.toString())),
        spaceXxs,
        CenteredRow(left: Text('국가 중심 위도 : '), right: Text(country.latitude.toString())),
        spaceXxs,
        CenteredRow(left: Text('국가 중심 경도 : '), right: Text(country.longitude.toString())),
        spaceXxs,
      ],
    );
  }
}
