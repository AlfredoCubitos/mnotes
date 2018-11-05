#include "mnotesconfig.h"

#include <QDebug>
#include <QJSValue>
#include <QJSValueIterator>
#include <QStandardPaths>

/**
 * @brief MnotesConfig class
 * @param group name to read
 * @note on Android settings path depends on the context
 * @note on Android there is at least a user and an application context
 * @note path user context:
 */
MnotesConfig::MnotesConfig(QObject *parent) : QObject(parent)
    {
        settings = new QSettings("MNotes","Mnotes");

        // QString path = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation);
        QString path = QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation);
        qDebug() << "ConfigPath: " << path;
        settings->setPath(QSettings::IniFormat, QSettings::SystemScope,path);
    }

void MnotesConfig::writeConfig(const QString group)
    {
        qDebug() << settings->fileName();

        if (config.keys().length() > 0)
            {
                QHashIterator<QString,QString> hi(config);
                settings->beginGroup(group);
                while (hi.hasNext()) {
                        hi.next();
                       // qDebug() << hi.key() << " / " << hi.value();
                        settings->setValue(hi.key(),hi.value());
                    }
                settings->endGroup();
            }
        settings->sync();
    }

void MnotesConfig::readConfigGroup(const QString group)
    {
        config.clear();
        setConfig("group",group);
        settings->beginGroup(group);
        QStringList keys = settings->allKeys();
        for (int i = 0; i < keys.size(); ++i)
            {
                setConfig(keys.at(i),settings->value(keys.at(i)).toString());
            }
        settings->endGroup();

    }

QSettings * MnotesConfig::getSetting()
{
    return settings;
}

QVariantList MnotesConfig::readGroups()
    {
        QVariantList groups;
        QStringList keys = settings->allKeys();

        for (int i=0; i <keys.size(); ++i)
            {
                QStringList grp = keys.at(i).split("/");
                if (grp.size() > 1)
                    if (! groups.contains(grp.at(0)))
                        groups.append(grp.at(0));
            }

      //  qDebug() << groups;
        return groups;
    }

/**
 * @brief MnotesConfig::setConfig
 * @param key
 * @param value
 *  initializes QStringlist config  with key value pairs to write to config file
 *
 */
void MnotesConfig::setConfig(const QString key, const QString value)
    {
        config.insert(key,value);
    }

/**
 * @brief SLOT: MnotesConfig::getDlgData
 * @param values
 */
void MnotesConfig::getDlgData( const QVariant &values)
    {
        config.clear();
        QString group;
        if (values.canConvert<QJSValue>())
            {
                QJSValue data = values.value<QJSValue>();
                QJSValueIterator it(data);
                while (it.hasNext()) {
                    it.next();

                    if (it.name() == "group")
                    {
                        group = it.value().toString();
                        it.next();
                    }
                 //   qDebug() << it.name() << it.value().toString();
                    setConfig(it.name(),it.value().toString());
                }

                /**
                  * don't write config if there is no group
                  * TODO: write an error message
                  **/
                if (group.length() > 0)
                    writeConfig(group);
            }

}
/**
 * @brief QHash<QString,QString> readConfig(QString group)
 * @param QString group
 * @note Invoked from QML to read the config
 **/
QJsonObject MnotesConfig::readConfig(QString group)
{

    QString key = "";
    settings->beginGroup(group);
    QStringList keys = settings->allKeys();
    int size = keys.count();
    QJsonObject hash;

    if (size > 0)
        key = keys.at(0);


    for(int i=0;i<size;++i)
    {
        hash.insert("url",settings->value("url").toString());
        hash.insert("login",settings->value("login").toString());
        hash.insert("password",settings->value("password").toString());
        hash.insert("visible",settings->value("visible").toString());
    }

    settings->endGroup();
//  qDebug() << "readConfig: "  << "\ngroup" << group << settings->scope() << "\nKey " << key << "\nfn: " <<settings->fileName();
 return hash;
}


