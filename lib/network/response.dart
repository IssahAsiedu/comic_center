class PaginatedData<T> {
  final int offset;
  final int total;
  final List<T> data;

  PaginatedData({
    this.offset = 0,
    this.total = 0,
    required this.data,
  });
}

enum Status {
  loading, error, success
}

class ApiResponse<T> {
  final Status status;
  final String? message;
  final T? data;

  ApiResponse({required this.status, required this.message, required this.data});

  ApiResponse.success({this.status = Status.success, this.data, this.message = ''});

  ApiResponse.error({this.status = Status.error, this.data, this.message = ''});
}


