#include "GeoLocationHandler.h"
#include <QFile>
#include <QTextStream>
#include <QDebug>

GeoLocationHandler::GeoLocationHandler(QObject *parent)
    : QObject(parent), m_latitude(0.0), m_longitude(0.0) {}

double GeoLocationHandler::latitude() const {
    return m_latitude;
}

double GeoLocationHandler::longitude() const {
    return m_longitude;
}

bool GeoLocationHandler::loadFromFile(const QString &filePath) {
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Could not open file:" << filePath;
        return false;
    }

    QTextStream in(&file);
    while (!in.atEnd()) {
        QString line = in.readLine();
        if (line.startsWith("latitude:")) {
            m_latitude = line.split(":")[1].trimmed().toDouble();
            emit latitudeChanged();
        } else if (line.startsWith("longitude:")) {
            m_longitude = line.split(":")[1].trimmed().toDouble();
            emit longitudeChanged();
        }
    }
    file.close();

    return true;
}
