final String _baseUrl = 'https://sc.sci.tsu.ac.th/riskarea/api/';

class Api {
  static String url = _baseUrl;
  //----
  //--- ตำแหน่งที่เกืดเหตุ-----
  static String getPositionRisk = _baseUrl + 'position';

  Api() : super();
}
