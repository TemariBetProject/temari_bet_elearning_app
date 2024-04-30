import 'package:flutter/material.dart';
import 'package:temari_bet_elearning_app/screens/video_player/video_player_screen.dart';
import 'package:temari_bet_elearning_app/config/app_config.dart';

class SearchResults extends StatelessWidget {
  final List<dynamic> searchResults;
  const SearchResults({Key? key, required this.searchResults})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        var result = searchResults[index];
        String imageUrl = AppConfig.imageUrl + result['image'];
        return ListTile(
          leading:
              Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover),
          title: Text(result['Title']),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VideoPlayerScreen(
                  videoId: result['_id'],
                  videoTitle: result['Title'],
                  videoDescription: result['Description'],
                  videoUrl: result['urlLink'],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
