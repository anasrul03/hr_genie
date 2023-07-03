// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_genie/Components/CustomListTile.dart';
import 'package:hr_genie/Components/LimitedTextField.dart';
import 'package:hr_genie/Components/SubmitButton.dart';
import 'package:hr_genie/Controller/Cubit/LeaveFormCubit/LeaveFormCubit.dart';
import 'package:hr_genie/Controller/Cubit/LeaveFormCubit/LeaveFormState.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class PickDateReasonRow extends StatefulWidget {
  final bool isFullDay;
  const PickDateReasonRow({
    super.key,
    required this.dateTitle,
    required this.isFullDay,
  });

  final String? dateTitle;

  @override
  State<PickDateReasonRow> createState() => _PickDateReasonRowState();
}

class _PickDateReasonRowState extends State<PickDateReasonRow> {
  DateRangePickerMonthCellStyle monthCellStyle() {
    return DateRangePickerMonthCellStyle(
      blackoutDatesDecoration: BoxDecoration(
          color: Colors.red,
          border: Border.all(color: const Color(0xFFF44436), width: 1),
          shape: BoxShape.circle),
      weekendDatesDecoration: BoxDecoration(
          color: const Color(0xFFDFDFDF),
          border: Border.all(color: const Color(0xFFF1F1F1), width: 1),
          shape: BoxShape.rectangle),
      specialDatesDecoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(color: const Color(0xFF2B732F), width: 1),
          shape: BoxShape.circle),
      blackoutDateTextStyle: const TextStyle(
          color: Colors.white, decoration: TextDecoration.lineThrough),
      specialDatesTextStyle: const TextStyle(color: Colors.white),
    );
  }

  Future<void> pickFullDays(
      BuildContext context, List<DateTime>? filteredDates) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<LeaveFormCubit, LeaveFormState>(
          builder: (context, state) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 200),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SfDateRangePicker(
                    controller: _controller,
                    allowViewNavigation: true,
                    showNavigationArrow: true,
                    onSelectionChanged: (args) {
                      if (args.value is DateTime) {
                        print("Selected Date: ${args.value.toString()}");
                        context.read<LeaveFormCubit>().setDateTime(args.value);
                      } else {
                        selectionChanged(args);
                        context
                            .read<LeaveFormCubit>()
                            .setRangeDate(selectedDates);
                        print("Selected Date: $selectedDates");
                        print("Start Date: ${_startDate}");
                        print("Start Date: ${_endDate}");
                      }
                    },
                    enablePastDates: false,
                    monthCellStyle: monthCellStyle(),
                    monthViewSettings: const DateRangePickerMonthViewSettings(
                      firstDayOfWeek: 1,
                      weekendDays: [6, 7],
                      enableSwipeSelection: true,
                    ),
                    toggleDaySelection: true,
                    extendableRangeSelectionDirection:
                        ExtendableRangeSelectionDirection.forward,
                    selectionMode: widget.isFullDay
                        ? DateRangePickerSelectionMode.range
                        : DateRangePickerSelectionMode.single,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  late String _startDate, _endDate;
  final DateRangePickerController _controller = DateRangePickerController();
  List<DateTime> selectedDates = [];

  @override
  void initState() {
    final DateTime today = DateTime.now();
    _startDate = DateFormat('dd, MMMM yyyy').format(today).toString();
    _endDate = DateFormat('dd, MMMM yyyy')
        .format(today.add(const Duration(days: 2)))
        .toString();
    // _controller.selectedRange =
    //     PickerDateRange(today, today.add(const Duration(days: 2)));
    // selectedDates = getSelectedDates(today, today.add(const Duration(days: 3)));
    super.initState();
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      _startDate =
          DateFormat('dd, MMMM yyyy').format(args.value.startDate).toString();
      _endDate = DateFormat('dd, MMMM yyyy')
          .format(args.value.endDate ?? args.value.startDate)
          .toString();
      selectedDates =
          getSelectedDates(args.value.startDate, args.value.endDate);
    });
  }

  List<DateTime> getSelectedDates(DateTime startDate, DateTime? endDate) {
    final List<DateTime> dates = [];
    final Duration difference = endDate?.difference(startDate) ?? Duration.zero;
    final int numDays = difference.inDays + 1;
    for (int i = 0; i < numDays; i++) {
      final DateTime date = startDate.add(Duration(days: i));
      dates.add(date);
    }
    return dates;
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime>? dates = [];
    List<DateTime>? filteredDates = dates.where((date) {
      return date.weekday != DateTime.saturday &&
          date.weekday != DateTime.sunday;
    }).toList();
    TextEditingController reasonController = TextEditingController();
    return BlocBuilder<LeaveFormCubit, LeaveFormState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: CustomListTile(
                margin: const EdgeInsets.fromLTRB(10, 1, 1, 1),
                title: Text(widget.dateTitle!),
                trailing: const Icon(Icons.date_range),
                onTap: () async {
                  pickFullDays(context, filteredDates);
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: CustomListTile(
                color: state.reason != null ? Colors.indigo : Colors.grey[200],
                margin: const EdgeInsets.fromLTRB(1, 1, 10, 1),
                title: Text(
                  "Reason",
                  style: TextStyle(
                      color:
                          state.reason != null ? Colors.white : Colors.black),
                ),
                trailing: Icon(
                  Icons.edit,
                  color: state.reason != null ? Colors.white : Colors.black,
                ),
                onTap: () {
                  insertReason(context, reasonController);
                },
              ),
            )
          ],
        );
      },
    );
  }

  Future<dynamic> insertReason(
      BuildContext context, TextEditingController reasonController) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return BlocBuilder<LeaveFormCubit, LeaveFormState>(
          builder: (context, state) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 300),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 2,
                        child: LimitedTextField(
                          onchanged: (value) {
                            context.read<LeaveFormCubit>().inputChecking(value);
                          },
                          controller: reasonController,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 1,
                            child: SubmitButton(
                              textColor: Colors.grey.shade600,
                              buttonColor:
                                  MaterialStateProperty.all(Colors.white),
                              margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              label: "CANCEL",
                              onPressed: () {
                                setState(() {
                                  reasonController.clear();
                                });

                                Navigator.pop(context);
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            flex: 1,
                            child: state.reason == null
                                ? SubmitButton(
                                    margin:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                    label: "ADD",
                                    onPressed: state.isValidReason
                                        ? () {
                                            context
                                                .read<LeaveFormCubit>()
                                                .submitReason(reasonController
                                                    .text
                                                    .trim());

                                            Navigator.pop(context);
                                          }
                                        : null)
                                : state.isValidReason
                                    ? SubmitButton(
                                        buttonColor: MaterialStateProperty.all(
                                            Colors.red),
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 0),
                                        label: "REMOVE",
                                        onPressed: () {
                                          context
                                              .read<LeaveFormCubit>()
                                              .resetReason();
                                          Navigator.pop(context);
                                        })
                                    : SubmitButton(
                                        margin: const EdgeInsets.fromLTRB(
                                            0, 10, 0, 0),
                                        label: "EDIT",
                                        onPressed: state.isValidReason
                                            ? () {
                                                context
                                                    .read<LeaveFormCubit>()
                                                    .submitReason(
                                                        reasonController.text
                                                            .trim());

                                                Navigator.pop(context);
                                              }
                                            : null),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}