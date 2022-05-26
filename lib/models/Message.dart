class Message {
  String name;
  String isRead;
  int id;
  String email;
  String phoneNumber;
  String subject;
  String message;
  String attachementLink;
  String is_user_read;

  Message(
      {this.name,
      this.isRead,
      this.id,
      this.email,
      this.phoneNumber,
      this.subject,
      this.message,
      this.attachementLink,
      this.is_user_read});
}