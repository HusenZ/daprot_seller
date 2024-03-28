import 'dart:io';

import 'package:daprot_seller/bloc/add_product_bloc/add_prodcut_bloc.dart';
import 'package:daprot_seller/config/theme/colors_manager.dart';
import 'package:daprot_seller/config/theme/fonts_manager.dart';
import 'package:daprot_seller/domain/add_product_repo.dart';
import 'package:daprot_seller/domain/model/product_model.dart';
import 'package:daprot_seller/features/screens/add_new_product.dart';
import 'package:daprot_seller/features/widgets/common_widgets/custom_form_field.dart';
import 'package:daprot_seller/features/widgets/common_widgets/delevated_button.dart';
import 'package:daprot_seller/features/widgets/common_widgets/lable_text.dart';
import 'package:daprot_seller/features/widgets/common_widgets/loading_dailog.dart';
import 'package:daprot_seller/features/widgets/common_widgets/snack_bar.dart';
import 'package:daprot_seller/features/widgets/form_widgets/toggle_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

class ProductScreen extends StatefulWidget {
  final ProductFromDB product;
  const ProductScreen({super.key, required this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController procutDescripController = TextEditingController();
  TextEditingController originalPriceController = TextEditingController();
  TextEditingController discountedPriceController = TextEditingController();

  GlobalKey<FormState> fcFormKey = GlobalKey<FormState>();

  XFile? _pImage1Pic;
  XFile? _pImage2Pic;
  XFile? _pImage3Pic;

  Category _selectedCategory = Category.men;

  bool isLoading = false;

  bool isUpdate = false;

  @override
  void initState() {
    super.initState();

    nameController.text = widget.product.name;
    procutDescripController.text = widget.product.description;
    originalPriceController.text = widget.product.price;
    discountedPriceController.text = widget.product.discountedPrice;
    _selectedCategory = Category.values
        .firstWhere((cat) => cat.name == widget.product.category);
  }

  Future<void> _pImage1(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _pImage1Pic = pickedImage;
      });
    }
  }

  Future<void> _pImage2(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _pImage2Pic = pickedImage;
      });
    }
  }

  Future<void> _pImage3(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
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

  FocusNode inputNode = FocusNode();
// to open keyboard call this function;
  void openKeyboard() {
    FocusScope.of(context).requestFocus(inputNode);
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
        if (state is DeleteLoadingState) {
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
        if (state is DeleteSuccessState) {
          setState(() {
            isLoading = false;
          });
          Navigator.pop(context);
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
          backgroundColor: ColorsManager.lightGreyColor,
          actions: [
            Visibility(
              visible: !isUpdate,
              child: ElevatedButton(
                  onPressed: () {
                    if (isUpdate) {
                      setState(() {
                        isUpdate = false;
                      });
                    } else {
                      setState(() {
                        isUpdate = true;
                      });
                      openKeyboard();
                    }
                  },
                  child: const Text("Update")),
            )
          ],
          title: Text(widget.product.name),
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
                      Column(
                        children: [
                          const ReturnLabel(label: "Product Images"),
                          isUpdate && _pImage1Pic != null
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
                                    child: Image.network(
                                      widget.product.photos[0],
                                      width: 35.w,
                                      height: 50.w,
                                      fit: BoxFit.fill,
                                    ),
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
                          isUpdate && _pImage2Pic != null
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
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        _pImage2(ImageSource.gallery);
                                      },
                                      child: Image.network(
                                        widget.product.photos[1],
                                        width: 35.w,
                                        height: 50.w,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                          isUpdate && _pImage3Pic != null
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
                                    child: Image.network(
                                      widget.product.photos[2],
                                      width: 35.w,
                                      height: 50.w,
                                      fit: BoxFit.fill,
                                    ),
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
                              fontSize: 16.sp),
                        ),
                      ),

                      /// NAME
                      Column(
                        children: [
                          const ReturnLabel(label: "Name"),
                          CustomFormField(
                            autofocus: isUpdate,
                            focusNode: inputNode,
                            readOnly: !isUpdate,
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

                      /// Dropdown field
                      Column(
                        children: [
                          const ReturnLabel(label: 'Select the category'),
                          DropdownButton(
                            value: _selectedCategory,
                            items: Category.values
                                .map(
                                  (category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(
                                      category.name.toUpperCase(),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                _selectedCategory = value;
                              });
                            },
                          ),
                        ],
                      ),

                      ///Price.
                      Column(
                        children: [
                          const ReturnLabel(label: "Price"),
                          CustomFormField(
                            controller: originalPriceController,
                            readOnly: !isUpdate,
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
                            readOnly: !isUpdate,
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
                          : isUpdate
                              ? ToggleButton(
                                  back: "Cancel",
                                  next: "Update",
                                  onPressedBack: () {
                                    if (isUpdate) {
                                      setState(() {
                                        isUpdate = false;
                                      });
                                    }
                                    Navigator.pop(context);
                                  },
                                  onPressedNext: () {
                                    List<XFile?> updatedPhotos = [
                                      _pImage1Pic,
                                      _pImage2Pic,
                                      _pImage3Pic
                                    ];
                                    List<XFile> validPhotos = updatedPhotos
                                        .where((photo) => photo != null)
                                        .map((photo) => photo!)
                                        .toList();
                                    if (isUpdate) {
                                      if (fcFormKey.currentState!.validate()) {
                                        ProductRepository()
                                            .updateProduct(
                                                Product(
                                                  name: nameController.text,
                                                  description:
                                                      procutDescripController
                                                          .text,
                                                  category:
                                                      _selectedCategory.name,
                                                  price: originalPriceController
                                                      .text,
                                                  discountedPrice:
                                                      discountedPriceController
                                                          .text,
                                                  photos: validPhotos,
                                                ),
                                                widget.product)
                                            .then((value) =>
                                                Navigator.of(context).pop());
                                        /*context.read<ProductBloc>().add(
                                              UpdateProductEvent(
                                                Product(
                                                  name: nameController.text,
                                                  description:
                                                      procutDescripController
                                                          .text,
                                                  category:
                                                      _selectedCategory.name,
                                                  price: originalPriceController
                                                      .text,
                                                  discountedPrice:
                                                      discountedPriceController
                                                          .text,
                                                  photos: validPhotos,
                                                ),
                                                widget.product,
                                              ),
                                            );*/
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
                                      }
                                    } else {
                                      customSnackBar(
                                          context,
                                          'Please press Update button on top',
                                          false);
                                    }
                                  },
                                )
                              : Center(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      DelevatedButton(
                                        onTap: () {
                                          BlocProvider.of<ProductBloc>(context)
                                              .add(
                                            DeleteProductEvent(
                                              widget.product.productId,
                                            ),
                                          );
                                        },
                                        text: 'Delete',
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                ColorsManager.lightRedColor,
                                            foregroundColor:
                                                ColorsManager.offWhiteColor,
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .bodyLarge),
                                      ),
                                    ],
                                  ),
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
