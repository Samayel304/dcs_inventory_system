class Account {
  final String id;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String email;
  final String password;
  final String role;
  final String avatarUrl;

  Account(
      {required this.id,
      required this.firstName,
      this.middleName,
      required this.lastName,
      required this.email,
      required this.password,
      required this.role,
      required this.avatarUrl});

  static List<Account> accounts = [
    Account(
        id: "1",
        firstName: "Jerico",
        lastName: "Rito",
        email: "jericorito@gmail.com",
        password: "123",
        role: "admin",
        avatarUrl: "")
  ];
}
