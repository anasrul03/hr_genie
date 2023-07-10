import 'package:flutter/material.dart';
import 'package:hr_genie/Components/CustomAppBar.dart';
import 'package:hr_genie/Components/SubmitButton.dart';
import 'package:hr_genie/Constants/Color.dart';
import 'package:hr_genie/Controller/Services/checkLeaveType.dart';
import 'package:hr_genie/Model/LeaveModel.dart';
import 'package:intl/intl.dart';

class LeaveDetailPage extends StatelessWidget {
  final Leave leaveModel;
  const LeaveDetailPage({super.key, required this.leaveModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: CustomAppBar(title: "Leave Review")),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: LeaveDetailInfo(
                label: 'Leave Type',
                value: checkLeaveType(leaveModel.leaveTypeId),
              ),
            ),
            Expanded(
              child: LeaveDetailInfo(
                label: 'Date',
                value:
                    "${DateFormat.yMMMd('en-US').format(leaveModel.startDate)} to ${DateFormat.yMMMEd('en-US').format(leaveModel.endDate)}",
              ),
            ),
            Expanded(
              child: LeaveDetailInfo(
                label: 'Duration',
                value:
                    '${leaveModel.endDate.difference(leaveModel.startDate).inDays} Days',
              ),
            ),
            Expanded(
              child: LeaveDetailInfo(
                label: 'Reason',
                value: leaveModel.reason,
              ),
            ),
            Expanded(
              child: LeaveDetailInfo(
                label: 'Attachment',
                value: leaveModel.attachment,
              ),
            ),
            Expanded(
              child: LeaveDetailInfo(
                label: 'Status',
                value: leaveModel.applicationStatus,
              ),
            ),
            const SizedBox(
              height: 120,
            ),
            const Expanded(
              child: Text(
                "You can cancel your leave application during pending only. Otherwise you'll need to inform your manager",
                textAlign: TextAlign.center,
                style: TextStyle(color: instructionTextColor, fontSize: 13),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SubmitButton(
              label: "Cancel",
              onPressed:
                  leaveModel.applicationStatus == "Pending" ? () {} : null,
              buttonColor: Colors.red,
            )
          ],
        ),
      ),
    );
  }
}

class LeaveDetailInfo extends StatelessWidget {
  final String label;
  final String value;
  const LeaveDetailInfo({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: Container(
                margin: const EdgeInsets.only(top: 10), child: Text(label))),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          padding: const EdgeInsets.all(10),
          width: double.maxFinite,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: cardColor,
          ),
          child: Text(value),
        ),
      ],
    );
  }
}