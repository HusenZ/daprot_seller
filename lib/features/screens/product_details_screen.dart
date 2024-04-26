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
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:uuid/uuid.dart';

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

  Category? _selectedCategory;
  SubCategory? _selectedSubCategory;

  bool isLoading = false;

  bool isUpdate = false;

  @override
  void initState() {
    super.initState();
    _selectedSubCategory = SubCategory.values
        .firstWhere((cat) => cat.name == widget.product.subCategory);
    nameController.text = widget.product.name;
    procutDescripController.text = widget.product.description;
    originalPriceController.text = widget.product.price;
    discountedPriceController.text = widget.product.discountedPrice;
    _selectedCategory = Category.values
        .firstWhere((cat) => cat.name == widget.product.category);
  }

  Future<void> _pImage1(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(
      source: source,
      imageQuality: 50,
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
      imageQuality: 50,
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
      imageQuality: 50,
    );
    if (pickedImage != null) {
      setState(() {
        _pImage3Pic = pickedImage;
      });
    }
  }

  Future<String> getUrl(XFile image) async {
    Uuid uuid = const Uuid();
    String uid = FirebaseAuth.instance.currentUser?.uid ?? '';

    Reference ref =
        FirebaseStorage.instance.ref('product-images/$uid/${uuid.v4()}.jpg');
    await ref.putFile(File(image.path));
    String url = await ref.getDownloadURL();
    return url;
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
                                  onPressedNext: () async {
                                    List<String>? updatedPhotos;
                                    showLoading();
                                    if (isUpdate) {
                                      if (_pImage1Pic != null ||
                                          _pImage2Pic != null ||
                                          _pImage3Pic != null) {
                                        updatedPhotos = [];
                                        setState(() {
                                          isLoading = true;
                                        });

                                        if (_pImage1Pic != null) {
                                          String url1 =
                                              await getUrl(_pImage1Pic!);
                                          updatedPhotos.add(url1);
                                        } else {
                                          updatedPhotos
                                              .add(widget.product.photos[0]);
                                        }

                                        if (_pImage2Pic != null) {
                                          String url2 =
                                              await getUrl(_pImage2Pic!);
                                          updatedPhotos.add(url2);
                                        } else {
                                          updatedPhotos
                                              .add(widget.product.photos[1]);
                                        }
                                        if (_pImage3Pic != null) {
                                          String url3 =
                                              await getUrl(_pImage3Pic!);

                                          updatedPhotos.add(url3);
                                        } else {
                                          updatedPhotos
                                              .add(widget.product.photos[2]);
                                        }
                                      }
                                      Product updatedProduct = Product(
                                        name: nameController.text,
                                        subCategory: _selectedCategory!.name,
                                        description:
                                            procutDescripController.text,
                                        category: _selectedCategory!.name,
                                        price: originalPriceController.text,
                                        discountedPrice:
                                            discountedPriceController.text,
                                        photos: [],
                                      );

                                      BlocProvider.of<ProductBloc>(context).add(
                                        UpdateProductEvent(
                                            updatedProduct,
                                            widget.product,
                                            updatedPhotos ??
                                                widget.product.photos),
                                      );
                                    }
                                  })
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
      backgroundColor: Color.fromARGB(255, 145, 202, 255),
      content: SingleChildScrollView(
        child: Column(
          children: [
            // Dropdown for Main Category
            DropdownButton<Category>(
              value: _selectedCategory,
              dropdownColor: Colors.white,
              icon: const Icon(
                Icons.arrow_drop_down_circle_rounded,
                color: Colors.white,
              ),
              focusColor: Colors.white,
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
                    title: Text(
                      subCategory.name.toUpperCase(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
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
            backgroundColor: const Color.fromARGB(255, 251, 251, 251),
          ),
          child: const Text('Select'),
        ),
      ],
    );
  }
}
