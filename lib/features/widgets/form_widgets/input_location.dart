import 'package:gozip_seller/config/theme/colors_manager.dart';
import 'package:gozip_seller/features/widgets/common_widgets/custom_form_field.dart';
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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100.w,
      height: 25.8.h,
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
          InkWell(
            onTap: () => _showLocalityBottomSheet(context),
            child: Row(
              children: [
                Card(
                  child: Text(
                    selectedLocality.isEmpty
                        ? "Select Your Locality"
                        : selectedLocality,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          overflow: TextOverflow.ellipsis,
                        ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_drop_down_circle),
                  onPressed: () => _showLocalityBottomSheet(context),
                ),
              ],
            ),
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
