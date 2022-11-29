class Product{
  int id, weight;
  double price, markedPrice;
  String name,description, productDetail,  seoTitle, seoDescription;
  String image;

  Product({
    this.id,
    this.weight,
    this.markedPrice,
    this.price,
    this.name,
    this.description,
    this.productDetail,
    this.seoTitle,
    this.seoDescription,
    this.image
});

  Product.fromJson(Map<dynamic, dynamic> p){
    id = p['id'];
    weight= p['weight'];
    name= p['name'];
    description=p['description'];
    productDetail= p['product_detail'];
    markedPrice= p['marked_price'];
    price=p['price'];
    image=p['images'][0]['image'];
  }

  int get getId => id;
  int get getWeight =>weight;
  String get getName =>name;
  String get getDescription =>description;
  String get getProductDetail =>productDetail;
  String get getImage => image;
  double get getPrice => price;
  double get getMarkedPrice => markedPrice;
}



