#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "GeoLocationHandler.h"
#include "backend.h"


int main(int argc, char *argv[])
{
#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif
    QGuiApplication app(argc, argv);
    Backend backend;
    QQmlApplicationEngine engine;
    //////////////////////////////////////////////////////////////////////////
    // Create GeoLocationHandler instance
    GeoLocationHandler geoHandler;
    engine.rootContext()->setContextProperty("geoHandler", &geoHandler);
    //////////////////////////////////////////////////////////////////////////
    // Register the SerialPort wrapper for QML
    qmlRegisterType<Backend>("com.example.serial", 1, 0, "SerialPort");
    //////////////////////////////////////////////////////////////////////////


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

    // Set Backend as a singleton in QML
    engine.rootContext()->setContextProperty("backend", &backend);

    engine.loadFromModule("qt6_serial_data", "Main");
    engine.load(url);

    return app.exec();
}
