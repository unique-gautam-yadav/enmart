// ignore_for_file: public_member_api_docs, sort_constructors_first
class AppResponse {
  String msg;
  bool hasError;
  Object? data;

  AppResponse({
    required this.msg,
    required this.hasError,
    this.data,
  });
}
