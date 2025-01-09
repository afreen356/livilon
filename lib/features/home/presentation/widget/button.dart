import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:livilon/features/home/presentation/screen/dimension_screen.dart';

Widget customizedButton(){
 return ElevatedButton(
                      onPressed: () {
                        log('helloo');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: getButtonColor(),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        'CONTINUE',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    );
}