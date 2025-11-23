class PriceRequestModel {
  final String requestDate;
  final String productName;
  final String requestType;
  final int currentPrice;
  final int requestedPrice;
  String approvalStatus;

  PriceRequestModel({
    required this.requestDate,
    required this.productName,
    required this.requestType,
    required this.currentPrice,
    required this.requestedPrice,
    required this.approvalStatus,
  });

  factory PriceRequestModel.fromJson(Map<String, dynamic> json) {
    return PriceRequestModel(
      requestDate: json['request_date'],
      productName: json['product_name'],
      requestType: json['request_type'],
      currentPrice: json['current_price'],
      requestedPrice: json['requested_price'],
      approvalStatus: json['approval_status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_date': requestDate,
      'product_name': productName,
      'request_type': requestType,
      'current_price': currentPrice,
      'requested_price': requestedPrice,
      'approval_status': approvalStatus,
    };
  }
}
