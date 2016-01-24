#ifndef MNOTES_H
#define MNOTES_H

#include <QObject>
#include <QQuickTextDocument>
#include <QUndoStack>


class MNotesHandler : public QObject
{
    Q_OBJECT

   Q_PROPERTY(QQuickItem *target READ target WRITE setTarget NOTIFY targetChanged)
   // Q_PROPERTY(QString text READ text WRITE setText)
   Q_PROPERTY(QVariant curpos READ curpos  WRITE setCurpos  NOTIFY curposChanged)


public:
    explicit MNotesHandler();
    void highLighter(const QString &search);

    QQuickItem *target() { return m_target; }

    void setTarget(QQuickItem *target);
    void setCurpos(const QVariant cur);
    QVariant curpos() { return m_curpos; }


    QString text() const;

private:
    QObject *App;
    QTextDocument *d_mnote;
    QQuickItem *m_target;
    bool isFirstTime;
//    QString m_text;
    QVariant m_curpos;
    QQuickItem *sItem;
    void clearHighlight();
     QList<QVariant> cur_pos;
     void setStatusBar();

     void countMethods(QObject *obj);



signals:

Q_SIGNALS:
    void targetChanged();
    void textChanged();
    void curposChanged( const char *fn, QObject* = NULL);

public slots:
    void searchSignal(const QString &str);
    void winSignal(const QVariant &obj);

public Q_SLOTS:
   // void setText(const QString &arg);
    void callQmlFuntion(const char *fn, QObject *obj);
    void activeSb(const QVariant &obj);

};

#endif // MNOTES_H
