#include "mnoteshandler.h"
#include <QQuickItem>
#include <QDebug>
#include <QtQml>
#include <QTextCharFormat>
#include <QTextCursor>
#include <QMessageBox>

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

                   dumpObjectTree();
                    highLighter(str);
                }

        }
    }

void MNotesHandler::winSignal(const QVariant &obj)
    {

      //  mn_target  = 0;
       QQuickItem *item = qobject_cast<QQuickItem*>(obj.value<QObject*>());
       m_target = item;

    }

void MNotesHandler::highLighter(const QString &search)
    {
        if (! d_mnote)
            return;

        if (isFirstTime == false)
                d_mnote->undo();

        bool found = false;


       QTextCursor highlightCursor = QTextCursor(d_mnote);
        QTextCursor cursor = QTextCursor(d_mnote);

        cursor.beginEditBlock();

        QTextCharFormat plainFormat(highlightCursor.charFormat());
        QTextCharFormat colorFormat = plainFormat;
        colorFormat.setForeground(Qt::red);


       while (!highlightCursor.isNull() && !highlightCursor.atEnd()) {
        highlightCursor = d_mnote->find(search, highlightCursor, 0);

        if (!highlightCursor.isNull()) {
                found = true;
                highlightCursor.movePosition(QTextCursor::WordRight,
                                               QTextCursor::KeepAnchor);
                highlightCursor.mergeCharFormat(colorFormat);
            }
        }


                cursor.endEditBlock();
                isFirstTime = false;


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
