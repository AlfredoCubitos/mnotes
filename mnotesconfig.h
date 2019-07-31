#ifndef MNOTESCONFIG_H
#define MNOTESCONFIG_H

#include <QObject>
#include <QSettings>
#include <QHash>
#include <QJsonObject>



class MnotesConfig : public QObject
{
    Q_OBJECT

    
public:
    explicit MnotesConfig(QObject *parent = nullptr);
    void writeConfig(const QString &group);
    void readConfigGroup(const QString &group);
    void setConfig(const QString key, const QString value);


    QSettings * getSetting();

    Q_INVOKABLE QJsonObject readConfig(QString group);
    Q_INVOKABLE void setDlgData(const QVariant &values);
    Q_INVOKABLE QVariantList readGroups();
    
private:
    QSettings *settings;
    QHash<QString,QString> config;

   
  //  QStringList readConfigGroup();

signals:

public Q_SLOTS:



};

#endif // CONFIG_H
