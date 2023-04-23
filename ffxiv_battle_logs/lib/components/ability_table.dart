import 'package:cached_network_image/cached_network_image.dart';
import 'package:ffxiv_battle_logs/formats.dart';
import 'package:flutter/material.dart';
import 'package:ffxiv_battle_logs/models/ability.dart';

class AbilityTable extends StatefulWidget {
  final List<Ability> abilities;
  final int totalTime;
  final String measure;
  const AbilityTable({super.key, required this.abilities, required this.totalTime, required this.measure});

  @override
  _AbilityTableState createState() => _AbilityTableState();
}

class _AbilityTableState extends State<AbilityTable> {
  late List<Ability> _abilities;
  bool _sortAsc = false;
  int _sortColumnIndex = 2;

  @override
  void initState() {
    super.initState();
    _abilities = widget.abilities;
    _abilities.sort((a, b) => b.total!.compareTo(a.total!));
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

                _abilities.sort((a, b) => a.name!.compareTo(b.name!));

                if (!_sortAsc) {
                  _abilities = _abilities.reversed.toList();
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

                _abilities.sort((a, b) => a.total!.compareTo(b.total!));

                if (!_sortAsc) {
                  _abilities = _abilities.reversed.toList();
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

                _abilities.sort((a, b) => (a.total! / widget.totalTime).compareTo((b.total! / widget.totalTime)));

                if (!sortAscending) {
                  _abilities = _abilities.reversed.toList();
                }
              });
            },
          ),
        ],
        rows: [for (var a in _abilities) buildTableRow(a)],
      ),
    );
  }

  DataRow buildTableRow(Ability ability) {
    var tps = (ability.total! / widget.totalTime) * 1000;

    return DataRow(
      cells: [
        DataCell(
          Row(
            children: [
              CachedNetworkImage(
                imageUrl: ability.abilityUrl,
                placeholder: (context, url) => CircularProgressIndicator(),
                errorWidget: (context, url, error) => Icon(Icons.error_outline_outlined),
                width: 32,
                height: 32,
              ),
              const SizedBox(
                width: 4.0,
              ),
              Text(ability.name!)
            ],
          ),
        ),
        DataCell(Text(Format.totalFormat.format(ability.total!))),
        DataCell(Text(Format.tpsFormat.format(tps)))
      ],
    );
  }
}
