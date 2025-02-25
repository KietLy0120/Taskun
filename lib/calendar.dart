import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  bool isMonthlyView = false; // Default to weekly view
  DateTime? selectedDay; // Variable to track the selected day

  void toggleView() {
    setState(() {
      isMonthlyView = !isMonthlyView;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta! > 5) {
          setState(() => isMonthlyView = true);
        } else if (details.primaryDelta! < -5) {
          setState(() => isMonthlyView = false);
        }
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (widget, animation) {
          return FadeTransition(opacity: animation, child: widget);
        },
        child: isMonthlyView ? _buildMonthlyView() : _buildWeeklyView(),
      ),
    );
  }

  Widget _buildWeeklyView() {
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday % 7));
    List<DateTime> weekDates = List.generate(7, (index) => startOfWeek.add(Duration(days: index)));
    List<String> weekdayAbbreviations = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    String currentMonth = DateFormat('MMMM').format(now);

    return Container(
      key: const ValueKey('weekly'),
      width: MediaQuery.of(context).size.width * 0.9,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Column(
            children: [
              SizedBox(height: 4), // Push everything down slightly
              Text(
                currentMonth,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: Colors.black.withOpacity(0.7),
                ),
                textHeightBehavior: TextHeightBehavior(
                  applyHeightToFirstAscent: false,
                  applyHeightToLastDescent: false,
                ),
              ),
              Text(
                "Today",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.7),
                ),
                textHeightBehavior: TextHeightBehavior(
                  applyHeightToFirstAscent: false,
                  applyHeightToLastDescent: false,
                ),
              ),
            ],
          ),
          // Weekday row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              String dayLetter = weekdayAbbreviations[index];
              int dayNumber = weekDates[index].day;
              bool isCurrentDay = weekDates[index].day == now.day;
              bool isSelected = weekDates[index] == selectedDay;

              return Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      dayLetter,
                      style: TextStyle(color: Colors.black.withOpacity(0.7), fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDay = weekDates[index]; // Update selected day
                        });
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.purple.withOpacity(0.4) // Selected day with less opacity
                              : (isCurrentDay ? Colors.indigo : Colors.transparent),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '$dayNumber',
                            style: TextStyle(
                              color: isCurrentDay || isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }


  Widget _buildMonthlyView() {
    DateTime now = DateTime.now();
    int daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    List<DateTime> monthDates = List.generate(daysInMonth, (index) => DateTime(now.year, now.month, index + 1));

    String currentMonth = DateFormat('MMMM').format(now);

    return NotificationListener<ScrollNotification>(
      onNotification: (scrollNotification) {
        return true; // Prevents GridView from consuming gestures
      },
      child: Container(
        key: const ValueKey('monthly'),
        width: MediaQuery.of(context).size.width * 0.9,
        height: 320, // Taller for monthly view
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            // Current month label
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                currentMonth,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(0.7),
                ),
              ),
            ),
            // GridView for days in the month
            Expanded(
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(), // Prevent scrolling
                padding: const EdgeInsets.all(8),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7, // 7 columns for days of the week
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: daysInMonth,
                itemBuilder: (context, index) {
                  bool isCurrentDay = now.day == monthDates[index].day;

                  return Container(
                    decoration: BoxDecoration(
                      color: isCurrentDay ? Colors.indigo : Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${monthDates[index].day}',
                        style: TextStyle(
                          color: isCurrentDay ? Colors.white : Colors.white.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
