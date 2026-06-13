pragma Singleton
import QtQuick

QtObject {
    id: root

    property string workingDirectory: "/home/james/workspace/test-repo"
    property string repoTitle: "Test/test-repo"
    property bool showMyPRs: true
    property bool showReviewRequested: true

    property bool allLoading: false
    property bool myLoading: false
    property bool reviewLoading: false

    property string lastError: ""

    readonly property var allPullRequests: _all
    readonly property var myPullRequests: _mine
    readonly property var reviewRequestedPullRequests: _review

    function refresh() {
        console.log("[mock] refresh() called")
    }

    readonly property var _all: [
        {
            number: 42,
            title: "feat: add dark mode support to the settings panel",
            state: "OPEN",
            author: { login: "alice" },
            mergeable: "MERGEABLE",
            url: "https://github.com/example/repo/pull/42",
            reviewDecision: "APPROVED",
            headRefName: "feat/dark-mode",
            baseRefName: "main",
            additions: 312,
            deletions: 45,
            createdAt: "2026-06-10T09:23:00Z"
        },
        {
            number: 38,
            title: "fix: resolve race condition in data fetcher that causes intermittent crashes on slow connections",
            state: "OPEN",
            author: { login: "bob" },
            mergeable: "CONFLICTING",
            url: "https://github.com/example/repo/pull/38",
            reviewDecision: "CHANGES_REQUESTED",
            headRefName: "fix/race-condition",
            baseRefName: "main",
            additions: 28,
            deletions: 14,
            createdAt: "2026-06-08T14:01:00Z"
        },
        {
            number: 35,
            title: "chore: bump dependencies to latest versions",
            state: "OPEN",
            author: { login: "carol" },
            mergeable: "MERGEABLE",
            url: "https://github.com/example/repo/pull/35",
            reviewDecision: "REVIEW_REQUIRED",
            headRefName: "chore/bump-deps",
            baseRefName: "main",
            additions: 5,
            deletions: 5,
            createdAt: "2026-06-07T11:45:00Z"
        },
        {
            number: 31,
            title: "docs: update README with new setup instructions",
            state: "OPEN",
            author: { login: "dave" },
            mergeable: "MERGEABLE",
            url: "https://github.com/example/repo/pull/31",
            reviewDecision: "",
            headRefName: "docs/readme",
            baseRefName: "main",
            additions: 88,
            deletions: 22,
            createdAt: "2026-06-05T08:00:00Z"
        }
    ]

    readonly property var _mine: [_all[0], _all[2]]
    readonly property var _review: [_all[1]]
}
