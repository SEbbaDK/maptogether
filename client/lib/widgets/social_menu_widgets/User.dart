class User {
  String name; //name of user
  int total;
  String pfp;
  String nationality;
  //Eventuelt gem på tasks brugere laver i en task class, her samt et time stamp, vi kan så få
  //weekly/daily score ved bare at tage ting i et specifikt interval


  User(this.name, this.total, this.pfp, this.nationality);
}