#ifndef MSONENOTEAPI_H
#define MSONENOTEAPI_H

#include <QObject>
#include <QNetworkAccessManager>

#include "OAuth/o2msgraph.h"

class MSOneNoteApi : public QObject
{
    Q_OBJECT
public:

    explicit MSOneNoteApi(QObject *parent = 0);
    virtual ~MSOneNoteApi();

    /// OAuth authenticator
    Q_PROPERTY(MSGraph *authenticator READ authenticator WRITE setAuthenticator)
    MSGraph *authenticator() const;
    void setAuthenticator(MSGraph *v);

private:
    QUrl apiUrl = QUrl("https://www.onenote.com");
    QString apiPath = "/api/v1.0/me/notes/";
    void checkAuth();

signals:

protected slots:
    Q_INVOKABLE virtual void getNotebooks();
    void requestFinished(int id, QNetworkReply::NetworkError error, QByteArray data);
    void requestFailed(QNetworkReply::NetworkError error,QByteArray data);

protected:
    MSGraph *authenticator_;
    QNetworkAccessManager *manager_;
};

#endif // MSONENOTEAPI_H
