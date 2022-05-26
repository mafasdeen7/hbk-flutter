class PriceQuote {
  int id;
  String name;
  String is_read;
  String email;
  String country_of_origin;
  String box_weight;
  String weight_type;
  String box_qty;
  String item_description;
  String length;
  String width;
  String height;
  String dimension;
  String contact_number;
  String message;
  String paymentStatus;
  String is_user_read;

  PriceQuote({
    this.id,
    this.name,
    this.is_read,
    this.email,
    this.country_of_origin,
    this.box_weight,
    this.weight_type,
    this.box_qty,
    this.item_description,
    this.length,
    this.width,
    this.height,
    this.dimension,
    this.contact_number,
    this.message,
    this.paymentStatus,
    this.is_user_read,
  });
}
