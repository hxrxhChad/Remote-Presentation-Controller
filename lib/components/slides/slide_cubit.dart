import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projecto/components/slides/slide_data.dart';
import 'package:projecto/components/slides/slide_model.dart';
import 'package:projecto/core/utils/common_methods.dart';

part 'slide_state.dart';

class SlideCubit extends Cubit<SlideState> {
  final SlideData _repo;
  SlideCubit({required SlideData repo})
    : _repo = repo,
      super(const SlideState());

  StreamSubscription? _slideSubscription;

  Future<bool> streamSlideByCode(String code) async {
    try {
      emit(
        state.copyWith(code: code, streamSlide: CommonState.loading, error: ''),
      );

      await _slideSubscription?.cancel();

      _slideSubscription = _repo
          .streamSlide(code: code)
          .listen(
            (slide) {
              if (slide.slides.isNotEmpty) {
                emit(
                  state.copyWith(
                    slide: slide,
                    streamSlide: CommonState.success,
                  ),
                );
              } else {
                emit(
                  state.copyWith(
                    slide: const SlideModel(),
                    streamSlide: CommonState.error,
                    error: 'Slide not found',
                  ),
                );
              }
            },
            onError: (error) {
              emit(
                state.copyWith(
                  streamSlide: CommonState.error,
                  error: error.toString(),
                ),
              );
            },
          );

      return true;
    } catch (e) {
      emit(state.copyWith(streamSlide: CommonState.error, error: e.toString()));
      return false;
    }
  }

  Future<bool> changeSlideIndex(SlideModel slide, int index) async {
    emit(state.copyWith(changeSlide: CommonState.loading));

    try {
      final success = await _repo.changeSlide(
        slide: slide,
        currentSlide: index,
      );

      if (success) {
        emit(
          state.copyWith(
            slide: slide.copyWith(currentSlide: index),
            changeSlide: CommonState.success,
          ),
        );
        return true;
      } else {
        emit(
          state.copyWith(
            changeSlide: CommonState.error,
            error: "Failed to update slide",
          ),
        );
        return false;
      }
    } catch (e) {
      emit(state.copyWith(changeSlide: CommonState.error, error: e.toString()));
      return false;
    }
  }

  @override
  Future<void> close() async {
    await _slideSubscription?.cancel();
    return super.close();
  }
}
