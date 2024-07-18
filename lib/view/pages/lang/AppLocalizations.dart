import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AppLocalizations {
  late Map<String, String> localizedStrings;

  AppLocalizations(this.localizedStrings);

  static Future<AppLocalizations> load(Locale locale) async {
    final String jsonString = await rootBundle.loadString('assets/${locale.languageCode}.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    Map<String, String> localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return AppLocalizations(localizedStrings);
  }

    static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  String? getNewsHeader() {
    return localizedStrings['news-header'];
  }
  String ? getnews_tab1(){
    return localizedStrings['emergency-new'];
  }
    String ? getnews_tab2(){
    return localizedStrings['general-news'];
  }
    String ? getnews_tab3(){
    return localizedStrings['pest-sidenews'];
  }
   String ? getnews_head(){
    return localizedStrings['news-header'];
  }
  String ?getbtn_name(){
    return localizedStrings['add'];
  }
   String? getSafeCrop() {
  return localizedStrings['safe-crop'];
}

String? getDetect() {
  return localizedStrings['detect'];
}

String? getProfile() {
  return localizedStrings['profile'];
}

String ? getHistory() {
  return localizedStrings['history'];
}

String? getDetectPests() {
  return localizedStrings['detect-pests'];
}

String? getDetectDisease() {
  return localizedStrings['detect-disease'];
}

String? getDetectPage() {
  return localizedStrings['detect-page'];
}

String? getPestDetect() {
  return localizedStrings['pest-detect'];
}

String? getYourProfile() {
  return localizedStrings['your-profile'];
}

String? getUpdate() {
  return localizedStrings['update'];
}

String? getScanHistory() {
  return localizedStrings['scanhistory'];
}

String? getEmergencyNew() {
  return localizedStrings['emergency-new'];
}

String? getGeneralNews() {
  return localizedStrings['general-news'];
}

String? getPestSideNews() {
  return localizedStrings['pest-sidenews'];
}

String? getDetectResults() {
  return localizedStrings['detect-results'];
}

String? getSuggestion() {
  return localizedStrings['suggetion'];
}

String? getCropType() {
  return localizedStrings['crop-type'];
}

String? getCropAge() {
  return localizedStrings['crop-age'];
}

String? getCropTemp() {
  return localizedStrings['crop-temp'];
}

String? getTimeStamp() {
  return localizedStrings['time-stamp'];
}

String? getClose() {
  return localizedStrings['close'];
}

String? getAdd() {
  return localizedStrings['add'];
}

String? getSave() {
  return localizedStrings['save'];
}
String? getMaize() {
    return localizedStrings['Maize'];
  }

  String? get1To5Week() {
    return localizedStrings['1 to 5 week'];
  }

  String? get6To10Week() {
    return localizedStrings['6 to 10 week'];
  }

  String? get11To15Week() {
    return localizedStrings['11 to 15 week'];
  }

  String? getWarm() {
    return localizedStrings['warm'];
  }

  String? getRainy() {
    return localizedStrings['rainy'];
  }

  String? getWindy() {
    return localizedStrings['windy'];
  }
  String? getChoose() {
  return localizedStrings['Choose'];
}

String? getSelectImage() {
  return localizedStrings['Select-Image'];
}

String? getChooseImage() {
  return localizedStrings['Choose-Image'];
}

String? getCaptureImage() {
  return localizedStrings['Capture-Image'];
}

String? getCropHistory() {
  return localizedStrings['Crop-History'];
}

String? getHelp() {
  return localizedStrings['Help'];
}

String? getAmharic() {
  return localizedStrings['Amharic'];
}

String? getAfaanOromo() {
  return localizedStrings['Afaan-oromo'];
}

String? getName() {
  return localizedStrings['name'];
}

String? getArea() {
  return localizedStrings['Area'];
}

String? getLocation() {
  return localizedStrings['location'];
}
String? getError() {
  return localizedStrings['Error'];
}

String? getTheImageIsValid() {
  return localizedStrings['The image is valid. Please recapture the image'];
}

String? getOk() {
  return localizedStrings['OK'];
}
String? getanonymous(){
  return localizedStrings['anonymous'];
} 
String? getunknown(){
  return localizedStrings['unknown']; 
}
String? getresult(){
  return localizedStrings['result']; 
}
String? getPestHistory(){
  return localizedStrings['Pest-History']; 
}
  String? getSuggestion1() {
    return localizedStrings['Suggestion1'];
  }

  String? getSuggestion1a() {
    return localizedStrings['Suggestion1a'];
  }

  String? getSuggestion1b() {
    return localizedStrings['Suggestion1b'];
  }

  String? getSuggestion1c() {
    return localizedStrings['Suggestion1c'];
  }

  String? getSuggestion1d() {
    return localizedStrings['Suggestion1d'];
  }

  String? getSuggestion1e() {
    return localizedStrings['Suggestion1e'];
  }

  String? getSuggestion1f() {
    return localizedStrings['Suggestion1f'];
  }

  String? getSuggestion1g() {
    return localizedStrings['Suggestion1g'];
  }

  String? getSuggestion1h() {
    return localizedStrings['Suggestion1h'];
  }

  String? getSuggestion1i() {
    return localizedStrings['Suggestion1i'];
  }

  String? getSuggestion1j() {
    return localizedStrings['Suggestion1j'];
  }

  String? getSuggestion1k() {
    return localizedStrings['Suggestion1k'];
  }

  String? getSuggestion1l() {
    return localizedStrings['Suggestion1l'];
  }

  String? getSuggestion1m() {
    return localizedStrings['Suggestion1m'];
  }

  String? getSuggestion1n() {
    return localizedStrings['Suggestion1n'];
  }

  String? getSuggestion1o() {
    return localizedStrings['Suggestion1o'];
  }

  String? getSuggestion1p() {
    return localizedStrings['Suggestion1p'];
  }
  String? getSuggestion2() {
  return localizedStrings['Suggestion2'];
}

String? getSuggestion2a() {
  return localizedStrings['Suggestion2a'];
}

String? getSuggestion2b() {
  return localizedStrings['Suggestion2b'];
}

String? getSuggestion2c() {
  return localizedStrings['Suggestion2c'];
}

String? getSuggestion2d() {
  return localizedStrings['Suggestion2d'];
}

String? getSuggestion2e() {
  return localizedStrings['Suggestion2e'];
}

String? getSuggestion2f() {
  return localizedStrings['Suggestion2f'];
}

String? getSuggestion2g() {
  return localizedStrings['Suggestion2g'];
}

String? getSuggestion2h() {
  return localizedStrings['Suggestion2h'];
}

String? getSuggestion2i() {
  return localizedStrings['Suggestion2i'];
}

String? getSuggestion2j() {
  return localizedStrings['Suggestion2j'];
}

String? getSuggestion2k() {
  return localizedStrings['Suggestion2k'];
}

String? getSuggestion2l() {
  return localizedStrings['Suggestion2l'];
}

String? getSuggestion2m() {
  return localizedStrings['Suggestion2m'];
}

String? getSuggestion2n() {
  return localizedStrings['Suggestion2n'];
}

String? getSuggestion3() {
  return localizedStrings['Suggestion3'];
}

String? getSuggestion3a() {
  return localizedStrings['Suggestion3a'];
}

String? getSuggestion3b() {
  return localizedStrings['Suggestion3b'];
}

String? getSuggestion3c() {
  return localizedStrings['Suggestion3c'];
}

String? getSuggestion3d() {
  return localizedStrings['Suggestion3d'];
}

String? getSuggestion3e() {
  return localizedStrings['Suggestion3e'];
}

String? getSuggestion3f() {
  return localizedStrings['Suggestion3f'];
}

String? getSuggestion3h() {
  return localizedStrings['Suggestion3h'];
}

String? getSuggestion3i() {
  return localizedStrings['Suggestion3i'];
}

String? getSuggestion3j() {
  return localizedStrings['Suggestion3j'];
}

String? getSuggestion3k() {
  return localizedStrings['Suggestion3k'];
}

String? getSuggestion3l() {
  return localizedStrings['Suggestion3l'];
}

String? getSuggestion3m() {
  return localizedStrings['Suggestion3m'];
}

String? getSuggestion4() {
  return localizedStrings['Suggestion4'];
}

String? getSuggestion4a() {
  return localizedStrings['Suggestion4a'];
}

String? getSuggestion4b() {
  return localizedStrings['Suggestion4b'];
}

String? getSuggestion4c() {
  return localizedStrings['Suggestion4c'];
}

String? getSuggestion4d() {
  return localizedStrings['Suggestion4d'];
}

String? getSuggestion4e() {
  return localizedStrings['Suggestion4e'];
}

String? getSuggestion4f() {
  return localizedStrings['Suggestion4f'];
}

String? getSuggestion4g() {
  return localizedStrings['Suggestion4g'];
}

String? getSuggestion4h() {
  return localizedStrings['Suggestion4h'];
}

String? getSuggestion4i() {
  return localizedStrings['Suggestion4i'];
}

String? getSuggestion4j() {
  return localizedStrings['Suggestion4j'];
}

String? getSuggestion4k() {
  return localizedStrings['Suggestion4k'];
}

String? getSuggestion4l() {
  return localizedStrings['Suggestion4l'];
}

String? getSuggestion4m() {
  return localizedStrings['Suggestion4m'];
}
String? getSuggestion5() {
  return localizedStrings['Suggestion5'];
}
String? getSuggestion5a() {
  return localizedStrings['Suggestion5a'];
}

String? getSuggestion5b() {
  return localizedStrings['Suggestion5b'];
}

String? getSuggestion5c() {
  return localizedStrings['Suggestion5c'];
}

String? getSuggestion5d() {
  return localizedStrings['Suggestion5d'];
}

String? getSuggestion5e() {
  return localizedStrings['Suggestion5e'];
}

String? getSuggestion5f() {
  return localizedStrings['Suggestion5f'];
}

String? getSuggestion5g() {
  return localizedStrings['Suggestion5g'];
}

String? getSuggestion5h() {
  return localizedStrings['Suggestion5h'];
}

String? getSuggestion5i() {
  return localizedStrings['Suggestion5i'];
}

String? getSuggestion5j() {
  return localizedStrings['Suggestion5j'];
}
String? getWheat() {
  return localizedStrings['Wheat'];
}


}