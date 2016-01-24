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

/**
 * @brief MNotesHandler::setStatusBar
 *
 * places the cursor back to the right position after a search is performed
 */

void  MNotesHandler::setStatusBar()
    {
        QObject *statusbar = m_target->parent()->findChild<QObject*>("statusBar");

        QQuickItem *input = statusbar->findChild<QQuickItem*>("searchbox");

        /* put the cursor to the right position */

        QMetaObject::invokeMethod(input,"forceActiveFocus");
        QMetaObject::invokeMethod(input, "selectAll");
        QMetaObject::invokeMethod(input, "deselect");
    }

/**
 * @brief MNotesHandler::highLighter
 * @param search
 *
 * Perfomes a search in a Note a highlights the words found
 */

void MNotesHandler::highLighter(const QString &search)
    {
        if (! d_mnote)
            return;


       QTextCursor highlightCursor = QTextCursor(d_mnote);
       QTextCursor cursor = QTextCursor(d_mnote);

       if (d_mnote->availableUndoSteps() > 0)
           {
               // qDebug()<<"undo pos: "<<d_mnote->isUndoAvailable() << "steps: " << d_mnote->availableUndoSteps() ;

               clearHighlight();

           }

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

/**
 * @brief MNotesHandler::clearHighlight
 *
 * clears the higlighted words from previous search
 */
void MNotesHandler::clearHighlight()
    {

      //  qDebug() << "clearHiglight " << m_target->parent()->objectName() ;

        /**
          * before "undo" you have to set focus to the document
          * otherwise "undo" will not work properly
          * after "undo" set focus back to statusbar
          * */

        m_target->setProperty("focus",true);
        d_mnote->undo();
        m_target->setProperty("focus",false);

        /**
          * despite "undo" you have to clean up charformat
        **/

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
       setStatusBar();

    }

/**
 * @brief MNotesHandler::setTarget
 * @param target
 *
 * get the Textarea form the active Note
 */
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

/*
QString MNotesHandler::text() const
{
    return m_text;
}
*/
/*
void MNotesHandler::setText(const QString &arg)
{
    if (m_text != arg) {
        m_text = arg;
        emit textChanged();
    }
}*/

/**
 * @brief MNotesHandler::setCurpos
 * @param cur
 *
 * adds the cursor position into an array in Window.qml
 */

void MNotesHandler::setCurpos(const QVariant cur)
    {
       m_target->parent()->setProperty("curpos",cur);
       emit curposChanged("foundPos",App);
    }

/**
 * @brief MNotesHandler::callQmlFuntion
 * @param fn function name
 * @param obj
 *
 * Calls js function in QML
 */
void MNotesHandler::callQmlFuntion(const char *fn, QObject *obj)
    {
        QMetaObject::invokeMethod(m_target->parent(),fn);
    }


/**********************
 * SLOTS
 * ********************/
/**
 * @brief SLOT: MNotesHandler::winSignal
 * @param obj
 */
void MNotesHandler::winSignal(const QVariant &obj)
    {

       QQuickItem *item = qobject_cast<QQuickItem*>(obj.value<QObject*>());
       m_target = item;

    }

/**
 * @brief SLOT: MNotesHandler::searchSignal
 * @param str
 */
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
                     setStatusBar();
                     highLighter(str);

                }

        }
    }

/**
 * @brief MNotesHandler::activeSb
 * @param obj
 *
 *  places the cursor into the TextField when searchbar is visible
 */

void MNotesHandler::activeSb(const QVariant &obj)
    {
        QQuickItem *item = qobject_cast<QQuickItem*>(obj.value<QObject*>());
        QMetaObject::invokeMethod(item,"forceActiveFocus");

    }

/*********************
 * Debug functions
 * *******************/

/**
 * @brief MNotesHandler::countMethods for debugging only
 * @param pointer to a QObject
 *  note: if the object is not valid the program compiles but crashes without error message
 *
 * Check the methods available in an object
 *
 */
void MNotesHandler::countMethods(QObject *obj)
    {
       const QMetaObject* metaObject = obj->metaObject();

        if (metaObject->methodOffset() > 0)
            {
                for(int i = metaObject->methodOffset(); i < metaObject->methodCount(); ++i)
                    qDebug() << QString::fromLatin1(metaObject->method(i).methodSignature());
            }else{
                qDebug() << obj->objectName() << "no Methods found";
            }
    }
