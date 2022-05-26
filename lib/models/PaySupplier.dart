class PaySupplier {
  int id;
  String amount;
  String beneficiary_name;
  String beneficiary_address;
  String bank_name;
  String bank_address;
  String account_number;
  String swift_code;
  String country;
  String name;
  String email;
  String deposit_slip;
  String paymentStatus;

  PaySupplier({
    this.id,
    this.amount,
    this.beneficiary_name,
    this.beneficiary_address,
    this.bank_name,
    this.bank_address,
    this.account_number,
    this.swift_code,
    this.country,
    this.name,
    this.email,
    this.deposit_slip,
    this.paymentStatus
  });
}
