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
          maps {
            id
          }
        }
      }
    }
  }
  """;

  static const reportBreakdown = """
  query ReportBreakdown(\$code: String!, \$fightIDs: [Int]) {
    reportData {
      report(code: \$code) {
        playerDetails(fightIDs: \$fightIDs)
        table(fightIDs: \$fightIDs)
        rankings(fightIDs: \$fightIDs)
        events(fightIDs: \$fightIDs, limit: 100) {
          data
          nextPageTimestamp
        }
        masterData {
          abilities {
            gameID
            icon
          }
          actors {
            id
            name
          }
        }
      }
    }
  }
  """;

  static const userBreakdown = """
  query UserDetailBreakdown(\$code: String!, \$fightIDs: [Int], \$sourceID: Int!) {
    reportData {
      report(code: \$code) {
        table(fightIDs: \$fightIDs, sourceID: \$sourceID)
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
