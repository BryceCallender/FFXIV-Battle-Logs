import 'package:ffxiv_battle_logs/components/reports/preview.dart';
import 'package:ffxiv_battle_logs/graphql/graphql_queries.dart';
import 'package:ffxiv_battle_logs/models/fight.dart';
import 'package:ffxiv_battle_logs/models/preview.dart';
import 'package:ffxiv_battle_logs/models/report.dart';
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
      body: Center(
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

                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: filteredFights.length,
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(
                      height: 8.0,
                    ),
                    itemBuilder: (context, index) {
                      return ReportPreview(
                        code: report.code,
                        fight: filteredFights[index],
                      );
                    },
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
