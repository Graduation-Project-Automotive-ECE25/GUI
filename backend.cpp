#include "backend.h"
#include <QDebug>

Backend::Backend(QObject *parent) : QObject(parent), m_speedValue(0), serial(new QSerialPort(this)) {
    connect(serial, &QSerialPort::readyRead, this, &Backend::readSerialData);
}

Backend::~Backend() {
    if (serial->isOpen()) {
        serial->close();
    }
}
QStringList Backend::availableSerialPorts() {
    QStringList ports;
    for (const QSerialPortInfo &port : QSerialPortInfo::availablePorts()) {
        ports.append(port.portName());
    }
    return ports;
}
int Backend::speedValue() const {
    return m_speedValue;
}

void Backend::setSpeedValue(int value) {
    if (m_speedValue != value) {
        if(value > 120){
            value = 120;
        }
        m_speedValue = value;
        emit speedValueChanged();
    }
}

QString Backend::warningMessage() const {
    return m_warningMessage;
}

QString Backend::signMessage() const
{
    return m_signMessage;
}

void Backend::setWarningMessage(const QString &message) {
    if (m_warningMessage != message) {
        m_warningMessage = message;
        if((messageCheck == 11) || (messageCheck == 44) || (messageCheck == 22))
            emit warningMessageChanged();
    }
}

void Backend::setSignMessage(const QString &message)
{
    if (m_signMessage != message) {
        m_signMessage = message;
        emit signMessageChanged();
        m_signMessage = "";
    }
}

void Backend::openSerialPort(const QString &port_name) {
    if (serial->isOpen()) {
        qDebug() << "Serial port already open!";
        return;
    }

    serial->setPortName(port_name);
    serial->setBaudRate(QSerialPort::Baud115200);
    serial->setDataBits(QSerialPort::Data8);
    serial->setParity(QSerialPort::NoParity);
    serial->setStopBits(QSerialPort::OneStop);
    serial->setFlowControl(QSerialPort::NoFlowControl);

    if (serial->open(QIODevice::ReadOnly)) {
        qDebug() << "Opened serial port:" << port_name;
    } else {
        qDebug() << "Failed to open serial port:" << serial->errorString();
    }
}

void Backend::stopSerialPort() {
    if (serial->isOpen()) {
        serial->close();
        qDebug() << "Serial port closed.";
    }
}

void Backend::readSerialData() {
    QString receivedData ;
    int newlineIndex = 0;
    static QByteArray buffer;
    QByteArray data = serial->readAll();
    buffer.append(data);

    while ((newlineIndex = buffer.indexOf('\n')) != -1) {  // Check for newline character
        QByteArray completeMessage = buffer.left(newlineIndex);  // Extract the message
        buffer.remove(0, newlineIndex + 1);  // Remove processed message from the buffer

        receivedData = QString::fromUtf8(completeMessage).trimmed();  // Convert to QString
    }

    qDebug() << "Received data:" << receivedData;

    // Example: Expecting data in format "Speed: 120, Warning: OverLimit"
    QStringList parts = receivedData.split(";");
    handleRecievedWarningMessage(parts);

}

void Backend::handleRecievedWarningMessage(QStringList receivedList)
{
    QString code ;
    QString speedStr ;
    QString warningStr;
    bool ok;
    int speed ;
    messageCheck = 0;
    if (receivedList.size() >= 2) {
        code = receivedList.value(0);
        if (code == "11") {

            speedStr = receivedList.value(1);
            warningStr = receivedList.value(2);
            speed = speedStr.toInt(&ok);
            if (ok) {
                setSpeedValue(speed);
            }
            if(warningStr == "OVER_SPEED"){
                messageCheck = 11;
            }
            setWarningMessage(warningStr);
        }
        if(code == "22"){
            messageCheck = 22;
            warningStr = receivedList.value(1);
            setWarningMessage(warningStr);
        }
        if(code == "33"){
            messageCheck = 33;
            warningStr = receivedList.value(1);
            setSignMessage(warningStr);
        }
        if(code == "44"){
            messageCheck = 44;
            warningStr = receivedList.value(1);
            setWarningMessage(warningStr);
        }

        /*
        QString speedStr = receivedList.value(0);
        QString warningStr = receivedList.value(1);
        bool ok;
        int speed = speedStr.toInt(&ok);

        if (ok) {
            setSpeedValue(speed);
        }
        setWarningMessage(warningStr); */
        code = "";
    }
}

void Backend::openTerminal()
{
    QProcess::startDetached("x-terminal-emulator"); // Linux
}

void Backend::rebootSystem()
{
    QProcess::startDetached("reboot"); // Linux
}

void Backend::openCamera()
{
    QProcess::startDetached("cheese"); // Linux
}

void Backend::clearWarningMessage()
{
    setWarningMessage("");
}
