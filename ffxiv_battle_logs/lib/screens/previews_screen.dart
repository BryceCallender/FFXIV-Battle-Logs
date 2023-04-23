import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:ffxiv_battle_logs/components/reports/preview.dart';
import 'package:ffxiv_battle_logs/graphql/graphql_queries.dart';
import 'package:ffxiv_battle_logs/helpers/map_helper.dart';
import 'package:ffxiv_battle_logs/models/boss_group.dart';
import 'package:ffxiv_battle_logs/models/fight.dart';
import 'package:ffxiv_battle_logs/models/preview.dart';
import 'package:ffxiv_battle_logs/models/report.dart';
import 'package:ffxiv_battle_logs/styles.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class PreviewsScreen extends StatelessWidget {
  final Report report;
  const PreviewsScreen({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Previews"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Query(
                  options: QueryOptions(
                    document: gql(GraphQLQueries.previews),
                    variables: {'code': report.code},
                  ),
                  builder: (QueryResult result,
                      {VoidCallback? refetch, FetchMore? fetchMore}) {
                    if (result.hasException) {
                      return Text(result.exception.toString());
                    }

                    if (result.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    Preview reportPreview = Preview.fromJson(
                        result.data?['reportData']?['report'] ?? {});

                    final List<Fight> filteredFights = reportPreview.fights
                        .where((f) => f.encounterID != 0)
                        .toList();

                    var groupedFights =
                        groupBy(filteredFights, (Fight fight) => fight.name);

                    if (groupedFights.isEmpty)
                      return Center(
                          child: Text("No fights for this report..."));

                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: groupedFights.length,
                      itemBuilder: (context, index) {
                        final key = groupedFights.keys.elementAt(index);
                        final fights = groupedFights[key]!;
                        final fight = fights.first;
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: Insets.sm, vertical: Insets.xs),
                          child: ExpansionTile(
                            leading: CachedNetworkImage(
                              imageUrl: MapHelper.mapToImageUrl(fight.map?.id ?? 0),
                              placeholder: (context, url) => CircularProgressIndicator(),
                              errorWidget: (context, url, error) =>
                              Icon(Icons.error_outline_outlined),
                            ),
                            title: Text(key),
                            children: fights
                                .map((f) =>
                                    ReportPreview(fight: f, code: report.code))
                                .toList(),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
