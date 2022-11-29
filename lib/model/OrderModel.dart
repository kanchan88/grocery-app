
class OrderModel{
  int orderNumber;
  List<dynamic> items;
  String deliveryDate;
  double price;
  String deliveryStatus;
  String paymentStatus;

  OrderModel({this.orderNumber, this.items, this.deliveryDate, this.price, this.deliveryStatus, this.paymentStatus});
}