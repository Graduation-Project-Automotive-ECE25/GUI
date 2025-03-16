#ifndef BACKEND_H
#define BACKEND_H

#include <QtSerialPort/QSerialPort>
#include <QtSerialPort/QSerialPortInfo>
#include <QObject>
#include <QProcess>
class Backend : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int speedValue READ speedValue WRITE setSpeedValue NOTIFY speedValueChanged FINAL)
    Q_PROPERTY(QString warningMessage READ warningMessage WRITE setWarningMessage NOTIFY warningMessageChanged FINAL)
    Q_PROPERTY(QString signMessage READ signMessage WRITE setSignMessage NOTIFY signMessageChanged FINAL)
public:
    explicit Backend(QObject *parent = nullptr);
    ~Backend();
    int speedValue() const;


    QString warningMessage() const;
    QString signMessage() const;

    Q_INVOKABLE void openSerialPort(const QString &port_name);
    Q_INVOKABLE void stopSerialPort();
    Q_INVOKABLE QStringList availableSerialPorts();

    Q_INVOKABLE void openTerminal();
    Q_INVOKABLE void rebootSystem();
    Q_INVOKABLE void openCamera();
    Q_INVOKABLE void clearWarningMessage();
    /***********************MACROS*************************/
    #define SpeedValue        11
    #define BlindSpot         44
    #define TurnSignal        33
    #define AdabtiveCruis     22
signals:
    void speedValueChanged();
    void warningMessageChanged();
    void signMessageChanged();

private slots:
    void readSerialData();

private:
    int m_speedValue;
    QString m_warningMessage;
    QString m_signMessage;
    int messageCheck;
    QSerialPort *serial;

    void handleRecievedWarningMessage(QStringList receivedList);
    void setSpeedValue(int value);
    void setWarningMessage(const QString &message);
    void setSignMessage(const QString &message);
};

#endif // BACKEND_H
