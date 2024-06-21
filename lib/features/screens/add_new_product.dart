import 'dart:io';
import 'package:daprot_seller/bloc/add_product_bloc/add_prodcut_bloc.dart';

import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/config/theme/fonts_manager.dart';
import 'package:daprot_seller/domain/model/category.dart';
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
  final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();

  XFile? _pImage1Pic;
  XFile? _pImage2Pic;
  XFile? _pImage3Pic;

  Category? _selectedCategory;
  SubCategory? _selectedSubCategory;

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
                      Row(
                        children: [
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
                          SizedBox(
                            width: 10.w,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 1.5.h,
                              bottom: 3.h,
                            ),
                            child: GestureDetector(
                              onTap: () {
                                final dynamic tooltip = tooltipkey.currentState;
                                tooltip.ensureTooltipVisible();
                              },
                              child: Tooltip(
                                message:
                                    "Reminder! Only genuine products & family-friendly descriptions allowed. Violation may lead to shop removal.",
                                showDuration: const Duration(seconds: 3),
                                padding: EdgeInsets.all(8.sp),
                                triggerMode: TooltipTriggerMode.manual,
                                preferBelow: true,
                                key: tooltipkey,
                                verticalOffset: 48,
                                child: const Icon(Icons.info),
                              ),
                            ),
                          ),
                        ],
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
                            text: _selectedCategory == null &&
                                    _selectedSubCategory == null
                                ? "Select A Category"
                                : '${_selectedCategory!.name.toUpperCase()} - ${_selectedSubCategory!.name.toUpperCase()}',
                            onTap: () {
                              showDialog<Category>(
                                context: context,
                                builder: (context) => _CategoryDialog(
                                  selectedSubCategory: _selectedSubCategory,
                                  selectedCategory: _selectedCategory,
                                  onChanged: (cat, subcat) {
                                    setState(() {
                                      _selectedCategory = cat;
                                      _selectedSubCategory = subcat;
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
                              if (int.parse(value) >
                                  int.parse(originalPriceController.text)) {
                                return "Invalid Discounted Price";
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
                                    _selectedCategory != null &&
                                    _pImage1Pic != null &&
                                    _pImage2Pic != null &&
                                    _pImage3Pic != null &&
                                    int.parse(discountedPriceController.text) <
                                        int.parse(
                                            originalPriceController.text)) {
                                  context.read<ProductBloc>().add(
                                        AddProductEvent(
                                          Product(
                                            name: nameController.text,
                                            subCategory:
                                                _selectedSubCategory!.name,
                                            description:
                                                procutDescripController.text,
                                            category: _selectedCategory!.name,
                                            price: originalPriceController.text,
                                            discountedPrice:
                                                discountedPriceController.text,
                                            photos: [
                                              _pImage1Pic!,
                                              _pImage2Pic!,
                                              _pImage3Pic!,
                                            ],
                                          ),
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
                                } else if (int.parse(
                                        discountedPriceController.text) >
                                    int.parse(originalPriceController.text)) {
                                  customSnackBar(context,
                                      "Invalid Discounted Price", false);
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
  final Function(Category, SubCategory) onChanged;
  final Category? selectedCategory;
  final SubCategory? selectedSubCategory;
  const _CategoryDialog(
      {required this.onChanged,
      required this.selectedCategory,
      required this.selectedSubCategory});
  @override
  __CategoryDialogState createState() => __CategoryDialogState();
}

class __CategoryDialogState extends State<_CategoryDialog> {
  late Category _selectedCategory;
  late SubCategory _selectedSubCategory;
  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.selectedCategory ?? Category.men;
    _selectedSubCategory = widget.selectedSubCategory ?? SubCategory.shirts;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Category'),
      backgroundColor: ColorsManager.offWhiteColor,
      content: SingleChildScrollView(
        child: Column(
          children: [
            // Dropdown for Main Category
            DropdownButton<Category>(
              value: _selectedCategory,
              dropdownColor: Colors.white,
              icon: const Icon(
                Icons.arrow_drop_down_circle_rounded,
                color: ColorsManager.secondaryColor,
              ),
              focusColor: ColorsManager.primaryColor,
              items: Category.values.map((category) {
                return DropdownMenuItem<Category>(
                  value: category,
                  child: SizedBox(
                      width: 50.w, child: Text(category.name.toUpperCase())),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),

            // Conditional rendering of RadioListTile for Subcategory
            if (_selectedCategory
                .subCategories.isNotEmpty) // Check for empty subcategories
              Column(
                children: _selectedCategory.subCategories.map((subCategory) {
                  return RadioListTile<SubCategory>(
                    title: Text(subCategory.name.toUpperCase(),
                        style: Theme.of(context).textTheme.bodyMedium),
                    value: subCategory,
                    groupValue: _selectedSubCategory,
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedSubCategory = value;
                        });
                      }
                    },
                  );
                }).toList(),
              ),
          ],
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
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.white),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            widget.onChanged(_selectedCategory, _selectedSubCategory);
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsManager.secondaryColor,
          ),
          child: const Text(
            'Select',
            style: TextStyle(color: ColorsManager.whiteColor),
          ),
        ),
      ],
    );
  }
}
