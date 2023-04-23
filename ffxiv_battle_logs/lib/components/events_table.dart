import 'package:flutter/material.dart';

class EventsTable extends StatelessWidget {
  const EventsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text("Time"),
          ),
          DataColumn(
            label: Text("Event"),
          ),

        ],
        //rowsPerPage: 100,
        rows: [],
      ),
    );
  }

  DataRow buildTableRow() {
    return DataRow(
      cells: [
        DataCell(
          Text("")
        ),
        DataCell(
          Text("")
        )
      ],
    );
  }
}
