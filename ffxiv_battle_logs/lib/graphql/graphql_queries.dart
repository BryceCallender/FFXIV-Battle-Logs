class GraphQLQueries {
  static const worlds = """
  {
    worldData {
      regions {
        id
        name
        compactName
      }
      zones {
        id
        name
        frozen
        expansion {
          name
        }
        encounters {
          id
          name
        }
      }
    }
  }
  """;

  static const reports = """
  query ReadReports(\$page: Int!, \$userID: Int!) {
    reportData {
      reports(page: \$page, userID: \$userID) {
        has_more_pages
        current_page
        data {
          code
          startTime
          endTime
          title
          visibility
          zone {
            id
            name
            expansion {
              id
              name
            }
          }
        }
      }
    }
  }
  """;

  static const previews = """
  query ReadPreviews(\$code: String!) {
    reportData {
      report(code: \$code) {
        startTime
        endTime,
        rankedCharacters {
          name,
        },
        fights {
          id
          encounterID
          name
          bossPercentage
          fightPercentage
          kill
          startTime
          endTime
        }
      }
    }
  }
  """;

  static const reportBreakdown = """
  query ReportBreakdown(\$code: String!, \$fightIDs: [Int]) {
    reportData {
      report(code: \$code) {
        graph(fightIDs: \$fightIDs)
        rankings(fightIDs: \$fightIDs)
        playerDetails(fightIDs: \$fightIDs)
        events(fightIDs: \$fightIDs) {
          data
          nextPageTimestamp
        }
        table(fightIDs: \$fightIDs)
        masterData {
          actors {
            icon
            id
            name
            server
          }
        }
      }
    }
  }
  """;

  static const userInfo = """
  {
    userData {
      currentUser {
        id
      }
    }
  } 
  """;
}
