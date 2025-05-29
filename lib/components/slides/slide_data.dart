import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projecto/components/slides/slide_model.dart';

class SlideData {
  Stream<SlideModel> streamSlide({required String code}) {
    return FirebaseFirestore.instance
        .collection('slides')
        .where('code', isEqualTo: code)
        .limit(1)
        .snapshots()
        .map((querySnapshot) {
          if (querySnapshot.docs.isNotEmpty) {
            final data = querySnapshot.docs.first.data();
            return SlideModel.fromJson(data);
          } else {
            return SlideModel();
          }
        })
        .handleError((error) {
          log("ERROR_STREAMING_SLIDES: $error");
        });
  }

  Future<bool> changeSlide({
    required SlideModel slide,
    required num currentSlide,
  }) async {
    try {
      final docRef = FirebaseFirestore.instance
          .collection('slides')
          .doc(slide.id);
      await docRef.update({'currentSlide': currentSlide});
      return true;
    } catch (e) {
      log("ERROR_UPDATING_SLIDE_INDEX: $e");
      return false;
    }
  }
}
