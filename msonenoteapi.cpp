#include "msonenoteapi.h"

#include "OAuth/o2skydrive.h"


MSOneNoteApi::MSOneNoteApi(QObject *parent) : QObject(parent), authenticator_(0)
{
    manager_ = new QNetworkAccessManager(this);
}

MSOneNoteApi::~MSOneNoteApi(){

}

O2Skydrive *MSOneNoteApi::authenticator() const{
    return authenticator_;
}

void MSOneNoteApi::setAuthenticator(O2Skydrive *v){
    authenticator_ = v;
}



void MSOneNoteApi::getNotebooks()
{

    apiUrl.setPath(apiPath.append("notebooks"));
    QNetworkRequest request(apiUrl);
   // request.setRawHeader(QByteArray("Authorization"),QByteArray(authenticator_->code()));
    requestor->get(request);

   // qDebug() << apiUrl.toString();

}

void MSOneNoteApi::prepareRequest()
{
    QByteArray auth;



    O2Skydrive *authentor = authenticator();
    setAuthenticator(authentor);
    if (! authentor->linked())
        authentor->link();

    auth.append("Bearer ");
    auth.append(authentor->token());

    requestor = new O2Requestor(manager_,authenticator_,this);

    qDebug() << "PrepareRequest " << requestor;

    connect(requestor,SIGNAL(finished(int,QNetworkReply::NetworkError, QByteArray)),this,SLOT(requestFinished(int,QNetworkReply::NetworkError, QByteArray)));

    request.setRawHeader(QByteArray("Authorization"),auth);
}

void MSOneNoteApi::getPages()
{
    prepareRequest();
    if (!apiPath.contains("pages"))
        apiPath.append("pages");
    apiUrl.setPath(apiPath);
    request.setUrl(apiUrl);
    qDebug() << "API: " << apiUrl;
    requestor->get(request);


}

void MSOneNoteApi::getContent(const QVariant url)
{
    qDebug() << "getCOntent " << url;
    prepareRequest();
    request.setUrl(QUrl(url.toString()));

    requestor->get(request);

}

void MSOneNoteApi::checkAuth()
{
    if (!authenticator_ || !authenticator_->linked()) {
        /** ToDo implement signal**/
        Q_EMIT authenticator_->linkingSucceeded();
        //emit commentModelChanged();
            return;
    }
}

void MSOneNoteApi::requestFinished(int id, QNetworkReply::NetworkError error, QByteArray data)
{
    if (error != QNetworkReply::NetworkError::NoError)
        {
            emit requestFailed(error,data);
           // commentModel_->clearComments();
           // emit commentModelChanged();
            return;
    }

    qDebug() << data;
    emit resultAvailable(QString::fromUtf8( data));
   // requestor->deleteLater();

}

void MSOneNoteApi::requestFailed(QNetworkReply::NetworkError error,QByteArray data)
{
    qWarning() << "MSOneNoteApi::requestFailed:" << (int)error << error <<data;
}
