#ifndef BACKEND_H
#define BACKEND_H

#include <QtSerialPort/QSerialPort>
#include <QtSerialPort/QSerialPortInfo>
#include <QObject>
#include <QProcess>
#include <QDir>
class Backend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int speedValue READ speedValue WRITE setSpeedValue NOTIFY speedValueChanged FINAL)
    Q_PROPERTY(QString warningMessage READ warningMessage WRITE setWarningMessage NOTIFY warningMessageChanged FINAL)
    Q_PROPERTY(QString signMessage READ signMessage WRITE setSignMessage NOTIFY signMessageChanged FINAL)
    Q_PROPERTY(double latitude READ latitude WRITE setLatitudeValue NOTIFY latitudeChanged FINAL)
    Q_PROPERTY(double longitude READ longitude WRITE setLongitudeValue NOTIFY longitudeChanged FINAL)
public:
    explicit Backend(QObject *parent = nullptr);
    ~Backend();
    int speedValue() const;

    double latitude() const;
    double longitude() const;

    QString warningMessage() const;
    QString signMessage() const;

    Q_INVOKABLE void openSerialPort(const QString &port_name);
    Q_INVOKABLE void stopSerialPort();
    Q_INVOKABLE QStringList availableSerialPorts();

    Q_INVOKABLE void openTerminal();
    Q_INVOKABLE void rebootSystem();
    Q_INVOKABLE void openCamera();
    Q_INVOKABLE void projectInfo();
    Q_INVOKABLE void clearWarningMessage();
    /***********************MACROS*************************/
    #define SpeedValue        11
    #define BlindSpot         44
    #define TurnSignal        33
    #define AdabtiveCruis     22
    #define Latitude          55
    #define Longtitude        66

signals:
    void speedValueChanged();
    void warningMessageChanged();
    void signMessageChanged();
    void latitudeChanged();
    void longitudeChanged();
private slots:
    void readSerialData();

private:
    int m_speedValue;
    QString m_warningMessage;
    QString m_signMessage;
    int messageCheck;
    double m_latitude;
    double m_longitude;
    QSerialPort *serial;

    void handleRecievedWarningMessage(QStringList receivedList);
    void setSpeedValue(int value);
    void setLatitudeValue(int value);
    void setLongitudeValue(int value);
    void setWarningMessage(const QString &message);
    void setSignMessage(const QString &message);
};

#endif // BACKEND_H
