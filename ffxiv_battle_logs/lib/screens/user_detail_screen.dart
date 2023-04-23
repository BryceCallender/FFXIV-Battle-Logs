import 'package:flutter/material.dart';
import 'package:ffxiv_battle_logs/components/user_detail_table_section.dart';
import 'package:ffxiv_battle_logs/models/character.dart';
import 'package:ffxiv_battle_logs/models/user_breakdown.dart';
import 'package:ffxiv_battle_logs/graphql/graphql_queries.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class UserDetailScreen extends StatelessWidget {
  final String code;
  final List<int> fightIds;
  final Character character;

  const UserDetailScreen(
      {super.key,
      required this.code,
      required this.fightIds,
      required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Hero(
              tag: '${character.type}',
              child: Image.asset(
                "assets/images/class_icons/${character.type.toLowerCase()}.png",
                width: 32,
                height: 32,
              ),
            ),
            const SizedBox(width: 4,),
            Text(character.name),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Query(
                    options: QueryOptions(
                      document: gql(GraphQLQueries.userBreakdown),
                      variables: {
                        'code': code,
                        'fightIDs': fightIds,
                        'sourceID': character.id
                      },
                    ),
                    builder: (QueryResult result,
                        {VoidCallback? refetch, FetchMore? fetchMore}) {
                      if (result.hasException) {
                        return Text(result.exception.toString());
                      }

                      if (result.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      UserBreakdown breakdown = UserBreakdown.fromJson(
                          result.data?['reportData']?['report'] ?? {});

                      return ListView(
                        children: [
                          UserDetailTableSection(
                            tableData: breakdown.tableData,
                          )
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
