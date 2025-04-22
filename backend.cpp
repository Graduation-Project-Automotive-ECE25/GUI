#include "backend.h"
#include <QDebug>

// Constructor: Initializes Backend object, sets default values, and connects the serial port to read data.
Backend::Backend(QObject *parent) : QObject(parent), m_speedValue(0),m_latitude(0.0),
    m_longitude(0.0),serial(new QSerialPort(this)) {
    connect(serial, &QSerialPort::readyRead, this, &Backend::readSerialData);
}

// Destructor: Ensures the serial port is closed before destroying the object.
Backend::~Backend() {
    if (serial->isOpen()) {
        serial->close();
    }
}

// Returns a list of available serial ports on the system.
QStringList Backend::availableSerialPorts() {
    QStringList ports;
    for (const QSerialPortInfo &port : QSerialPortInfo::availablePorts()) {
        ports.append(port.portName());
    }
    return ports;
}

// Getter methods for speed, latitude, longitude, and warning messages.
int Backend::speedValue() const { return m_speedValue; }
double Backend::latitude() const { return m_latitude; }
double Backend::longitude() const { return m_longitude; }
QString Backend::warningMessage() const { return m_warningMessage; }
QString Backend::signMessage() const { return m_signMessage; }

// Sets speed value and emits signal if the value changes. Limits speed to 120.
void Backend::setSpeedValue(int value) {
    if (m_speedValue != value) {
        if(value > 120){
            value = 120;
        }
        m_speedValue = value;
        emit speedValueChanged();
    }
}

// Sets latitude and emits a change signal.
void Backend::setLatitudeValue(int value) {
    if (m_latitude != value) {
        m_latitude = value;
        emit latitudeChanged();
    }
}

// Sets longitude and emits a change signal.
void Backend::setLongitudeValue(int value) {
    if (m_longitude != value) {
        m_longitude = value;
        emit longitudeChanged();
    }
}

// Sets a warning message only if it's different and meets specific conditions.
void Backend::setWarningMessage(const QString &message) {
    if (m_warningMessage != message) {
        m_warningMessage = message;
        if((messageCheck == 11) || (messageCheck == 44) || (messageCheck == 22))
        {
            emit warningMessageChanged();
            m_warningMessage="";
        }
    }
}

// Sets sign message and emits a change signal, then clears the message.
void Backend::setSignMessage(const QString &message) {
    if (m_signMessage != message) {
        m_signMessage = message;
        emit signMessageChanged();
        m_signMessage = ""; // Resets sign message
    }
}

// Opens a serial port with specific settings.
void Backend::openSerialPort(const QString &port_name) {
    if (serial->isOpen()) {
        qDebug() << "Serial port already open!";
        return;
    }

    serial->setPortName(port_name);
    serial->setBaudRate(QSerialPort::Baud9600);
    serial->setDataBits(QSerialPort::Data8);
    serial->setParity(QSerialPort::NoParity);
    serial->setStopBits(QSerialPort::OneStop);
    serial->setFlowControl(QSerialPort::NoFlowControl);

    if (serial->open(QIODevice::ReadOnly)) {
        qDebug() << "Serial port has been opened:" << port_name;
    } else {
        qDebug() << "Failed to open serial port:" << serial->errorString();
    }
}

// Closes the serial port if it is open.
void Backend::stopSerialPort() {
    if (serial->isOpen()) {
        serial->close();
        qDebug() << "Serial port closed.";
    }
    else{
        qDebug() << "Serial port is closed already.";
    }
}

// Reads data from the serial port, extracts messages, and processes them.
void Backend::readSerialData() {
    QString receivedData;
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

    // Example: Expecting data in format "Speed: 120; Warning: OverLimit"
    QStringList parts = receivedData.split(";");
    handleRecievedWarningMessage(parts);
}

// Handles received warning messages based on predefined codes.
void Backend::handleRecievedWarningMessage(QStringList receivedList) {
    QString code;
    QString speedStr;
    bool ok;
    int speed;
    messageCheck = 0;

    if (receivedList.size() >= 1) {
        code = receivedList.value(0);

        if (code == "v") { // Speed warning
            speedStr = receivedList.value(1);
            speed = speedStr.toInt(&ok);
            if (ok) {
                setSpeedValue(speed);
            }
            if(speed >= 100){
                messageCheck = 11;
                setWarningMessage("WARNING\nOVER SPEED");
            }
        }
        // else if(code == "22"){ // Adaptive Cruise Control activation
        //     messageCheck = 22;
        //     setWarningMessage("WARNING\nAdaptive Cruise Activated");
        // }
        else if(code == "b"){ // Blind Spot Detection
            messageCheck = 44;
            setWarningMessage("WARNING\nBlind Spot Detected");
        }
        else if((code == "r") || (code == "l")){ // Traffic sign detection
            setSignMessage(code);
        }
        else if(code == "x"){ // GPS Latitude data
            setLatitudeValue(receivedList.value(1).toDouble());
            qDebug() << "latitude";
        }
        else if(code == "y"){ // GPS Longitude data
            setLongitudeValue(receivedList.value(1).toDouble());
            qDebug() << "longitude";
        }
        else{
            /* Unknown message, do nothing */
        }
    }
}

// Opens a terminal emulator (Linux-specific).
void Backend::openTerminal() {
    QString homeDir = QDir::homePath();
    QProcess::startDetached("x-terminal-emulator", {}, homeDir);
}

// Reboots the system (Linux-specific).
void Backend::rebootSystem() {
    QProcess::startDetached("reboot"); // Linux
}

// Opens the default camera application (Linux-specific).
void Backend::openCamera() {
    // QProcess::startDetached("cheese"); // Linux
    QString scriptDir = "/usr/bin";
    QString scriptPath = scriptDir + "/lane-detection";
    QString program = "python3";
    QStringList arguments;
    arguments << scriptPath;

    QProcess::startDetached(program, arguments, scriptDir);
}

void Backend::projectInfo() {
    QString projectDir = QDir::currentPath();  // This gets the current working directory
    QString scriptPath = projectDir + "/../../ProjectInfo.py";
    QString program = "python3";

    // Check if the file exists to avoid running a non-existing file
    if (!QFile::exists(scriptPath)) {
        qWarning() << "Script not found: " << scriptPath;
        return;
    }

    QStringList arguments;
    arguments << scriptPath;

    QProcess::startDetached(program, arguments, projectDir);
}

// Clears the warning message.
void Backend::clearWarningMessage() {
    setWarningMessage("");
}
