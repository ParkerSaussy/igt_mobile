import 'package:lesgo/master/general_utils/images_path.dart';

class SliderModel {
  String image;
  String title;
  String description;

  // Constructor for variables
  SliderModel(
      {required this.title, required this.description, required this.image});

  void setImage(String getImage) {
    image = getImage;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDescription(String getDescription) {
    description = getDescription;
  }

  String getImage() {
    return image;
  }

  String getTitle() {
    return title;
  }

  String getDescription() {
    return description;
  }
}

// List created
List<SliderModel> getSlides() {
  List<SliderModel> slides = <SliderModel>[];

  SliderModel sliderModel = SliderModel(
      title: "Who's In And...... When?",
      description: "We'll Help You Get the Maximum Guests at Your Event.",
      image: ImagesPath.onBoarding00);
  slides.add(sliderModel);

  sliderModel = SliderModel(
      title: "Who's In And...... When?",
      description: "We'll Help You Get the Maximum Guests at Your Event.",
      image: ImagesPath.onBoarding01);
  slides.add(sliderModel);

  sliderModel = SliderModel(
      title: "Who's In And...... When?",
      description: "We'll Help You Get the Maximum Guests at Your Event.",
      image: ImagesPath.onBoarding02);
  slides.add(sliderModel);

  return slides;
}
