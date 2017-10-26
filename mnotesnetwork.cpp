#include "mnotesnetwork.h"


MNotesNetwork::MNotesNetwork(QObject *parent) : QObject(parent)
{

    MNotesConnect();

}

MNotesNetwork::MNotesNetwork(QString group)
{

    MNotesConnect();

    if (group.length() > 0)
    {
        account = config.readConfig(group);
        MNotesRequestAuth(account);
    }
}

void MNotesNetwork::MNotesConnect()
{
    manager = new QNetworkAccessManager(this);
    connect(manager, SIGNAL(finished(QNetworkReply*)), this, SLOT(replyFinished(QNetworkReply*)));
}

void MNotesNetwork::MNotesRequestAuth(QJsonObject account)
{
    QByteArray auth;
    auth.append(account["login"].toString());
    auth.append(":");
    auth.append(account["password"].toString());
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

void MNotesNetwork::getMnotes(const QString url)
{
    QString uri = account["url"].toString();
    uri.append(url);
    qDebug() << "URI: " << uri;
    request.setUrl(QUrl(uri));
    m_getRequest();
}

void MNotesNetwork::delMnote(const QString url)
{
    QString uri = account["url"].toString();
    uri.append(url);
    request.setUrl(QUrl(uri));
    m_deleteRequest();
}

void MNotesNetwork::updateMnote(const QString url, const QByteArray data)
{
    QString uri = account["url"].toString();
    uri.append(url);
    request.setUrl(QUrl(uri));
    request.setRawHeader("Content-Type","application/json");
    m_putRequest(data);
}

void MNotesNetwork::newMnote(const QString url, const QByteArray data)
{
    QString uri = account["url"].toString();
    uri.append(url);
    request.setUrl(QUrl(uri));
    request.setRawHeader("Content-Type","application/json");
    m_postRequest(data);
}

void MNotesNetwork::m_getRequest()
{
     manager->get(request);
}

void MNotesNetwork::m_postRequest(const QByteArray data)
{
    manager->post(request,data);
}
void MNotesNetwork::m_putRequest(const QByteArray data)
{
    manager->put(request,data);
}
void MNotesNetwork::m_deleteRequest()
{
    manager->deleteResource(request);
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
     //   QString ctype = reply->rawHeader("Content-Type");
        QByteArray data = reply->readAll();

      // result = QString::fromUtf8( data);
       // qDebug() << "Data: " << QString::fromUtf8( data);

       emit resultAvailable(QString::fromUtf8( data));

     //  qDebug() <<  QString::fr( data);
        reply->deleteLater();
    }
