import '../models/stories_model.dart';
import '../models/userModel.dart';

final List<Story> allStories = [
  Story(
      url:
          'https://images.unsplash.com/photo-1534103362078-d07e750bd0c4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=634&q=80',
      media: MediaType.image,
      duration: const Duration(seconds: 10),
      user: User(
        name: 'John',
        profileImageUrl: 'https://wallpapercave.com/wp/AYWg3iu.jpg',
      )),
  Story(
      url: 'https://picsum.photos/500',
      media: MediaType.image,
      duration: const Duration(seconds: 10),
      user: User(
        name: 'Harsh',
        profileImageUrl: 'https://wallpapercave.com/wp/AYWg3iu.jpg',
      )),
  Story(
      url: 'https://source.unsplash.com/random',
      media: MediaType.image,
      duration: const Duration(seconds: 10),
      user: User(
        name: 'Cipher',
        profileImageUrl: 'https://wallpapercave.com/wp/AYWg3iu.jpg',
      )),
  Story(
      url: 'https://source.unsplash.com/user/erondu',
      media: MediaType.image,
      duration: const Duration(seconds: 10),
      user: User(
        name: 'Viper',
        profileImageUrl: 'https://wallpapercave.com/wp/AYWg3iu.jpg',
      )),
];
