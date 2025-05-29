// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:projecto/components/slides/slide_cubit.dart';
import 'package:projecto/components/slides/slide_model.dart';

class SlideBody extends StatefulWidget {
  final SlideModel slide;
  const SlideBody({super.key, required this.slide});

  @override
  State<SlideBody> createState() => _SlideBodyState();
}

class _SlideBodyState extends State<SlideBody> {
  late PageController _pageController;

  bool get _isPhone => MediaQuery.of(context).size.width < 600;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
    }
  }

  @override
  void dispose() {
    if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage({required int index, required SlideState state}) async {
    // _pageController.animateToPage(
    //   index,
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeInOut,
    // );
    final result = await context.read<SlideCubit>().changeSlideIndex(
      state.slide,
      index,
    );
    log(result.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isPhone = _isPhone;

    return Scaffold(
      body: BlocBuilder<SlideCubit, SlideState>(
        builder: (context, state) {
          final slides = state.slide.slides;
          final currentPage = state.slide.currentSlide.toInt();
          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: slides.length,

                itemBuilder: (context, index) {
                  final slideUrl = slides[state.slide.currentSlide.toInt()];
                  return _image(slideUrl);
                },
              ),
              Positioned(
                bottom: 20.h,
                right: isPhone ? 0 : 20.h,
                left: isPhone ? 0 : null,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (currentPage > 0) ...[
                              IconButton(
                                onPressed:
                                    () => _goToPage(
                                      index: currentPage - 1,
                                      state: state,
                                    ),
                                icon: const Icon(
                                  Iconsax.arrow_left_2,
                                  size: 28,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            if (currentPage < state.slide.slides.length - 1)
                              IconButton(
                                onPressed:
                                    () => _goToPage(
                                      index: currentPage + 1,
                                      state: state,
                                    ),
                                icon: const Icon(
                                  Iconsax.arrow_right_3,
                                  size: 28,
                                  color: Colors.white,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Image _image(String slideUrl) {
    return Image.network(
      slideUrl,
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value:
                progress.expectedTotalBytes != null
                    ? progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes!
                    : null,
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Icon(Icons.broken_image, size: 50, color: Colors.grey),
        );
      },
    );
  }
}
