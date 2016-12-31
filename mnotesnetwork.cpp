#include "mnotesnetwork.h"

MNotesNetwork::MNotesNetwork(QObject *parent) : QObject(parent)
    {
        MNotesConnect();
    }

void MNotesNetwork::MNotesConnect()
    {
         manager = new QNetworkAccessManager(this);
         connect(manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(replyFinished(QNetworkReply*)));
    }

void MNotesNetwork::MNotesRequest(const QString url,const QString user, const QString password)
    {
        QByteArray auth;
        auth.append(user);
        auth.append(":");
        auth.append(password);
        request.setUrl(QUrl(url));
        request.setRawHeader("User-Agent", "MNotes");
        request.setRawHeader("Authorization",  "Basic " + auth.toBase64());
    }

void MNotesNetwork::getMNotesJson(const QByteArray data)
    {
     //   qDebug() << data;
      //  qDebug() << request.rawHeader("Authorization");
        request.setRawHeader("Content-type", "application/json");
         manager->post(request,data);

    }

void MNotesNetwork::getMnotes()
    {
        manager->get(request);
    }

/***
 * ### SLOTS ###
 * **/
void MNotesNetwork::replyFinished(QNetworkReply *reply)
    {
        if(reply->error())
            {
                qDebug() << "ERROR!";
                qDebug() << reply->errorString();
                return;
            }
        QString ctype = reply->rawHeader("Content-Type");
        qDebug() << ctype;
        QByteArray data = reply->readAll();
     //  qDebug() <<  QString::fr( data);
        reply->deleteLater();
    }
