class Homestay {
  String? homestayId;
  String? userId;
  String? homestayName;
  String? homestayDesc;
  String? homestayPrice;
  String? homestayRoomqty;
  String? homestayBedqty;
  String? homestayState;
  String? homestayLocal;
  String? homestayLat;
  String? homestayLng;
  String? homestayDate;

  Homestay(
      {this.homestayId,
      this.userId,
      this.homestayName,
      this.homestayDesc,
      this.homestayPrice,
      this.homestayRoomqty,
      this.homestayBedqty,
      this.homestayState,
      this.homestayLocal,
      this.homestayLat,
      this.homestayLng,
      this.homestayDate});

  Homestay.fromJson(Map<String, dynamic> json) {
    homestayId = json['homestay_id'];
    userId = json['user_id'];
    homestayName = json['homestay_name'];
    homestayDesc = json['homestay_desc'];
    homestayPrice = json['homestay_price'];
    homestayRoomqty = json['homestay_roomqty'];
    homestayBedqty = json['homestay_bedqty'];
    homestayState = json['homestay_state'];
    homestayLocal = json['homestay_local'];
    homestayLat = json['homestay_lat'];
    homestayLng = json['homestay_lng'];
    homestayDate = json['homestay_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['homestay_id'] = this.homestayId;
    data['user_id'] = this.userId;
    data['homestay_name'] = this.homestayName;
    data['homestay_desc'] = this.homestayDesc;
    data['homestay_price'] = this.homestayPrice;
    data['homestay_roomqty'] = this.homestayRoomqty;
    data['homestay_bedqty'] = this.homestayBedqty;
    data['homestay_state'] = this.homestayState;
    data['homestay_local'] = this.homestayLocal;
    data['homestay_lat'] = this.homestayLat;
    data['homestay_lng'] = this.homestayLng;
    data['homestay_date'] = this.homestayDate;
    return data;
  }
}