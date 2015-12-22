#include "mnoteshandler.h"
#include <QQuickItem>
#include <QDebug>
#include <QtQml>
#include <QTextCharFormat>
#include <QTextCursor>
#include <QMessageBox>

#define BGCOLOR "#FFEBCD"


MNotesHandler::MNotesHandler() :d_mnote(0), m_target(0)
    {

    }



void MNotesHandler::searchSignal(const QString &str)
    {

        if (!m_target)
            return;

        QVariant doc = m_target->property("textDocument");
        if (doc.canConvert<QQuickTextDocument*>()) {
            QQuickTextDocument *qqdoc = doc.value<QQuickTextDocument*>();
            if (qqdoc)
                {

                    d_mnote = qqdoc->textDocument();

                    highLighter(str);
                }

        }
    }

void MNotesHandler::winSignal(const QVariant &obj)
    {

       QQuickItem *item = qobject_cast<QQuickItem*>(obj.value<QObject*>());
       m_target = item;

    }

void MNotesHandler::highLighter(const QString &search)
    {
        if (! d_mnote)
            return;

        if (cur_pos.length() > 0)
                 clearHighlight();


       QTextCursor highlightCursor = QTextCursor(d_mnote);
       QTextCursor cursor = QTextCursor(d_mnote);


        cursor.beginEditBlock();


        QTextCharFormat plainFormat(highlightCursor.charFormat());
        QTextCharFormat colorFormat = plainFormat;

        colorFormat.setBackground(QColor(BGCOLOR));


       while (!highlightCursor.isNull() && !highlightCursor.atEnd()) {
        highlightCursor = d_mnote->find(search, highlightCursor, 0);

        if (!highlightCursor.isNull()) {

                cur_pos.append(highlightCursor.position());

                highlightCursor.movePosition(QTextCursor::WordRight,  QTextCursor::KeepAnchor);
                highlightCursor.mergeCharFormat(colorFormat);
            }
        }

                cursor.endEditBlock();

                setCurpos(cur_pos);
    }

void MNotesHandler::clearHighlight()
    {
            QTextCursor ccursor (d_mnote);

            QTextCharFormat format( ccursor.charFormat());
            QTextCharFormat colorFormart = format;
            QColor bgcolor =  m_target->parent()->property("color").value<QColor>();
            colorFormart.setBackground(bgcolor);

            ccursor.beginEditBlock();

            if (cur_pos.length() > 0)
                {
                    for (int i = 0; i < cur_pos.size(); ++i)
                        {
                            ccursor.setPosition(cur_pos.at(i).toInt());
                            ccursor.movePosition(QTextCursor::NextCharacter,QTextCursor::MoveAnchor,2);
                            ccursor.movePosition(QTextCursor::WordLeft,  QTextCursor::KeepAnchor);
                            ccursor.mergeCharFormat(colorFormart);

                        }
                }

            ccursor.endEditBlock();

    }

void MNotesHandler::setTarget(QQuickItem *target)
    {
        d_mnote = 0;
        m_target = target;
        if (!m_target)
            return;

        QVariant doc = m_target->property("textDocument");
        if (doc.canConvert<QQuickTextDocument*>()) {
            QQuickTextDocument *qqdoc = doc.value<QQuickTextDocument*>();
            if (qqdoc)
                d_mnote = qqdoc->textDocument();
        }

        emit targetChanged();
    }

QString MNotesHandler::text() const
{
    return m_text;
}

void MNotesHandler::setText(const QString &arg)
{
    if (m_text != arg) {
        m_text = arg;
        emit textChanged();
    }
}

void MNotesHandler::setCurpos(const QVariant cur)
    {
       m_target->parent()->setProperty("curpos",cur);
       emit curposChanged("foundPos",App);
    }

void MNotesHandler::callQmlFuntion(const char *fn, QObject *obj)
    {
        QMetaObject::invokeMethod(m_target->parent(),fn);
    }
