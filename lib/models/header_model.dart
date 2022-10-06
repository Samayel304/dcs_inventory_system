class Header {
  final String title;
  final int flex;

  Header({required this.title, required this.flex});

  static List<Header> headers = [
    Header(title: "ID", flex: 1),
    Header(title: "Product Name", flex: 3),
    Header(title: "Unit Price", flex: 2),
    Header(title: "Quantity", flex: 2),
    Header(title: "", flex: 1)
  ];
}
