import 'package:flutter/material.dart';
import 'custom_style.dart';

class AddModal {
  static void show(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController categoryController = TextEditingController();
    final TextEditingController startDateController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows full-height sheet
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.transparent, // Makes background transparent
      builder: (context) {
        String selectedType = "Task"; // Default selection
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white, // Background color of modal
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Title Row with Close (X) and Save (✔)
                    Container(
                      color: const Color(0xFF28619A), // Background for title row
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () => Navigator.pop(context), // Close modal
                          ),
                          const Text(
                            "New Routine",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          IconButton(
                            icon: const Icon(Icons.check, color: Colors.white),
                            onPressed: () {
                              // Handle save action
                              String title = titleController.text;
                              String description = descriptionController.text;
                              String category = categoryController.text;
                              print("Saved: Title: $title, Description: $description, Type: $selectedType, Category: $category");
                              Navigator.pop(context); // Close modal
                            },
                          ),
                        ],
                      ),
                    ),

                    // Content area below the title row
                    Container(
                      color: const Color(0xFF0F3376), // Background for main content
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          // Title Field
                          TextField(
                            controller: titleController,
                            decoration: customInputDecoration('Title'),
                          ),
                          const SizedBox(height: 25),

                          // Description Field
                          TextField(
                            controller: descriptionController,
                            decoration: customInputDecoration('Description'),
                            maxLines: 1,
                            maxLength: 100,
                            buildCounter: (context, {int? currentLength, int? maxLength, bool? isFocused}) => null,
                          ),
                          const SizedBox(height: 25),

                          // Row for Type and Category Fields
                          Row(
                            children: [
                              // Type Dropdown
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  value: selectedType,
                                  decoration: customInputDecoration('Type'),
                                  dropdownColor: Colors.blueGrey,
                                  isDense: true,
                                  items: ["Task", "Habit"].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value, style: const TextStyle(color: Colors.white)), // White text
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedType = newValue!;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10), // Space between fields

                              // Category Field
                              Expanded(
                                child: TextField(
                                  controller: categoryController,
                                  decoration: customInputDecoration('Category'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[800], // Dark grey background
                      ),
                      child: Column(
                        children: [
                          // Points Field
                          TextField(
                            decoration: customInputDecoration('Points'),
                            keyboardType: TextInputType.number,
                          ),

                          const SizedBox(height: 20),

                          // Row for Start Date and End Date
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: startDateController,
                                  decoration: customInputDecoration('Start Date'),
                                  readOnly: true, // Prevents manual input
                                  onTap: () async {
                                    DateTime? selectedDate = await showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(2000), // Set the first date that can be picked
                                      lastDate: DateTime(2101), // Set the last date that can be picked
                                    );

                                    if (selectedDate != null) {
                                      // Format the date as you prefer
                                      String formattedDate = "${selectedDate.toLocal()}".split(' ')[0];
                                      startDateController.text = formattedDate; // Update the text field with the selected date
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  decoration: customInputDecoration('End Date'),
                                  readOnly: true, // Prevents manual input
                                  onTap: () {
                                    // Show date picker logic here
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Row for Repeated and Time Reminder
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<String>(
                                  decoration: customInputDecoration('Repeated'),
                                  dropdownColor: Colors.blueGrey,
                                  isDense: true,
                                  isExpanded: true,
                                  items: ["Daily", "Weekly", "Monthly", "None"].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value, style: const TextStyle(color: Colors.white)),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    // Handle selection
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  decoration: customInputDecoration('Time Reminder'),
                                  keyboardType: TextInputType.datetime,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Delete Button
                          ElevatedButton(
                            onPressed: () {
                              print("Delete action");
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Delete"),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
