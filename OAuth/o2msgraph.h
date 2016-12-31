#ifndef MSGRAPH_H
#define MSGRAPH_H

#include <QObject>
#include "OAuth/o2.h"
#include "OAuth/o0export.h"

class O0_EXPORT MSGraph : public O2
{
    Q_OBJECT

public:
    explicit MSGraph(QObject *parent = 0);

Q_SIGNALS:
    void unlinked();

public Q_SLOTS:
    Q_INVOKABLE void link();
    Q_INVOKABLE virtual void redirected(const QUrl &url);
    Q_INVOKABLE void unlink();
};

#endif // MSGRAPH_H
