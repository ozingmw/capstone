import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class MyDropdown extends StatefulWidget {
  final Function(String?) onChanged; // 콜백 함수 추가

  const MyDropdown({super.key, required this.onChanged}); // 콜백 함수를 생성자에서 받음

  @override
  _MyDropdownState createState() => _MyDropdownState();
}

class _MyDropdownState extends State<MyDropdown> {
  final List<String> items = [
    '10대',
    '20대',
    '30대',
    '40대',
    '50대',
    '60대',
    '70대',
    '80대',
    '90대',
    '100대',
  ];
  String? selectedValue;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2<String>(
        isExpanded: true,
        hint: Text(
          '선택',
          style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).hintColor,
          ),
        ),
        items: items
            .map((String item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ))
            .toList(),
        value: selectedValue,
        onChanged: (String? newValue) {
          setState(() {
            selectedValue = newValue;
          });
          widget.onChanged(newValue); // 값이 변경될 때 콜백 함수 호출
        },
        buttonStyleData: const ButtonStyleData(
          padding: EdgeInsets.symmetric(horizontal: 16),
          height: 40,
          width: 140,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
        ),
      ),
    );
  }
}
