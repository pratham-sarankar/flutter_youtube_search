class Constants {
  static const searchKey = 'AIzaSyAO_FJ2SlqU8Q4STEHLGCilw_Y9_11qcW8';
  static const requestPayload = {
    "context": {
      "client": {
        "clientName": "WEB",
        "clientVersion": "2.20210224.06.00",
        "newVisitorCookie": true
      },
      "user": {"lockedSafetyMode": false}
    },
    "client": {"hl": "en", "gl": "US"},
  };
  static const headers = {
    'User-Agent':
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.77 Safari/537.36',
    'Content-Type': 'application/json'
  };
  static const contentPath = [
    'contents',
    'twoColumnSearchResultsRenderer',
    'primaryContents',
    'sectionListRenderer',
    'contents'
  ];
  static const continuationContentPath = [
    'onResponseReceivedCommands',
    0,
    'appendContinuationItemsAction',
    'continuationItems'
  ];
  static const continuationKeyPath = [
    "continuationItemRenderer",
    "continuationEndpoint",
    "continuationCommand",
    "token",
  ];
}
