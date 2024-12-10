import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.grey),
        ),
      ),
      home: const FreightRatesPage(),
    );
  }
}

class FreightRatesPage extends StatefulWidget {
  const FreightRatesPage({super.key});

  @override
  _FreightRatesPageState createState() => _FreightRatesPageState();
}

class _FreightRatesPageState extends State<FreightRatesPage> {
  final TextEditingController originController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController commodityController = TextEditingController();
  final TextEditingController cutoffDateController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController boxCountController = TextEditingController();

  List<String> originSuggestions = [];
  List<String> destinationSuggestions = [];
  List<String> standardsList = [
    "20' Standard",
    "40' Standard",
    "40' High Cube",
    "40' Open Top",
    "40' Reefer",
    "40' Standard"
  ];
  bool isStandardListOpen = false;
  int selectedStd = 1;
  double turns = 0.0;

  bool isOriginNearbyPortsChecked = false;
  bool isShipmentFCLChecked = false;
  bool isShipmentLCLChecked = false;
  bool isDestinationNearbyPortsChecked = false;

  @override
  void initState() {
    super.initState();
    fetchSuggestions();
  }

  Future<void> fetchSuggestions() async {
    final response = await http
        .get(Uri.parse('http://universities.hipolabs.com/search?name=middle'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      setState(() {
        originSuggestions = data.map((item) => item['name'] as String).toList();
        destinationSuggestions = originSuggestions;
      });
    } else {
      // Handle error
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search the best Freight Rates',
          style: TextStyle(color: Colors.black, fontSize: 24,fontWeight: FontWeight.bold),
        ),
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 16),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 236, 239, 255),
                  side: const BorderSide(color: Color.fromRGBO(1, 57, 255, 1)),
                ),
                onPressed: () {},
                child: const Text(
                  'History',
                  style: TextStyle(
                    color: Color.fromRGBO(1, 57, 255, 1),
                  ),
                ),
              )),
        ],
        backgroundColor: const Color.fromRGBO(230, 234, 248, 1),
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black),
        shadowColor: const Color(0x00000005),
      ),
      backgroundColor: const Color.fromARGB(255, 225, 231, 252),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      blurRadius: 2,
                      color: Color.fromRGBO(69, 69, 69, 0.416),
                      offset: Offset(0, 1),
                      spreadRadius: 0.01)
                ]),

            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomAutoCompleteField(
                              hintText: "Origin",
                              controller: originController,
                              suggestions: originSuggestions,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Checkbox(
                                  value: isOriginNearbyPortsChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      isOriginNearbyPortsChecked = value!;
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  side: const BorderSide(width: 1, color: Colors.grey), // Thin grey border
                                  activeColor: Colors.blue, // Blue check color
                                ),
                                const Text("Include Nearby Ports",
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: commodityController,
                              decoration: const InputDecoration(
                                hintText: "Commodity",
                                suffixIcon:
                                    Icon(Icons.keyboard_arrow_down_rounded),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),

                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Text("Shipment Type:",style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),),
                            Row(
                              children: [
                                Checkbox(
                                  value: isShipmentFCLChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      isShipmentFCLChecked = value!;
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  side: const BorderSide(width: 1, color: Colors.grey),
                                  activeColor: Colors.blue,
                                ),
                                const Text("FCL",
                                    style: TextStyle(color: Colors.black)),
                                const SizedBox(width: 16),
                                Checkbox(
                                  value: isShipmentLCLChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      isShipmentLCLChecked = value!;
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  side: const BorderSide(width: 1, color: Colors.grey),
                                  activeColor: Colors.blue,
                                ),
                                const Text("LCL",
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  turns += 1 / 2;
                                  isStandardListOpen = !isStandardListOpen;
                                });
                              },
                              child: Container(
                                height: 45,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1, color: Colors.grey),
                                    borderRadius: BorderRadius.circular(4)),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        standardsList[selectedStd],
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                      AnimatedRotation(
                                        turns: turns,
                                        duration: const Duration(milliseconds: 300),
                                        child: const Icon(
                                            Icons.keyboard_arrow_down_rounded,color: Colors.grey,),

                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomAutoCompleteField(
                              hintText: "Destination",
                              controller: destinationController,
                              suggestions: destinationSuggestions,
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Checkbox(
                                  value: isDestinationNearbyPortsChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      isDestinationNearbyPortsChecked = value!;
                                    });
                                  },
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  side: const BorderSide(width: 1, color: Colors.grey),
                                  activeColor: Colors.blue,
                                ),
                                const Text("Include Nearby Ports",
                                    style: TextStyle(color: Colors.black)),
                              ],
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: cutoffDateController,
                              decoration: InputDecoration(
                                hintText: "Cutoff Date",
                                border: const OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8))),

                                hintStyle: const TextStyle(color: Colors.grey),
                                suffixIcon:
                                    Image.asset('assets/cal.png', scale: 1),
                              ),
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime(2101),
                                );
                                if (pickedDate != null) {
                                  cutoffDateController.text =
                                      "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                }
                              },
                            ),
                            const SizedBox(height: 82),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: boxCountController,
                                    decoration: const InputDecoration(
                                      hintText: "No of Boxes",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: TextField(
                                    controller: weightController,
                                    decoration: const InputDecoration(
                                      hintText: "Weight (Kg)",
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8))),
                                      hintStyle: TextStyle(color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (isStandardListOpen)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(standardsList.length, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedStd = index;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: selectedStd == index
                                  ? Colors.transparent
                                  : Colors.transparent,
                            ),
                            child: Text(
                              standardsList[index],
                              style: TextStyle(
                                color: selectedStd == index
                                    ? Colors.black
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  Row(
                    children: [
                      Image.asset('assets/mark.png'),
                      const Text(
                        " To obtain accurate rate for spot rate with guaranteed space and booking, please ensure your container count and weight per container is accurate",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text("Container Internal Dimension :",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Column(
                          children: [
                            Row(
                              children: [
                                Text("Length: ",
                                    style: TextStyle(color: Colors.grey)),
                                Text(" 39.46 ft",style: TextStyle(color: Colors.black)),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Width: ",
                                    style: TextStyle(color: Colors.grey)),
                                Text(" 7.70 ft",style: TextStyle(color: Colors.black)),
                              ],
                            ),
                            Row(
                              children: [
                                Text("Height: ",
                                    style: TextStyle(color: Colors.grey)),
                                Text(" 7.84 ft",style: TextStyle(color: Colors.black)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 30),
                      Image.asset('assets/container.png', scale: 3),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              const Color.fromRGBO(230, 235, 255, 1),
                          side: const BorderSide(
                              color: Color.fromRGBO(1, 57, 255, 1)),
                        ),
                        onPressed: () {},
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search,
                                color: Color.fromRGBO(1, 57, 255, 1)),
                            Text(
                              'Search',
                              style: TextStyle(
                                color: Color.fromRGBO(1, 57, 255, 1),
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomAutoCompleteField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final List<String> suggestions;

  const CustomAutoCompleteField({super.key, 
    required this.hintText,
    required this.controller,
    required this.suggestions,
  });

  @override
  Widget build(BuildContext context) {
    return TypeAheadFormField(
      textFieldConfiguration: TextFieldConfiguration(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Image.asset('assets/location_icon.png'),
          hintText: hintText,
          border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(8))),
          hintStyle: const TextStyle(color: Colors.grey),
        ),
      ),
      suggestionsCallback: (pattern) {
        return suggestions.where(
          (item) => item.toLowerCase().contains(pattern.toLowerCase()),
        );
      },
      itemBuilder: (context, suggestion) {
        return ListTile(
          title: Text(suggestion, style: const TextStyle(color: Colors.grey)),
        );
      },
      onSuggestionSelected: (suggestion) {
        controller.text = suggestion;
      },
    );
  }
}
