import 'package:flutter/material.dart';
import 'package:ffxiv_battle_logs/models/character.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class CharacterDataTable extends StatefulWidget {
  final List<Character> characterData;
  final String measure;
  final int totalTime;

  const CharacterDataTable(
      {super.key,
      required this.characterData,
      required this.measure,
      required this.totalTime});

  @override
  _CharacterDataTableState createState() => _CharacterDataTableState();
}

class _CharacterDataTableState extends State<CharacterDataTable> {
  final totalFormat =
      NumberFormat.compactCurrency(decimalDigits: 2, symbol: '');
  final tpsFormat = NumberFormat("###,###.0", "en_US");

  late List<Character> _characters;
  bool _sortAsc = false;
  int _sortColumnIndex = 2;

  @override
  void initState() {
    super.initState();
    _characters = widget.characterData;
    _characters.sort((a, b) => b.total!.compareTo(a.total!));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        sortColumnIndex: _sortColumnIndex,
        sortAscending: _sortAsc,
        columns: [
          DataColumn(
            label: Text("Name"),
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortAsc = sortAscending;
                if (columnIndex == _sortColumnIndex) {
                } else {
                  _sortColumnIndex = columnIndex;
                }

                _characters.sort((a, b) => a.name.compareTo(b.name));

                if (!_sortAsc) {
                  _characters = _characters.reversed.toList();
                }
              });
            },
          ),
          DataColumn(
            label: Text("Amount"),
            numeric: true,
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortAsc = sortAscending;
                if (columnIndex == _sortColumnIndex) {
                } else {
                  _sortColumnIndex = columnIndex;
                }

                _characters.sort((a, b) => a.total!.compareTo(b.total!));

                if (!_sortAsc) {
                  _characters = _characters.reversed.toList();
                }
              });
            },
          ),
          DataColumn(
            label: Text(widget.measure),
            numeric: true,
            onSort: (columnIndex, sortAscending) {
              setState(() {
                _sortAsc = sortAscending;
                if (columnIndex == _sortColumnIndex) {
                } else {
                  _sortColumnIndex = columnIndex;
                }

                _characters.sort((a, b) => (a.total! / widget.totalTime).compareTo((b.total! / widget.totalTime)));

                if (!_sortAsc) {
                  _characters = _characters.reversed.toList();
                }
              });
            },
          )
        ],
        rows: [
          for (var character in _characters) buildTableRow(character)
        ],
      ),
    );
  }

  DataRow buildTableRow(Character character) {
    var tps = (character.total! / widget.totalTime) * 1000;
    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              Image.asset(
                "assets/images/class_icons/${character.type.toLowerCase()}.png",
                width: 32,
                height: 32,
                errorBuilder: (context, exception, trace) {
                  return Icon(Icons.error_outline_outlined);
                },
              ),
              const SizedBox(
                width: 4.0,
              ),
              Text(character.name)
            ],
          ),
        ),
        DataCell(Text(totalFormat.format(character.total!))),
        DataCell(Text(tpsFormat.format(tps)))
      ],
    );
  }
}
