import 'package:daprot_seller/bloc/auth_bloc/auth_bloc.dart';
import 'package:daprot_seller/bloc/auth_bloc/auth_state.dart';
import 'package:daprot_seller/bloc/location_bloc/user_location_state.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/config/theme/fonts_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class InputLocation extends StatelessWidget {
  const InputLocation({
    super.key,
    required this.locationController,
  });

  final TextEditingController locationController;

  @override
  Widget build(BuildContext context) {
    String? locationText = locationController.text;
    return BlocListener<AppBloc, AppState>(
      listener: (context, state) {
        if (state is LocationLoadingState) {
          locationController.text = 'Loading...';
        }
        if (state is LocationLoadedState) {
          locationController.text = "";
          debugPrint(locationText);
        }
      },
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return SizedBox(
            height: 10.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 80.w,
                  child: TextFormField(
                    keyboardType: TextInputType.streetAddress,
                    controller: locationController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Add the location!';
                      }
                      return null;
                    },
                    style: TextStyle(
                      fontSize: 17.sp,
                    ),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: ColorsManager.primaryColor,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      helperText: " ",
                      hintText: "Press Button to select location",
                      hintStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                fontSize: FontSize.s12,
                                color: ColorsManager.greyColor,
                              ),
                      helperStyle:
                          Theme.of(context).textTheme.bodyMedium!.copyWith(
                                color: Colors.red,
                              ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
                // InkWell(
                //   onTap: () {
                //     context.read<LocationBloc>().add(GetLocationEvent());
                //   },
                //   child: Container(
                //     padding: const EdgeInsets.all(8),
                //     margin: const EdgeInsets.only(bottom: 15),
                //     width: 25.w,
                //     height: 5.h,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(15),
                //       color: ColorsManager.primaryColor,
                //     ),
                //     child: const Row(
                //       children: [
                //         Icon(Icons.location_searching_outlined),
                //         Text(StringManager.detect),
                //       ],
                //     ),
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
