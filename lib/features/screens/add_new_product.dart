import 'dart:io';
import 'package:daprot_seller/bloc/add_product_bloc/add_prodcut_bloc.dart';

import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/config/theme/fonts_manager.dart';
import 'package:daprot_seller/domain/model/product_model.dart';
import 'package:daprot_seller/features/widgets/common_widgets/custom_form_field.dart';
import 'package:daprot_seller/features/widgets/common_widgets/delevated_button.dart';
import 'package:daprot_seller/features/widgets/common_widgets/lable_text.dart';
import 'package:daprot_seller/features/widgets/common_widgets/loading_dailog.dart';
import 'package:daprot_seller/features/widgets/common_widgets/snack_bar.dart';
import 'package:daprot_seller/features/widgets/form_widgets/toggle_button.dart';
import 'package:daprot_seller/features/widgets/form_widgets/input_brand_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class AddNewProdcut extends StatefulWidget {
  const AddNewProdcut({super.key});

  @override
  State<AddNewProdcut> createState() => AddNewProdcutState();
}

class AddNewProdcutState extends State<AddNewProdcut> {
  TextEditingController nameController = TextEditingController();
  TextEditingController procutDescripController = TextEditingController();
  TextEditingController originalPriceController = TextEditingController();
  TextEditingController discountedPriceController = TextEditingController();

  GlobalKey<FormState> fcFormKey = GlobalKey<FormState>();

  XFile? _pImage1Pic;
  XFile? _pImage2Pic;
  XFile? _pImage3Pic;

  Category? _selectedCategory;

  bool isLoading = false;

