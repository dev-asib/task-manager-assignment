class NetworkResponse {
  final int stauscode;
  final bool isSuccess;
  final dynamic reponseData;
  final String? errorMessage;

  NetworkResponse({
    required this.stauscode,
    required this.isSuccess,
    this.reponseData,
    this.errorMessage = "Something Went Wrong",
  });
}
