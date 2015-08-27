#ifndef MNOTES_H
#define MNOTES_H

#include <QObject>
#include <QQuickTextDocument>

class MNotesHandler : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QQuickItem *target READ target WRITE setTarget NOTIFY targetChanged)
    Q_PROPERTY(QString text READ text WRITE setText)

public:
    explicit MNotesHandler();
    void highLighter(const QString &search);

    QQuickItem *target() { return m_target; }

    void setTarget(QQuickItem *target);
    QString text() const;

private:
    QTextDocument *d_mnote;
    QQuickItem *m_target;
    bool isFirstTime;
    QString m_text;

signals:

Q_SIGNALS:
    void targetChanged();
    void textChanged();

public slots:
    void searchSignal(const QString &str);
    void winSignal(const QVariant &obj);

public Q_SLOTS:
    void setText(const QString &arg);

};

#endif // MNOTES_H
