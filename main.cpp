#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtGui>
#include <QtQml>
#include <QDebug>


#include "mnoteshandler.h"
#include "mnotesconfig.h"
#include "mnotesnetwork.h"





int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    qputenv("QT_AUTO_SCREEN_SCALE_FACTOR", "1");



    app.setWindowIcon(QIcon(QPixmap(":/images/notes.png")));

    qmlRegisterType<MNotesHandler>("de.bibuweb.mnotes",1,0,"MNotesHandler");
    qmlRegisterType<MnotesConfig>("de.bibuweb.mnotes",1,0,"MnotesConfig");

    QQmlApplicationEngine engine;
    QQmlComponent component(&engine,QUrl(QStringLiteral("qrc:/main.qml")));


    MNotesHandler mnotes;
    MnotesConfig config;

    MNotesNetwork network;


    QQmlContext *context = new QQmlContext(engine.rootContext());
    context->setContextProperty("configData",&config);
    context->setContextProperty("netWork",&network);

   // QVariantList groups = config.readGroups();

    QObject *noteApp = component.create(context);

  //  QMetaObject::invokeMethod(noteApp,"addMenuItem",Q_ARG(QVariant, groups));


    QObject::connect(noteApp,SIGNAL(sbSignal(QString)),&mnotes,SLOT(searchSignal(QString)));
    QObject::connect(noteApp,SIGNAL(sbActiveSignal(QVariant)),&mnotes,SLOT(activeSb(QVariant)));
    QObject::connect(noteApp,SIGNAL(winSignal(QVariant)),&mnotes,SLOT(winSignal(QVariant)));
    QObject::connect(noteApp,SIGNAL(dialogSetGroups()),&mnotes,SLOT(setDialogGroups()));
    QObject::connect(&mnotes,SIGNAL(curposChanged(const char*,QObject*)),&mnotes,SLOT(callQmlFuntion(const char*,QObject*)));


    return app.exec();
}
