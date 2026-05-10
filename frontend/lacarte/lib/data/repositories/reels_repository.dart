import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:lacarte/data/model/reel.dart';

class ReelsRepository {
  // TODO: Add your Pexels API Key here
  final String _apiKey =
      'k8t008etS44xCRqKjg4SL0WZGUgbyUVjBiGn8sEeNoYofsbPf4msVITb';

  Future<List<Reel>> fetchReels() async {
    if (_apiKey.isEmpty) {
      return _getMockReels();
    } else {
      try {
        final response = await http.get(
          Uri.parse(
            'https://api.pexels.com/videos/search?query=cooking&orientation=portrait&per_page=10',
          ),
          headers: {'Authorization': _apiKey},
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final List videos = data['videos'];

          return videos.map((v) {
            final file = v['video_files'].firstWhere(
              (f) => f['quality'] == 'sd' || f['quality'] == 'hd',
              orElse: () => v['video_files'][0],
            );

            return Reel(
              id: v['id'].toString(),
              videoUrl: file['link'],
              thumbnailUrl: v['image'],
              userName: v['user']['name'],
              title: 'Amazing Cooking by ${v['user']['name']}',
            );
          }).toList();
        } else {
          debugPrint('Pexels API Error: ${response.statusCode}');
          return _getMockReels();
        }
      } catch (e) {
        debugPrint('Fetch Error: $e');
        return _getMockReels();
      }
    }
  }

  List<Reel> _getMockReels() {
    return [
      Reel(
        id: '1',
        videoUrl:
            'https://assets.mixkit.co/videos/preview/mixkit-frying-diced-meat-and-vegetables-in-a-pan-43032-large.mp4',
        thumbnailUrl:
            'https://images.pexels.com/photos/2233729/pexels-photo-2233729.jpeg?w=500',
        userName: 'Chef Gordon',
        title: 'Perfect Stir Fry',
      ),
      Reel(
        id: '2',
        videoUrl:
            'https://assets.mixkit.co/videos/preview/mixkit-pouring-fresh-milk-into-a-glass-of-coffee-43026-large.mp4',
        thumbnailUrl:
            'https://images.pexels.com/photos/302899/pexels-photo-302899.jpeg?w=500',
        userName: 'Barista Jane',
        title: 'Morning Brew',
      ),
      Reel(
        id: '3',
        videoUrl:
            'https://assets.mixkit.co/videos/preview/mixkit-chopping-vegetables-on-a-wooden-board-43031-large.mp4',
        thumbnailUrl:
            'https://images.pexels.com/photos/1153369/pexels-photo-1153369.jpeg?w=500',
        userName: 'Healthy Eats',
        title: 'Fresh Salad Prep',
      ),
    ];
  }
}
