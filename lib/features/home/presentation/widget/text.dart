import 'package:flutter/material.dart';

Widget title(String text, ){
 
 
  return Text(
    text,
    style: const TextStyle(
      color: Colors.grey,
      fontSize: 16,
      fontWeight: FontWeight.w400
    ),
    
  );
}

Widget productName(String text, ){
 
 
  return Text(
    text,
    style: const TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.bold
    ),
    
  );
}

Widget productPrice(String price) {
  return Text(
    price,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
    ),
  );
}
Widget errorText(String text){
  return Text(text,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.w500),);
}

Widget addButton(String text){
   Color getButtonColor() {
    return const Color.fromRGBO(121, 147, 174, 1);
  }
   return Container(
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5), color: getButtonColor()),
                child:  Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              );
}
class TextCustom extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final TextAlign? textAlign;

  const TextCustom({
    Key? key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.textAlign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? Colors.black, // Default color is black
      ),
      textAlign: textAlign,
    );
  }
}