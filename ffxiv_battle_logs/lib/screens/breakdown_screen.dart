import 'package:ffxiv_battle_logs/components/party_section.dart';
import 'package:ffxiv_battle_logs/graphql/graphql_queries.dart';
import 'package:ffxiv_battle_logs/models/breakdown.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class BreakdownScreen extends StatelessWidget {
  final String code;
  final int fightId;
  const BreakdownScreen({super.key, required this.code, required this.fightId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Fight #$fightId"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Query(
                options: QueryOptions(
                  document: gql(GraphQLQueries.reportBreakdown),
                  variables: {'code': code, 'fightIDs': [fightId]},
                ),
                builder: (QueryResult result,
                    {VoidCallback? refetch, FetchMore? fetchMore}) {
                  if (result.hasException) {
                    return Text(result.exception.toString());
                  }

                  if (result.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  Breakdown breakdown = Breakdown.fromJson(
                      result.data?['reportData']?['report'] ?? {});

                  return ListView(
                    children: [
                      PartySection(players: breakdown.playerDetails)
                    ],
                  );
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
