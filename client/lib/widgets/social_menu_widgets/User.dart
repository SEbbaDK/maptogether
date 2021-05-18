class UserTest {
  String name; //name of user
  int total;
  int weekly;
  int daily;
  String pfp;
  String nationality;
  //Eventuelt gem på tasks brugere laver i en task class, her samt et time stamp, vi kan så få
  //weekly/daily score ved bare at tage ting i et specifikt interval


  UserTest(this.name, this.total, this.weekly, this.daily, this.pfp, this.nationality);
}