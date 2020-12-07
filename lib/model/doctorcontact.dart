class DoctorContact {
  int id;
  String firstName;
  String lastName;
  String profilePic;
  bool favorite;
  String primaryContactNo;
  String rating;
  String emailAddress;
  String qualification;
  String description;
  String specialization;
  String languagesKnown;
  String dob;

  DoctorContact(
      {this.id,
        this.firstName,
        this.lastName,
        this.profilePic,
        this.favorite,
        this.primaryContactNo,
        this.rating,
        this.emailAddress,
        this.qualification,
        this.description,
        this.specialization,
        this.languagesKnown});

  DoctorContact.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profilePic = json['profile_pic'];
    favorite = json['favorite'];
    primaryContactNo = json['primary_contact_no'];
    rating = json['rating'];
    emailAddress = json['email_address'];
    qualification = json['qualification'];
    description = json['description'];
    specialization = json['specialization'];
    languagesKnown = json['languagesKnown'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['profile_pic'] = this.profilePic;
    data['favorite'] = this.favorite;
    data['primary_contact_no'] = this.primaryContactNo;
    data['rating'] = this.rating;
    data['email_address'] = this.emailAddress;
    data['qualification'] = this.qualification;
    data['description'] = this.description;
    data['specialization'] = this.specialization;
    data['languagesKnown'] = this.languagesKnown;
    data['dob'] = this.dob;
    return data;
  }
}