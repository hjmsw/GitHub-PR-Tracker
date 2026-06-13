#pragma once

#include <QJsonArray>
#include <QObject>
#include <QProcess>
#include <QSettings>
#include <QTimer>
#include <QtQml/qqmlregistration.h>

class PrFetcher : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    QML_SINGLETON

    Q_PROPERTY(QString workingDirectory READ workingDirectory WRITE setWorkingDirectory NOTIFY workingDirectoryChanged)
    Q_PROPERTY(bool showMyPRs READ showMyPRs WRITE setShowMyPRs NOTIFY showMyPRsChanged)
    Q_PROPERTY(bool showReviewRequested READ showReviewRequested WRITE setShowReviewRequested NOTIFY showReviewRequestedChanged)

    Q_PROPERTY(QString repoTitle READ repoTitle NOTIFY repoTitleChanged)
    Q_PROPERTY(QJsonArray allPullRequests READ allPullRequests NOTIFY allPullRequestsChanged)
    Q_PROPERTY(QJsonArray myPullRequests READ myPullRequests NOTIFY myPullRequestsChanged)
    Q_PROPERTY(QJsonArray reviewRequestedPullRequests READ reviewRequestedPullRequests NOTIFY reviewRequestedPullRequestsChanged)

    Q_PROPERTY(bool repoTitleLoading READ repoTitleLoading NOTIFY repoTitleLoadingChanged)
    Q_PROPERTY(bool allLoading READ allLoading NOTIFY allLoadingChanged)
    Q_PROPERTY(bool myLoading READ myLoading NOTIFY myLoadingChanged)
    Q_PROPERTY(bool reviewLoading READ reviewLoading NOTIFY reviewLoadingChanged)

    Q_PROPERTY(QString lastError READ lastError NOTIFY lastErrorChanged)

public:
    explicit PrFetcher(QObject *parent = nullptr);

    QString workingDirectory() const { return m_workingDirectory; }
    void setWorkingDirectory(const QString &dir);

    bool showMyPRs() const { return m_showMyPRs; }
    void setShowMyPRs(bool show);

    bool showReviewRequested() const { return m_showReviewRequested; }
    void setShowReviewRequested(bool show);

    QString repoTitle() const { return m_repoTitle; }
    QJsonArray allPullRequests() const { return m_allPRs; }
    QJsonArray myPullRequests() const { return m_myPRs; }
    QJsonArray reviewRequestedPullRequests() const { return m_reviewPRs; }

    bool repoTitleLoading() const { return m_repoTitleLoading; }
    bool allLoading() const { return m_allLoading; }
    bool myLoading() const { return m_myLoading; }
    bool reviewLoading() const { return m_reviewLoading; }

    QString lastError() const { return m_lastError; }

public slots:
    void refresh();

signals:
    void repoTitleChanged();
    void workingDirectoryChanged();
    void showMyPRsChanged();
    void showReviewRequestedChanged();
    void allPullRequestsChanged();
    void myPullRequestsChanged();
    void reviewRequestedPullRequestsChanged();
    void repoTitleLoadingChanged();
    void allLoadingChanged();
    void myLoadingChanged();
    void reviewLoadingChanged();
    void lastErrorChanged();

private:
    enum class FetchType { All, Mine, ReviewRequested };

    void runFetch(FetchType type);
    QStringList buildArgs(FetchType type) const;
    void setLastError(const QString &error);

    void runFetchRepoTitle();
    void runFetchPrTitle();

    QSettings m_settings;
    QTimer m_refreshTimer;

    QString m_workingDirectory;
    bool m_showMyPRs = true;
    bool m_showReviewRequested = true;

    QString m_repoTitle;
    QJsonArray m_allPRs;
    QJsonArray m_myPRs;
    QJsonArray m_reviewPRs;

    bool m_repoTitleLoading = false;
    bool m_allLoading = false;
    bool m_myLoading = false;
    bool m_reviewLoading = false;

    QString m_lastError;

    static const QString k_fields;
    static const int k_refreshIntervalMs = 300'000; // 5 minutes
};
