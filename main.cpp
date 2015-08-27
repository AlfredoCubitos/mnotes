#include <QApplication>
#include <QQmlApplicationEngine>

#include <QtGui>
#include <QtQml>

#include <QDebug>

#include "mnoteshandler.h"

int main(int argc, char *argv[])
{

    QApplication app(argc, argv);

    app.setWindowIcon(QIcon(QPixmap(":/images/notes.png")));

    QQmlApplicationEngine engine;
    QQmlComponent component(&engine,QUrl(QStringLiteral("qrc:/main.qml")));
    qmlRegisterType<MNotesHandler>("de.bibuweb.mnotes",1,0,"MNotesHandler");
    // engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    QObject *noteApp = component.create();

    MNotesHandler mnotes;

    QObject::connect(noteApp,SIGNAL(sbSignal(QString)),&mnotes,SLOT(searchSignal(QString)));
    QObject::connect(noteApp,SIGNAL(winSignal(QVariant)),&mnotes,SLOT(winSignal(QVariant)));



    return app.exec();
}
