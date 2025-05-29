part of 'slide_cubit.dart';

class SlideState {
  final String code;
  final SlideModel slide;
  final String error;
  final CommonState streamSlide;
  final CommonState changeSlide;

  const SlideState({
    this.code = '',
    this.slide = const SlideModel(),
    this.error = '',
    this.streamSlide = CommonState.initial,
    this.changeSlide = CommonState.initial,
  });

  SlideState copyWith({
    String? code,
    SlideModel? slide,
    String? error,
    CommonState? streamSlide,
    CommonState? changeSlide,
  }) {
    return SlideState(
      code: code ?? this.code,
      slide: slide ?? this.slide,
      error: error ?? this.error,
      streamSlide: streamSlide ?? this.streamSlide,
      changeSlide: changeSlide ?? this.changeSlide,
    );
  }
}
