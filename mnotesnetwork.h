#ifndef MNOTESNETWORK_H
#define MNOTESNETWORK_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include<QNetworkReply>

class MNotesNetwork : public QObject
{
    Q_OBJECT
public:
    explicit MNotesNetwork(QObject *parent = 0);
   void MNotesRequest(const QString url,const QString user, const QString password);
   void getMNotesJson(const QByteArray data);
   void getMnotes();

private:
     void MNotesConnect();

     QNetworkAccessManager *manager;
     QNetworkRequest request;

signals:

public slots:
     void replyFinished(QNetworkReply *reply);

};

#endif // MNOTESNETWORK_H
