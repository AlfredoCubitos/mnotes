#ifndef MNOTESNETWORK_H
#define MNOTESNETWORK_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonObject>

#include "mnotesconfig.h"

class MNotesNetwork : public QObject
{
    Q_OBJECT
  // QString group;

public:
    explicit MNotesNetwork(QObject *parent = nullptr);


   void getMNotesJson(const QByteArray data);
   Q_INVOKABLE void getMnotes(const QString url);
   Q_INVOKABLE void delMnote(const QString url);
   Q_INVOKABLE void updateMnote(const QString url, const QByteArray data);
   Q_INVOKABLE void newMnote(const QString url, const QByteArray data);
   Q_INVOKABLE void initConnect(QString group);
  // Q_INVOKABLE void mnotesMSauth(QString code);
  // Q_INVOKABLE void getOneNotePages(const QString url);
   Q_INVOKABLE void clearNetwork();

 //  QString result;
signals:

Q_SIGNALS:
     void resultAvailable(const QString &result);

private:
     void MNotesConnect();
     void MNotesRequestAuth(QJsonObject account);
     void m_getRequest();
     void m_postRequest(const QByteArray data);
     void m_putRequest(const QByteArray data);
     void m_deleteRequest();


     MnotesConfig config;
     QJsonObject account;
     QNetworkAccessManager *manager;
     QNetworkRequest request;
     QByteArray m_reqData;
     QString method;

signals:



public slots:
public Q_SLOTS:
    void replyFinished(QNetworkReply *reply);

};

#endif // MNOTESNETWORK_H
