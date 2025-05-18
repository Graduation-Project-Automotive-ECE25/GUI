#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtWebEngineQuick>
#include "GeoLocationHandler.h"
#include "backend.h"

int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif


    QtWebEngineQuick::initialize();

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // Register and connect backend
    Backend backend;
    engine.rootContext()->setContextProperty("backend", &backend);

    // Register geolocation handler
    GeoLocationHandler geoHandler;
    engine.rootContext()->setContextProperty("geoHandler", &geoHandler);

    // Register custom QML type if needed
    qmlRegisterType<Backend>("com.example.serial", 1, 0, "SerialPort");

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
