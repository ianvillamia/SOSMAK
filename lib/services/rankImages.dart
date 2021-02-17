class RankImage {
  static String show(String rank) {
    switch (rank) {
      case "Director General":
        return "assets/ranks/1.png";
        break;

      case "Deputy Director General":
        return "assets/ranks/2.png";
        break;

      case "Director":
        return "assets/ranks/3.png";
        break;

      case "Chief Superintendent":
        return "assets/ranks/4.png";
        break;

      case "Senior Superintendent":
        return "assets/ranks/5.png";
        break;

      case "Superintendent":
        return "assets/ranks/6.png";
        break;

      case "Chief Inspector":
        return "assets/ranks/7.png";
        break;

      case "Senior Inspector":
        return "assets/ranks/8.png";
        break;

      case "Inspector":
        return "assets/ranks/9.png";
        break;

      case "Senior Police Officer IV":
        return "assets/ranks/10.png";
        break;

      case "Senior Police Officer III":
        return "assets/ranks/11.png";
        break;

      case "Senior Police Officer II":
        return "assets/ranks/12.png";
        break;

      case "Senior Police Officer I":
        return "assets/ranks/13.png";
        break;

      case "Police Officer III":
        return "assets/ranks/14.png";
        break;

      case "Police Officer II":
        return "assets/ranks/15.png";
        break;

      case "Police Officer I":
        return "assets/ranks/16.png";
        break;

      default:
        return "No image.";
        break;
    }
  }
}
