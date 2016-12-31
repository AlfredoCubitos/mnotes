#include "msonenoteapi.h"
#include "OAuth/o2requestor.h"
#include "OAuth/o2msgraph.h"


MSOneNoteApi::MSOneNoteApi(QObject *parent) : QObject(parent), authenticator_(0)
{
    manager_ = new QNetworkAccessManager(this);

}

MSOneNoteApi::~MSOneNoteApi(){

}

MSGraph *MSOneNoteApi::authenticator() const{
    return authenticator_;
}

void MSOneNoteApi::setAuthenticator(MSGraph *v){
    authenticator_ = v;
}

void MSOneNoteApi::getNotebooks()
{
    O2Requestor *requestor = new O2Requestor(manager_,authenticator_,this);
    apiUrl.setPath(apiPath.append("notebooks"));
    QNetworkRequest request(apiUrl);
   // request.setRawHeader(QByteArray("Authorization"),QByteArray(authenticator_->code()));
    requestor->get(request);

   // qDebug() << apiUrl.toString();

   connect(requestor,SIGNAL(finished(int,QNetworkReply::NetworkError, QByteArray)),this,SLOT(requestFinished(int,QNetworkReply::NetworkError, QByteArray)));


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
}

void MSOneNoteApi::requestFailed(QNetworkReply::NetworkError error,QByteArray data)
{
    qWarning() << "MSOneNoteApi::requestFailed:" << (int)error << error <<data;
}
