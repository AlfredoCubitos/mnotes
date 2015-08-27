#include <QApplication>
#include <QQmlApplicationEngine>

#include <QtGui>
#include <QtQml>

int main(int argc, char *argv[])
{

    QApplication app(argc, argv);

    app.setWindowIcon(QIcon(QPixmap(":/images/notes.png")));

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}