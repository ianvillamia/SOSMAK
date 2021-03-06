class PlaceDetail {
  String icon;
  String id;
  String name;
  String rating;
  String vicinity;

  String formattedAddress;
  String internationalPhoneNumber;
  List<String> weekdaytext;
  String url;

  PlaceDetail(this.id, this.name, this.icon, this.rating, this.vicinity,
      [this.formattedAddress, this.internationalPhoneNumber, this.weekdaytext]);
}
