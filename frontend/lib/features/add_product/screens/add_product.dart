import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:store/common/constants/colors.dart';
import 'package:store/features/home/product_details/components/product_colors.dart';
import '../../../common/Utilities/utils.dart';

import '../../../models/category.dart';
import '../../home/repository/home_repository.dart';
import '../widgets/custom_textfield.dart';

class AddProduct extends ConsumerStatefulWidget {
  static String addProdustRoute = '/add_product';
  const AddProduct({super.key});

  @override
  ConsumerState<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends ConsumerState<AddProduct> {
  final TextEditingController productTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final _addProductFormKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _productColors = [];

  String category = 'Phones';
  List<File> images = [];

  @override
  void dispose() {
    super.dispose();
    productTitleController.dispose();
    descriptionController.dispose();
    priceController.dispose();
    quantityController.dispose();
  }

  void sellProduct() {
    if (_addProductFormKey.currentState!.validate() && images.isNotEmpty) {
      ref.read(homeRepoProvider).sellProduct(
          context: context,
          name: productTitleController.text,
          description: descriptionController.text,
          price: double.parse(priceController.text),
          quantity: int.parse(quantityController.text),
          category: category,
          images: images,
          colors: _productColors);
    }
  }

  void selectImages() async {
    var res = await pickImages();
    setState(() {
      images = res;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
              backgroundColor: primaryColor,
              leading: InkWell(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Colors.white,
                ),
              ),
              flexibleSpace: Container(),
              title: Text(
                'Add Product',
                style: const TextStyle(color: Colors.white),
              ))),
      body: SingleChildScrollView(
        child: Form(
          key: _addProductFormKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                images.isNotEmpty
                    ? CarouselSlider(
                        items: images.map(
                          (i) {
                            return Builder(
                              builder: (BuildContext context) => Image.file(
                                i,
                                fit: BoxFit.cover,
                                height: 200,
                              ),
                            );
                          },
                        ).toList(),
                        options: CarouselOptions(
                          viewportFraction: 1,
                          height: 200,
                        ),
                      )
                    : GestureDetector(
                        onTap: selectImages,
                        child: DottedBorder(
                            borderType: BorderType.RRect,
                            radius: const Radius.circular(10),
                            dashPattern: const [10, 4],
                            strokeCap: StrokeCap.round,
                            child: Container(
                              width: double.maxFinite,
                              height: 150,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.folder_open,
                                      size: 40,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      'Select Product',
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.grey.shade400),
                                    )
                                  ]),
                            )),
                      ),
                const SizedBox(
                  height: 30,
                ),
                CustomTextField(
                    controller: productTitleController,
                    hintText: 'Product Name'),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  controller: descriptionController,
                  hintText: 'Description Name',
                  maxLines: 7,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(controller: priceController, hintText: 'Price'),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                    controller: quantityController, hintText: 'Quantity'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 45,
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStatePropertyAll(primaryColor),
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Pick a color!'),
                                    content: SingleChildScrollView(
                                        child: MultipleChoiceBlockPicker(
                                      pickerColors: [], //default color
                                      onColorsChanged: (List<Color> colors) {
                                        _productColors.clear();
                                        for (int i = 0;
                                            i < colors.length;
                                            i++) {
                                          var hex =
                                              '0x${colors[i].value.toRadixString(16)}';

                                          String colorName;
                                          switch (hex) {
                                            case '0xfff44336':
                                              colorName = 'Red';
                                              break;
                                            case '0xffe91e63':
                                              colorName = 'Pink';
                                              break;
                                            case '0xff9c27b0':
                                              colorName = 'Purple';
                                              break;
                                            case '0xff673ab7':
                                              colorName = 'Dark-Purple';
                                              break;
                                            case '0xff3f51b5':
                                              colorName = 'Dark-Blue';
                                              break;
                                            case '0xff2196f3':
                                              colorName = 'Blue';
                                              break;
                                            case '0xff03a9f4':
                                              colorName = 'Light-Blue';
                                              break;
                                            case '0xff00bcd4':
                                              colorName = 'Cyan';
                                              break;
                                            case '0xff009688':
                                              colorName = 'Dark-Green';
                                              break;
                                            case '0xff4caf50':
                                              colorName = 'Green';
                                              break;
                                            case '0xff8bc34a':
                                              colorName = 'Light-Green';
                                              break;
                                            case '0xffcddc39':
                                              colorName = 'Yellow-Green';
                                              break;
                                            case '0xffffeb3b':
                                              colorName = 'Yellow';
                                              break;
                                            case '0xffffc107':
                                              colorName = 'Dark-Yellow';
                                              break;
                                            case '0xffff9800':
                                              colorName = 'Orange';
                                              break;
                                            case '0xffff5722':
                                              colorName = 'Accent-Orange';
                                              break;
                                            case '0xff795548':
                                              colorName = 'Brown';
                                              break;
                                            case '0xff9e9e9e':
                                              colorName = 'Grey';
                                              break;
                                            case '0xff607d8b':
                                              colorName = 'Black-Grey';
                                              break;
                                            case '0xff000000':
                                              colorName = 'Black';
                                              break;
                                            default:
                                              colorName = 'White';
                                          }
                                          _productColors.add({
                                            "colorName": colorName,
                                            "color": hex
                                          });
                                        }
                                      },
                                    )),
                                    actions: <Widget>[
                                      ElevatedButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                                    primaryColor)),
                                        child: const Text('DONE'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          print(
                                              _productColors); //dismiss the color picker
                                        },
                                      ),
                                    ],
                                  );
                                });
                          },
                          child: Text('Choose Colors')),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      alignment: Alignment.centerLeft,
                      child: FutureBuilder(
                          future: ref
                              .read(homeRepoProvider)
                              .fetchCategories(context: context),
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Category>> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            }
                            List<Category>? categories = snapshot.data;
                            return Container(
                              width: 120,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: DropdownButton(
                                value: category,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                items: categories!.map((items) {
                                  return DropdownMenuItem(
                                    value: items.title,
                                    child: Text(
                                      items.title,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newVal) {
                                  setState(() {
                                    category = newVal!;
                                  });
                                },
                              ),
                            );
                          }),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: 200,
                  height: 40,
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(primaryColor),
                      ),
                      onPressed: sellProduct,
                      child: Text('Sell Product')),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