  Future<void> _pImage1(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 25,
    );
    if (pickedImage != null) {
      setState(() {
        _pImage1Pic = pickedImage;
      });
    }
  }

  Future<void> _pImage2(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 25,
    );
    if (pickedImage != null) {
      setState(() {
        _pImage2Pic = pickedImage;
      });
    }
  }

  Future<void> _pImage3(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 25,
    );
    if (pickedImage != null) {
      setState(() {
        _pImage3Pic = pickedImage;
      });
    }
  }

  Widget returnLabel(String label) {
    return Container(
      padding: const EdgeInsets.only(left: 20.0),
      alignment: Alignment.centerLeft,
      child: Text(
        " $label",
        style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
      ),
    );
  }

  void showLoading() {
    LoadingDialog.showLoadingDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is LoadingState) {
          setState(() {
            isLoading = true;
          });
          showLoading();
        }
        if (state is SuccessState) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
        }
        if (state is AddProductState) {
          if (state.message.contains('successfully')) {
            setState(() {
              isLoading = false;
            });
            Navigator.pop(context);
            Navigator.pop(context);
            customSnackBar(context, state.message, true);
          } else {
            customSnackBar(context, state.message, false);
          }
        }
      },
      child: Scaffold(
        backgroundColor: ColorsManager.offWhiteColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(
            "Add Latest Product",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontSize: 16.sp, color: ColorsManager.whiteColor),
          ),
        ),
        body: Form(
          key: fcFormKey,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Card(
                margin: EdgeInsets.only(left: 3.w, right: 3.w, top: 5.h),
                surfaceTintColor: ColorsManager.whiteColor,
                elevation: 5,
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: ColorsManager.lightGrey),
                    borderRadius: BorderRadius.circular(2.w)),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// TITLE
                      Padding(
                        padding: EdgeInsets.only(
                          top: 1.5.h,
                          bottom: 3.h,
                        ),
                        child: Text(
                          'Add New Product'.toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(fontSize: 14.sp),
                        ),
                      ),

                      Column(
                        children: [
                          const ReturnLabel(label: "Product Images"),
                          _pImage1Pic != null
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        _pImage1(ImageSource.gallery);
                                      },
                                      child: SizedBox(
                                        width: 80.w,
                                        height: 20.h,
                                        child: Image.file(
                                          File(_pImage1Pic!.path),
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: InkWell(
                                    onTap: () {
                                      _pImage1(ImageSource.gallery);
                                    },
                                    child: const InputBrandLogoUi(),
                                  ),
                                )
                        ],
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _pImage2Pic != null
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        _pImage2(ImageSource.gallery);
                                      },
                                      child: Image.file(
                                        File(_pImage2Pic!.path),
                                        width: 35.w,
                                        height: 50.w,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: InkWell(
                                    onTap: () {
                                      _pImage2(ImageSource.gallery);
                                    },
                                    child: const InputProImaUi(),
                                  ),
                                ),
                          _pImage3Pic != null
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        _pImage3(ImageSource.gallery);
                                      },
                                      child: Image.file(
                                        File(_pImage3Pic!.path),
                                        width: 35.w,
                                        height: 50.w,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: InkWell(
                                    onTap: () {
                                      _pImage3(ImageSource.gallery);
                                    },
                                    child: const InputProImaUi(),
                                  ),
                                ),
                        ],
                      ),

                      SizedBox(
                        height: 4.h,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 1.5.h,
                          bottom: 3.h,
                        ),
                        child: Text(
                          "Product Details",
                          style: TextStyle(
                              fontWeight: FontWeightManager.semiBold,
                              fontSize: 14.sp),
                        ),
                      ),

                      /// NAME
                      Column(
                        children: [
                          const ReturnLabel(label: "Name"),
                          CustomFormField(
                            controller: nameController,
                            hintText: 'Type here',
                            keyboardType: TextInputType.name,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter name of the Product';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),

                      /// MOBILE NUMBER
                      Padding(
                        padding: EdgeInsets.only(bottom: 2.h),
                        child: Column(
                          children: [
                            const ReturnLabel(label: "Description"),
                            DescriptionFormField(
                              height: 20.h,
                              width: 90.h,
                              controller: procutDescripController,
                              hintText: "Enter the description",
                            )
                          ],
                        ),
                      ),

                      /// Category field
                      Column(
                        children: [
                          const ReturnLabel(label: 'Select the category'),
                          DelevatedButton(
                            text: _selectedCategory == null
                                ? "Select A Category"
                                : _selectedCategory!.name.toUpperCase(),
                            onTap: () {
                              showDialog<Category>(
                                context: context,
                                builder: (context) => _CategoryDialog(
                                  selectedCategory: _selectedCategory,
                                  onChanged: (cat) {
                                    setState(() {
                                      _selectedCategory = cat;
                                    });
                                  },
                                ),
                              );
                            },
                          )
                        ],
                      ),

                      ///Price.
                      Column(
                        children: [
                          const ReturnLabel(label: "Price"),
                          CustomFormField(
                            controller: originalPriceController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter the price';
                              }

                              return null;
                            },
                            keyboardType: TextInputType.number,
                            hintText: 'Type here',
                          ),
                        ],
                      ),

                      Column(
                        children: [
                          const ReturnLabel(label: "Discounted Price"),
                          CustomFormField(
                            controller: discountedPriceController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter the Discounted Price';
                              }

                              return null;
                            },
                            keyboardType: TextInputType.number,
                            hintText: 'Type here',
                          ),
                        ],
                      ),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ToggleButton(
                              back: "Cancel",
                              next: "Add",
                              onPressedBack: () {
                                Navigator.pop(context);
                              },
                              onPressedNext: () {
                                if (fcFormKey.currentState!.validate() &&
                                    procutDescripController.text.isNotEmpty &&
                                    _pImage1Pic != null &&
                                    _pImage2Pic != null &&
                                    _pImage3Pic != null) {
                                  context.read<ProductBloc>().add(
                                        AddProductEvent(
                                          Product(
                                              name: nameController.text,
                                              description:
                                                  procutDescripController.text,
                                              category: _selectedCategory!.name,
                                              price:
                                                  originalPriceController.text,
                                              discountedPrice:
                                                  discountedPriceController
                                                      .text,
                                              photos: [
                                                _pImage1Pic!,
                                                _pImage2Pic!,
                                                _pImage3Pic!,
                                              ]),
                                        ),
                                      );
                                } else if (_pImage2Pic == null) {
                                  customSnackBar(
                                      context,
                                      "Please upload the Product Images!",
                                      false);
                                } else if (procutDescripController
                                    .text.isEmpty) {
                                  customSnackBar(
                                      context,
                                      "Please enter product description",
                                      false);
                                } else if (procutDescripController
                                    .text.length.isNegative) {
                                  customSnackBar(context, "Price", false);
                                } else if (_selectedCategory == null) {
                                  customSnackBar(
                                      context, "Select category", false);
                                }
                              },
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryDialog extends StatefulWidget {
  final ValueChanged<Category> onChanged;
  final Category? selectedCategory;
  const _CategoryDialog(
      {required this.onChanged, required this.selectedCategory});
  @override
  __CategoryDialogState createState() => __CategoryDialogState();
}

class __CategoryDialogState extends State<_CategoryDialog> {
  late Category _selectedCat;

  @override
  void initState() {
    super.initState();
    _selectedCat = widget.selectedCategory ?? Category.fashion;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Order Status'),
      content: SingleChildScrollView(
        child: Column(
          children: Category.values.map((category) {
            return RadioListTile<Category>(
              title: Text(
                category.name.toUpperCase(),
                style: Theme.of(context)
                    .textTheme
                    .bodySmall!
                    .copyWith(color: ColorsManager.blackColor),
              ),
              value: category,
              groupValue: _selectedCat,
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCat = value;
                  });
                }
              },
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsManager.lightRedColor,
          ),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onChanged(_selectedCat);
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsManager.accentColor,
          ),
          child: const Text('Select'),
        ),
      ],
    );
  }
}
