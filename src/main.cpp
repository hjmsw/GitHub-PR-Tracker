#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QUrl>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName(QStringLiteral("me.jamesharding"));
    app.setOrganizationDomain(QStringLiteral("jamesharding.me"));
    app.setApplicationName(QStringLiteral("prtracker-desktop"));
    app.setApplicationVersion(QStringLiteral("1.0.0"));

    QQmlApplicationEngine engine;

    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreationFailed,
        &app, []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.load(QUrl(QStringLiteral("qrc:/qt/qml/prtracker/qml/main.qml")));

    return app.exec();
}
