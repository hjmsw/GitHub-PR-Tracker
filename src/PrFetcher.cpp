#include "PrFetcher.h"

#include <QDir>
#include <QJsonDocument>
#include <QJsonObject>

const QString PrFetcher::k_fields =
    QStringLiteral("number,title,state,author,mergeable,url,reviewDecision,"
                   "headRefName,baseRefName,additions,deletions,createdAt");

PrFetcher::PrFetcher(QObject *parent)
    : QObject(parent)
    , m_settings(QStringLiteral("me.jamesharding"), QStringLiteral("prtracker"))
{
    m_workingDirectory = m_settings.value(QStringLiteral("workingDirectory"), QDir::homePath()).toString();
    m_showMyPRs = m_settings.value(QStringLiteral("showMyPRs"), true).toBool();
    m_showReviewRequested = m_settings.value(QStringLiteral("showReviewRequested"), true).toBool();

    m_refreshTimer.setInterval(k_refreshIntervalMs);
    m_refreshTimer.setSingleShot(false);
    connect(&m_refreshTimer, &QTimer::timeout, this, &PrFetcher::refresh);
    m_refreshTimer.start();

    // Initial fetch
    refresh();
}

void PrFetcher::setWorkingDirectory(const QString &dir)
{
    if (m_workingDirectory == dir)
        return;
    m_workingDirectory = dir;
    m_settings.setValue(QStringLiteral("workingDirectory"), dir);
    emit workingDirectoryChanged();
    refresh();
    runFetchRepoTitle();
    m_refreshTimer.start(); // reset interval
}

void PrFetcher::setShowMyPRs(bool show)
{
    if (m_showMyPRs == show)
        return;
    m_showMyPRs = show;
    m_settings.setValue(QStringLiteral("showMyPRs"), show);
    emit showMyPRsChanged();
}

void PrFetcher::setShowReviewRequested(bool show)
{
    if (m_showReviewRequested == show)
        return;
    m_showReviewRequested = show;
    m_settings.setValue(QStringLiteral("showReviewRequested"), show);
    emit showReviewRequestedChanged();
}

void PrFetcher::refresh()
{
    if (m_repoTitle.isEmpty())
        runFetchRepoTitle();

    runFetch(FetchType::All);
    if (m_showMyPRs)
        runFetch(FetchType::Mine);
    if (m_showReviewRequested)
        runFetch(FetchType::ReviewRequested);
}

QStringList PrFetcher::buildArgs(FetchType type) const
{
    QStringList args = { QStringLiteral("pr"), QStringLiteral("list"),
                         QStringLiteral("--limit"), QStringLiteral("100"),
                         QStringLiteral("--json"), k_fields };
    switch (type) {
        case FetchType::Mine:
            args << QStringLiteral("--author") << QStringLiteral("@me");
            break;
        case FetchType::ReviewRequested:
            args << QStringLiteral("--search") << QStringLiteral("user-review-requested:@me");
            break;
        default:
            break;
    }
    return args;
}

void PrFetcher::runFetchRepoTitle()
{
    m_repoTitleLoading = true;
    emit repoTitleLoadingChanged();

    auto *process = new QProcess(this);
    process->setWorkingDirectory(m_workingDirectory);

    connect(process, &QProcess::finished, this, [this, process](int exitCode, QProcess::ExitStatus) {
        process->deleteLater();

        if (exitCode != 0) {
            setLastError(QString::fromUtf8(process->readAllStandardError()).trimmed());
        } else {
            setLastError(QString());
            const QByteArray output = process->readAllStandardOutput();
            const QJsonDocument doc = QJsonDocument::fromJson(output);
            if (doc.isObject())
                m_repoTitle = doc.object().value(QStringLiteral("nameWithOwner")).toString();
        }

        m_repoTitleLoading = false;
        emit repoTitleChanged();
        emit repoTitleLoadingChanged();
    });

    process->start(QStringLiteral("gh"), {
        QStringLiteral("repo"), QStringLiteral("view"),
        QStringLiteral("--json"), QStringLiteral("nameWithOwner")
    });
}

void PrFetcher::runFetch(FetchType type)
{
    // Set loading state
    switch (type) {
        case FetchType::All:
            m_allLoading = true;
            emit allLoadingChanged();
            break;
        case FetchType::Mine:
            m_myLoading = true;
            emit myLoadingChanged();
            break;
        case FetchType::ReviewRequested:
            m_reviewLoading = true;
            emit reviewLoadingChanged();
            break;
    }

    auto *process = new QProcess(this);
    process->setWorkingDirectory(m_workingDirectory);

    connect(process, &QProcess::finished, this, [this, process, type](int exitCode, QProcess::ExitStatus) {
        process->deleteLater();

        if (exitCode != 0) {
            setLastError(QString::fromUtf8(process->readAllStandardError()).trimmed());
        } else {
            setLastError(QString());
        }

        const QByteArray output = process->readAllStandardOutput();
        QJsonParseError parseError;
        const QJsonDocument doc = QJsonDocument::fromJson(output, &parseError);

        QJsonArray result;
        if (parseError.error == QJsonParseError::NoError && doc.isArray())
            result = doc.array();

        switch (type) {
            case FetchType::All:
                m_allPRs = result;
                m_allLoading = false;
                emit allPullRequestsChanged();
                emit allLoadingChanged();
                break;
            case FetchType::Mine:
                m_myPRs = result;
                m_myLoading = false;
                emit myPullRequestsChanged();
                emit myLoadingChanged();
                break;
            case FetchType::ReviewRequested:
                m_reviewPRs = result;
                m_reviewLoading = false;
                emit reviewRequestedPullRequestsChanged();
                emit reviewLoadingChanged();
                break;
        }
    });

    process->start(QStringLiteral("gh"), buildArgs(type));
}

void PrFetcher::setLastError(const QString &error)
{
    if (m_lastError == error)
        return;
    m_lastError = error;
    emit lastErrorChanged();
}
