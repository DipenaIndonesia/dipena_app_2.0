class SuggestModel {
  final String icon;
  final String name;
  final String username;
  final String bio;

  SuggestModel({
    this.icon,
    this.name,
    this.username,
    this.bio,
  });
}

List<SuggestModel> suggestData = [
  new SuggestModel(
    icon: "assets/img/icon_one.jpg",
    name: "Sasha Witt",
    username: "@sasha",
    bio: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.",
  ),
  new SuggestModel(
    icon: "assets/img/icon_two.png",
    name: "Fariha Morgan",
    username: "@fariha",
    bio: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.",
  ),
  new SuggestModel(
    icon: "assets/img/icon_three.jpg",
    name: "Yvie Conrad",
    username: "@yvie",
    bio: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.",
  ),
  new SuggestModel(
    icon: "assets/img/icon_four.jpg",
    name: "Dahlia Bush",
    username: "@dahlia",
    bio: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt.",
  ),
];
