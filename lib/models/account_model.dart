class Account {
  final String firstName;
  final String? middleName;
  final String lastName;
  final String email;
  final String password;
  final String role;

  Account(
      {required this.firstName,
      this.middleName,
      required this.lastName,
      required this.email,
      required this.password,
      required this.role});

  static List<Account> accounts = [
    Account(
        firstName: "Jerico",
        lastName: "Rito",
        email: "jericorito@gmail.com",
        password: "123",
        role: "admin")
  ];
}
