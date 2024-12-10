// import 'package:flutter/material.dart';

// class DropdownWithHelperText extends StatefulWidget {
//   @override
//   _DropdownWithHelperTextState createState() =>
//       _DropdownWithHelperTextState();
// }

// class _DropdownWithHelperTextState extends State<DropdownWithHelperText> {
//   String? selectedValue;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Dropdown with Helper Text")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: DropdownButtonFormField<String>(
//           value: selectedValue,
//           onChanged: (newValue) {
//             setState(() {
//               selectedValue = newValue;
//             });
//           },
//           items: [
//             DropdownMenuItem(
//               child: Text("40"),
//               value: "40",
//             ),
//             DropdownMenuItem(
//               child: Text("50"),
//               value: "50",
//             ),
//             DropdownMenuItem(
//               child: Text("60"),
//               value: "60",
//             ),
//             // Add more items here as needed
//           ],
//           decoration: InputDecoration(
//             labelText: "Select Value",
//             helperText: "Choose a standard value",
//             helperStyle: TextStyle(color: Colors.grey),
//             border: OutlineInputBorder(),
//             suffixIcon: Icon(Icons.arrow_drop_down),
//           ),
//           isExpanded: true, // Ensures the dropdown occupies available width
//         ),
//       ),
//     );
//   }
// }
