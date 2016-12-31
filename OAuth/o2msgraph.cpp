#include <QDebug>
#include <QStringList>
#include <QUrlQuery>

#include "o2msgraph.h"
#include "o0globals.h"

MSGraph::MSGraph(QObject *parent):O2(parent)
{
    setRequestUrl("https://login.live.com/oauth20_authorize.srf");
    setTokenUrl("https://login.live.com/oauth20_token.srf");
    setRefreshTokenUrl("https://login.live.com/oauth20_token.srf");
    redirectUri_ = QString("https://login.live.com/oauth20_desktop.srf");

}

void MSGraph::link() {
    qDebug() << "MSGraph::link";
    if (linked()) {
        qDebug() << "MSGraph::link: Linked already";
       Q_EMIT linkingSucceeded();
        return;
    }

    setLinked(false);
    setToken("");
    setTokenSecret("");
    setExtraTokens(QVariantMap());
    setRefreshToken(QString());
    setExpires(0);

    QList<QPair<QString, QString> > parameters;

    parameters.append(qMakePair(QString(O2_OAUTH2_RESPONSE_TYPE), (grantFlow_ == GrantFlowAuthorizationCode) ? QString(O2_OAUTH2_GRANT_TYPE_CODE) : QString(O2_OAUTH2_GRANT_TYPE_TOKEN)));
    parameters.append(qMakePair(QString(O2_OAUTH2_CLIENT_ID), clientId_));
    parameters.append(qMakePair(QString(O2_OAUTH2_REDIRECT_URI), redirectUri_));
    parameters.append(qMakePair(QString(O2_OAUTH2_SCOPE), scope_));

    // Show authentication URL with a web browser
    QUrl url(requestUrl_);

    QUrlQuery query(url);
    query.setQueryItems(parameters);
    url.setQuery(query);

    Q_EMIT openBrowser(url);
}

void MSGraph::redirected(const QUrl &url) {

    qDebug() << "msgraph::redirected" << url;

    Q_EMIT closeBrowser();


    if (grantFlow_ == GrantFlowAuthorizationCode) {
        // Get access code
        QString urlCode;
        QUrlQuery query(url);
        urlCode = query.queryItemValue(O2_OAUTH2_GRANT_TYPE_CODE);
        qDebug() << "URL-Code: " << urlCode ;


        /**
         * POST https://login.live.com/oauth20_token.srf
         *
         *  Content-type: application/x-www-form-urlencoded
         *
         *  client_id=CLIENT_ID&client_secret=CLIENT_SECRET&redirect_uri=REDIRECT_URI&grant_type=refresh_token&refresh_token=REFRESH_TOKEN
         **/
        // Exchange access code for access/refresh tokens
        QNetworkRequest tokenRequest(tokenUrl_);
        tokenRequest.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
        QMap<QString, QString> parameters;
        parameters.insert(O2_OAUTH2_GRANT_TYPE_CODE, urlCode);
        parameters.insert(O2_OAUTH2_CLIENT_ID, clientId_);
        parameters.insert(O2_OAUTH2_CLIENT_SECRET, clientSecret_);
        parameters.insert(O2_OAUTH2_REDIRECT_URI, redirectUri_);
        parameters.insert(O2_OAUTH2_GRANT_TYPE, O2_AUTHORIZATION_CODE);

        qDebug() << "TokenURL: " <<tokenUrl_ << " Params: " << parameters;

        QByteArray data = buildRequestBody(parameters);
        QNetworkReply *tokenReply = manager_->post(tokenRequest, data);
        timedReplies_.add(tokenReply);
        connect(tokenReply, SIGNAL(finished()), this, SLOT(onTokenReplyFinished()), Qt::QueuedConnection);
        connect(tokenReply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(onTokenReplyError(QNetworkReply::NetworkError)), Qt::QueuedConnection);


    }else{

        qDebug() << "No access token :-( " << url;
    }
    qDebug() << "Access Token " << token();
}

void MSGraph::unlink()
{
    qDebug() << "MSGraph::unlink";
    setLinked(false);
    setToken(QString());
    setRefreshToken(QString());
    setExpires(0);
    setExtraTokens(QVariantMap());
    Q_EMIT unlinked();
}
