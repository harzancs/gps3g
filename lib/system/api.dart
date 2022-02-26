final String _baseUrl = 'https://sc.sci.tsu.ac.th/riskarea/api/';

class Api {
  static String url = _baseUrl;
  //----
  //--- ตำแหน่งที่เกืดเหตุ-----
  static String getPositionRisk = _baseUrl + 'position';
  static String getNewsRisk = _baseUrl + 'news_social';
  //-----สมาชิก
  static String postMember = _baseUrl + 'member/insertMember';
  static String getMember = _baseUrl + 'member/get/';

  Api() : super();
}
