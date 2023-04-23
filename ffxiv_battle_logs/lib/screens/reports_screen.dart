import 'package:ffxiv_battle_logs/components/reports/report_overview.dart';
import 'package:ffxiv_battle_logs/models/reports.dart';
import 'package:ffxiv_battle_logs/styles.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:ffxiv_battle_logs/graphql/graphql_queries.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  ScrollController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Reports"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Query(
                  options: QueryOptions(
                    document: gql(GraphQLQueries.reports),
                    variables: {'page': 1, 'userID': 265053},
                  ),
                  builder: (QueryResult result,
                      {VoidCallback? refetch, FetchMore? fetchMore}) {
                    if (result.hasException) {
                      return Text(result.exception.toString());
                    }

                    if (result.isLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    Reports reportData = Reports.fromJson(
                        result.data?['reportData']?['reports'] ?? {});

                    if (reportData.reports.isEmpty) {
                      return const Text('No repositories');
                    }

                    final int nextPage = reportData.currentPage + 1;

                    FetchMoreOptions opts = FetchMoreOptions(
                      variables: {'page': nextPage},
                      updateQuery: (previousResultData, fetchMoreResultData) {
                        final List<dynamic> reports = [
                          ...previousResultData?['reportData']['reports']['data']
                          as List<dynamic>,
                          ...fetchMoreResultData?['reportData']['reports']['data']
                          as List<dynamic>
                        ];

                        fetchMoreResultData?['reportData']['reports']['data'] =
                            reports;

                        return fetchMoreResultData;
                      },
                    );

                    return NotificationListener(
                      child: ListView.builder(
                        key: PageStorageKey<String>('reports'),
                        controller: _controller,
                        shrinkWrap: true,
                        itemCount: reportData.reports.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(horizontal: Insets.sm, vertical: Insets.xs),
                            child: ReportOverview(
                              report: reportData.reports[index],
                            ),
                          );
                        },
                      ),
                      onNotification: (t) {
                        if (t is ScrollEndNotification &&
                            t.metrics.atEdge &&
                            reportData.hasMorePages) {
                          fetchMore!(opts);
                        }
                        return true;
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
