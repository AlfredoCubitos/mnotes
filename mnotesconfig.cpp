#include "mnotesconfig.h"

#include <QDebug>
#include <QJSValue>
#include <QJSValueIterator>


MnotesConfig::MnotesConfig(QObject *parent) : QObject(parent)
    {
        settings = new QSettings("MNotes","Mnotes");
    }

void MnotesConfig::writeConfig(const QString group)
    {
        if (config.keys().length() > 0)
            {
                QHashIterator<QString,QString> hi(config);
                settings->beginGroup(group);
                while (hi.hasNext()) {
                        hi.next();
                        settings->setValue(hi.key(),hi.value());
                    }
                settings->endGroup();
            }
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

        qDebug() << groups;
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
                         qDebug() << it.name() << it.value().toString();
                         if (it.name() == "group")
                             {
                                 group = it.value().toString();
                                 it.next();
                             }
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
