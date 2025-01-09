import 'package:flutter/material.dart';
import 'package:livilon/features/home/presentation/screen/search_screen.dart';




class SearchBox extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final Function(String)? onChanged;

  const SearchBox({
    Key? key,
    required this.controller,
    this.hintText = 'What are you looking for ?',
    this.onChanged
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 224, 221, 221), // Background color
        borderRadius: BorderRadius.circular(2.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: onChanged,
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: IconButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> SearchScreen()));
                }, icon: Icon(Icons.search,color: Colors.grey[600],)),
                hintText: hintText,
                hintStyle: TextStyle(
                  color: buttonColor()
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          
        ],
      ),
    );
  }

  buttonColor(){
     Color btnClr = const Color.fromRGBO(121, 147, 174, 1);
     return btnClr;
  }
}