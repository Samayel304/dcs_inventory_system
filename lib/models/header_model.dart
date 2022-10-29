class Header {
  final String title;
  final int flex;

  Header({required this.title, required this.flex});

  static List<Header> headers = [
    Header(title: "ID", flex: 1),
    Header(title: "Product Name", flex: 3),
    Header(title: "Quantity", flex: 2),
    Header(title: "", flex: 1)
  ];

  static List<Header> manageAccountHeaders = [
    Header(title: "", flex: 1),
    Header(title: "Fullname", flex: 3),
    Header(title: "Email", flex: 3),
    Header(title: "", flex: 1)
  ];
}
