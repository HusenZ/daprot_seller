import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gozip_seller/bloc/location_bloc/user_locaion_events.dart';
import 'package:gozip_seller/bloc/location_bloc/user_location_bloc.dart';
import 'package:gozip_seller/bloc/location_bloc/user_location_state.dart';
import 'package:gozip_seller/config/theme/colors_manager.dart';
import 'package:gozip_seller/features/widgets/common_widgets/custom_form_field.dart';
import 'package:gozip_seller/features/widgets/common_widgets/delevated_button.dart';
import 'package:gozip_seller/features/widgets/common_widgets/i_button.dart';
import 'package:gozip_seller/features/widgets/common_widgets/lable_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class InputLocation extends StatefulWidget {
  const InputLocation({
    super.key,
    required this.locationController,
    required this.locality,
  });

  final TextEditingController locationController;
  final TextEditingController locality;

  @override
  State<InputLocation> createState() => _InputLocationState();
}

class _InputLocationState extends State<InputLocation> {
  String selectedLocality = '';
  final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();
  final LocationBloc locationBloc = LocationBloc();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      height: 30.h,
      child: Column(
        children: [
          Row(
            children: [
              const ReturnLabel(label: 'Select Locality'),
              SizedBox(
                width: 5.w,
              ),
              IButton(
                tooltipkey: tooltipkey,
                message:
                    "This address will be used to place your shop on our Daprot Shopping and will be shared with users.",
              ),
            ],
          ),
          Column(
            children: [
              DelevatedButton(
                onTap: () {
                  context.read<LocationBloc>().add(GetLocationEvent());
                },
                text: "Get The Current Location",
              ),
              BlocBuilder<LocationBloc, LocationState>(
                builder: (context, state) {
                  if (state is LocationLoadingState) {
                    return SizedBox(
                      height: 2.h,
                      child: const CircularProgressIndicator(
                        color: ColorsManager.primaryColor,
                      ),
                    );
                  }
                  if (state is LocationLoadedState) {
                    selectedLocality = state.placeName;
                    widget.locality.text = state.placeName;
                    widget.locationController.text = selectedLocality;
                    print("SelectedLocality---------> $selectedLocality");
                  }
                  return Text(
                    selectedLocality,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                        ),
                  );
                },
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          const ReturnLabel(label: 'Shop Address'),
          CustomFormField(
            hintText: 'Address',
            controller: widget.locationController,
          ),
        ],
      ),
    );
  }

  void _showLocalityBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => _buildLocalityList(),
    );
  }

  Widget _buildLocalityList() {
    // Replace with your actual list of localities
    List<String> localities = [
      "Belagavi",
    ];

    return SizedBox(
      height:
          MediaQuery.of(context).size.height * 0.3, // Set a reasonable height
      child: ListView.builder(
        itemCount: localities.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ListTile(
                title: Text(
                  localities[index],
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: ColorsManager.primaryColor,
                      fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  setState(() {
                    selectedLocality = localities[index];
                    widget.locality.text = localities[index];
                  });
                  Navigator.pop(context); // Close the bottom sheet
                },
                style: ListTileStyle.list,
              ),
              Padding(
                padding: EdgeInsets.all(8.sp),
                child: Center(
                  child: RichText(
                    text: const TextSpan(
                      text:
                          "Heads Up! Daprot Shopping is currently live in Belagavi only.",
                      style: TextStyle(color: ColorsManager.accentColor),
                    ),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
