#include <QApplication>
#include <QQmlApplicationEngine>
#include <QtGui>
#include <QtQml>
#include <QDebug>
#include <QtWebView/QtWebView>

#include "mnoteshandler.h"
#include "mnotesconfig.h"
#include "mnotesnetwork.h"
#include "msonenoteapi.h"

#include "OAuth/o2.h"
#include "OAuth/o2msgraph.h"
#include "OAuth/o2requestor.h"


int main(int argc, char *argv[])
{
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    qputenv("QT_AUTO_SCREEN_SCALE_FACTOR", "1");
    QApplication app(argc, argv);
    QtWebView::initialize();

    app.setWindowIcon(QIcon(QPixmap(":/images/notes.png")));

    QQmlApplicationEngine engine;
    QQmlComponent component(&engine,QUrl(QStringLiteral("qrc:/main.qml")));
    qmlRegisterType<MNotesHandler>("de.bibuweb.mnotes",1,0,"MNotesHandler");
    qmlRegisterType<MSGraph>("de.bibuweb.mnotes",1,0,"MSGraph");
    qmlRegisterType<MSOneNoteApi>("de.bibuweb.mnotes",1,0,"MSOneNoteApi");
//    qmlRegisterType<MSOneNoteModell>("de.bibuweb.mnotes",1,0,"MSOneNoteModell");

    MNotesHandler mnotes;
    MnotesConfig config;

    QQmlContext *context = new QQmlContext(engine.rootContext());
    context->setContextProperty("configData",&config);


   // QVariantList groups = config.readGroups();

    QObject *noteApp = component.create(context);

  //  QMetaObject::invokeMethod(noteApp,"addMenuItem",Q_ARG(QVariant, groups));


    QObject::connect(noteApp,SIGNAL(sbSignal(QString)),&mnotes,SLOT(searchSignal(QString)));
    QObject::connect(noteApp,SIGNAL(sbActiveSignal(QVariant)),&mnotes,SLOT(activeSb(QVariant)));
    QObject::connect(noteApp,SIGNAL(winSignal(QVariant)),&mnotes,SLOT(winSignal(QVariant)));
    QObject::connect(noteApp,SIGNAL(dialogOkSignal(QVariant)),&config,SLOT(getDlgData(QVariant)));
    QObject::connect(noteApp,SIGNAL(dialogSetGroups()),&mnotes,SLOT(setDialogGroups()));
    QObject::connect(&mnotes,SIGNAL(curposChanged(const char*,QObject*)),&mnotes,SLOT(callQmlFuntion(const char*,QObject*)));

    return app.exec();
}
