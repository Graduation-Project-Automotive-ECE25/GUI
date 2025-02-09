#ifndef GEOLOCATIONHANDLER_H
#define GEOLOCATIONHANDLER_H

#include <QObject>

class GeoLocationHandler : public QObject {
    Q_OBJECT
    Q_PROPERTY(double latitude READ latitude NOTIFY latitudeChanged)
    Q_PROPERTY(double longitude READ longitude NOTIFY longitudeChanged)

public:
    explicit GeoLocationHandler(QObject *parent = nullptr);

    double latitude() const;
    double longitude() const;

    Q_INVOKABLE bool loadFromFile(const QString &filePath);

signals:
    void latitudeChanged();
    void longitudeChanged();

private:
    double m_latitude;
    double m_longitude;
};

#endif // GEOLOCATIONHANDLER_H
