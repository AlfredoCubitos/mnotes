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
    explicit MnotesConfig(QObject *parent = 0);
    void writeConfig(const QString group);
    void readConfigGroup(const QString group);
    void setConfig(const QString key, const QString value);
    Q_INVOKABLE QJsonObject readConfig(QString group);
    QVariantList readGroups();
    
private:
    QSettings *settings;
    QHash<QString,QString> config;

   
  //  QStringList readConfigGroup();

signals:

public slots:
    void getDlgData(const QVariant &values);


};

#endif // CONFIG_H
