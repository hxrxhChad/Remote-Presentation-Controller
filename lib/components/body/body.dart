// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:projecto/components/slides/slide_cubit.dart';
import 'package:projecto/core/config/color.dart';
import 'package:projecto/core/config/routes.dart';
import 'package:projecto/core/utils/common_methods.dart';
import 'package:projecto/core/utils/common_widgets.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final TextEditingController _pcodeController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _pcodeController.dispose();
    super.dispose();
  }

  void _handleSubmit(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final enteredCode = _pcodeController.text.trim();
      final result = await context.read<SlideCubit>().streamSlideByCode(
        enteredCode,
      );
      debugPrint(result.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SlideCubit, SlideState>(
      listenWhen:
          (previous, current) => previous.streamSlide != current.streamSlide,
      listener: (context, state) {
        if (state.streamSlide == CommonState.success &&
            state.slide.slides.isNotEmpty) {
          Navigator.pushNamed(
            context,
            AppRoutes.slideBody,
            arguments: {"slide": state.slide},
          );
        } else if (state.streamSlide == CommonState.error ||
            (state.streamSlide == CommonState.success &&
                state.slide.slides.isEmpty)) {
          showSnack(
            text: state.error.isNotEmpty ? state.error : "Sorry, no slides",
            backgroundColor: AppColors.red500,
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: Container(
            width: 300.w,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.01),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: Colors.grey.withOpacity(.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonTextFormField(
                    labelText: "Enter your pcode",
                    controller: _pcodeController,
                  ),
                  SizedBox(height: 20.h),
                  BlocBuilder<SlideCubit, SlideState>(
                    buildWhen:
                        (previous, current) =>
                            previous.streamSlide != current.streamSlide,
                    builder: (context, state) {
                      final isLoading =
                          state.streamSlide == CommonState.loading;

                      return SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              isLoading
                                  ? () => showSnack(
                                    text:
                                        "Wait, we are searching for your slide",
                                  )
                                  : () => _handleSubmit(context),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Submit",
                                style: Theme.of(
                                  context,
                                ).textTheme.bodySmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              if (isLoading) ...[
                                SizedBox(width: 20.w),
                                SizedBox(
                                  height: 10.h,
                                  width: 10.h,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
