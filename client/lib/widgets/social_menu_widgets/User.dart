class User {
  String name; //name of user
  int total;

  //Eventuelt gem på tasks brugere laver i en task class, her samt et time stamp, vi kan så få
  //weekly/daily score ved bare at tage ting i et specifikt interval


  User(String n, int s) {
    name = n;
    total = s;
  }
}