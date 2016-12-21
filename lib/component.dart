library PCBuilder.Component;

class Component {
  int id;
  String name;
  String brand;
  String europeanArticleNumber;
  String manufacturerPartNumber;
  String type;

  String shop;
  double price;
  String url;
  String image;

  Component(String name, String brand, String europeanArticleNumber, String manufacturerPartNumber, String type) {
    this.name = name;
    this.brand = brand;
    this.europeanArticleNumber = europeanArticleNumber;
    this.manufacturerPartNumber = manufacturerPartNumber;
    this.type = type;
  }
}
