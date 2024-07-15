
class ProfileOption {
  String name;
  String actionType;
  bool isSelected = false;

  ProfileOption(this.name, {this.actionType,this.isSelected});
}
class UploadOption {
  String name;
  bool isSelected = false;

  UploadOption(this.name, {this.isSelected});
}

class ListOfItems{

  List listOfProfile =List<ProfileOption>();
  List listOfUpload =List<UploadOption>();

  ListOfItems() {
    populateProfile();
    populateUpload();
  }

  void populateProfile() {
    var profile1 = ProfileOption("My Post",actionType : "like", isSelected: true);
    var profile2 = ProfileOption("Like", actionType : "like",isSelected: false);
    var profile3 = ProfileOption("Most Share",actionType : "favorite", isSelected: false);
    var profile4 = ProfileOption("Comment", actionType : "download",isSelected: false);


    listOfProfile.add(profile1);
    listOfProfile.add(profile2);
    listOfProfile.add(profile3);
    listOfProfile.add(profile4);
  }

  void populateUpload() {
    var image = UploadOption("Images & Album", isSelected: true);
    var video = UploadOption("Video", isSelected: false);
    var Text = UploadOption("Rich Text", isSelected: false);
    var Article = UploadOption("Web Link", isSelected: false);

    listOfUpload.add(image);
    listOfUpload.add(video);
    listOfUpload.add(Text);
    listOfUpload.add(Article);

  }

  static List listOfGenres = [
    {"name" : "Genres" , "selected" : true, },
    {"name" : "All" , "selected" : true, },
    {"name" : "Science Fiction" , "selected" : false, },
    {"name" : "Mystery" , "selected" : false, },
    {"name" : "Horror" , "selected" : false, },
    {"name" : "Cartoon" , "selected" : false, },
    {"name" : "Photography" , "selected" : false, },
    {"name" : "Art" , "selected" : false, },
    {"name" : "Music" , "selected" : false, },
    {"name" : "Sport" , "selected" : false, },
    {"name" : "Movies" , "selected" : false, },
    {"name" : "Technology" , "selected" : false, },
    {"name" : "Places" , "selected" : false, },
    {"name" : "Children" , "selected" : false, },
    {"name" : "Friends" , "selected" : false, },
    {"name" : "Entertainment" , "selected" : false, },
  ];

  /// list of fonts used in the app..
  static  List<String> listOfTextFonts = ["Acme", "Arapey", "CormorantGaramond", "EbGaramond", "JosefinSans", "KaushanScript", "LibreBaskerville",
    "Lobster", "Lora", "Lusitana", "NotoSerif", "PTSerif", "Quicksand", "Satisfy", "SawarabiMincho", "SpecialElite", "Vollkorn"];

}