#include <QApplication>
#include <QQmlApplicationEngine>

#include <QtGui>
#include <QtQml>

#include <QDebug>

#include "mnoteshandler.h"
#include "mnotesconfig.h"

int main(int argc, char *argv[])
{

    QApplication app(argc, argv);

    app.setWindowIcon(QIcon(QPixmap(":/images/notes.png")));

    QQmlApplicationEngine engine;
    QQmlComponent component(&engine,QUrl(QStringLiteral("qrc:/main.qml")));
    qmlRegisterType<MNotesHandler>("de.bibuweb.mnotes",1,0,"MNotesHandler");
    // engine.load(QUrl(QStringLiteral("qrc:/main.qml")));




    MNotesHandler mnotes;
    MnotesConfig config;

    QVariantList groups = config.readGroups();

    QObject *noteApp = component.create();

  //  QMetaObject::invokeMethod(noteApp,"addMenuItem",Q_ARG(QVariant, groups));

    QObject::connect(noteApp,SIGNAL(sbSignal(QString)),&mnotes,SLOT(searchSignal(QString)));
    QObject::connect(noteApp,SIGNAL(sbActiveSignal(QVariant)),&mnotes,SLOT(activeSb(QVariant)));
    QObject::connect(noteApp,SIGNAL(winSignal(QVariant)),&mnotes,SLOT(winSignal(QVariant)));
    QObject::connect(noteApp,SIGNAL(dialogOkSignal(QVariant)),&config,SLOT(getDlgData(QVariant)));
    QObject::connect(noteApp,SIGNAL(dialogSetGroups()),&mnotes,SLOT(setDialogGroups()));
    QObject::connect(&mnotes,SIGNAL(curposChanged(const char*,QObject*)),&mnotes,SLOT(callQmlFuntion(const char*,QObject*)));



    return app.exec();
}
