import 'package:daprot_seller/bloc/location_bloc/user_locaion_events.dart';
import 'package:daprot_seller/bloc/location_bloc/user_location_bloc.dart';
import 'package:daprot_seller/bloc/location_bloc/user_location_state.dart';
import 'package:daprot_seller/bloc/sh_bloc/sh_bloc.dart';
import 'package:daprot_seller/bloc/sh_bloc/sh_event.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/config/theme/fonts_manager.dart';
import 'package:daprot_seller/features/widgets/common_widgets/snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class InputLocation extends StatefulWidget {
  InputLocation({
    super.key,
    required this.locationController,
  });

  final TextEditingController locationController;
  @override
  State<InputLocation> createState() => _InputLocationState();
}

class _InputLocationState extends State<InputLocation> {
  @override
  Widget build(BuildContext context) {
    String? locationText = widget.locationController.text;
    return BlocListener<LocationBloc, LocationState>(
      listener: (context, state) {
        if (state is LocationLoadingState) {
          widget.locationController.text = 'Loading...';
        }
        if (state is LocationLoadedState) {
          widget.locationController.text = state.placeName;

          BlocProvider.of<ShBloc>(context).add(ShLocationEvent(
              latitude: state.latitude, longitude: state.longitude));
          debugPrint(locationText);
        }
        if (state is LocationErrorState) {
          widget.locationController.text = '';
          customSnackBar(context, 'Something Went Wrong', false);
        }
      },
      child: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          return SizedBox(
            height: 10.h,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 60.w,
                  height: 30.h,
                  child: TextFormField(
                    keyboardType: TextInputType.streetAddress,
                    readOnly: true,
                    controller: widget.locationController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Add the location!';
                      }
                      return null;
                    },
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontSize: 9.sp,
                          overflow: TextOverflow.ellipsis,
                        ),
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: ColorsManager.primaryColor,
                          width: 1.w,
                        ),
                        borderRadius: BorderRadius.circular(6.sp),
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.sp),
                        ),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.read<LocationBloc>().add(GetLocationEvent());
                  },
                  child: Container(
                    padding: EdgeInsets.all(2.sp),
                    margin: EdgeInsets.only(bottom: 20.sp),
                    width: 25.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.sp),
                      color: ColorsManager.primaryColor,
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.location_searching_outlined,
                          color: Colors.white,
                        ),
                        Text(
                          'Detect',
                          style: TextStyle(color: Colors.white),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
