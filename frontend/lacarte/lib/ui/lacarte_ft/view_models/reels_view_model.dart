import 'package:flutter/foundation.dart';
import 'package:lacarte/data/model/reel.dart';
import 'package:lacarte/data/repositories/reels_repository.dart';

class ReelsViewModel with ChangeNotifier {
  final ReelsRepository _repository;
  
  List<Reel> _reels = [];
  bool _isLoading = false;

  ReelsViewModel(this._repository);

  List<Reel> get reels => _reels;
  bool get isLoading => _isLoading;

  Future<void> fetchReels() async {
    if (_reels.isNotEmpty) return;

    _isLoading = true;
    notifyListeners();

    _reels = await _repository.fetchReels();

    _isLoading = false;
    notifyListeners();
  }
}
