class InvoiceModel {
  final int id;
  final String date;
  final String number;
  final String customer;
  final String issuer;

  InvoiceModel({
    required this.id,
    required this.date,
    required this.number,
    required this.customer,
    required this.issuer,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id'],
      date: json['date'],
      number: json['number'],
      customer: json['customer'],
      issuer: json['issuer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'number': number,
      'customer': customer,
      'issuer': issuer,
    };
  }
}
