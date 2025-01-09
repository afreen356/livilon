import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:livilon/features/home/domain/model/dimensionmodel.dart';
import 'package:livilon/features/home/presentation/bloc/dimensions/dimension_bloc.dart';
import 'package:livilon/features/home/presentation/bloc/dimensions/dimension_event.dart';
import 'package:livilon/features/home/presentation/widget/textformfield.dart';

class DimensionsBottomSheet extends StatelessWidget {
  final TextEditingController heightController = TextEditingController();
  final TextEditingController widthController = TextEditingController();
  final TextEditingController depthController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  DimensionsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5, left: 15, right: 15),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(children: [
              Form(
                key: formkey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    const  Padding(
                        padding:  EdgeInsets.all(8.0),
                        child:  Text(
                          'Enter Dimensions',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomTextformfield(
                          validator: (value) =>
                              validateDimension(value, 'Height'),
                          hintText: 'Height (cm)',
                          labelText: 'Height',
                          controller: heightController,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomTextformfield(
                          validator: (value) =>
                              validateDimension(value, 'Width'),
                          hintText: 'Width (cm)',
                          labelText: 'Width',
                          controller: widthController,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomTextformfield(
                          validator: (value) =>
                              validateDimension(value, 'Depth'),
                          hintText: 'Depth (cm)',
                          labelText: 'Depth',
                          controller: depthController,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: getButtonColor()),
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              if (formkey.currentState!.validate()) {
                                 final dimensions = Dimensions(
                                  height: double.parse(heightController.text),
                                  width: double.parse(widthController.text),
                                  depth: double.parse(depthController.text));
                                  log('dimensions${heightController.text},${widthController.text},${depthController.text}');
                                  BlocProvider.of<DimensionBloc>(context).add(AddDimensions(dimensions: dimensions));
                                  log('dimensions $dimensions');
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                    backgroundColor:Colors.green,
                                    behavior: SnackBarBehavior.floating,
                                    content:  Text('Dimensions added successfully',style: TextStyle(color: Colors.white),)));
                                   Navigator.of(context).pop();
                                   return;
                              }
                             
                            },
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ])
          ],
        ),
      ),
    );
  }
}

Color getButtonColor() {
  return const Color.fromRGBO(121, 147, 174, 1);
}
