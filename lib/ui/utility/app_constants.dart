class AppConstants{
  static RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
  );
  static RegExp mobileRegExp = RegExp(
      r'^(?:\+?88)?01[3-9]\d{8}$'
  );

}