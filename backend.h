#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QString>
#include <qqml.h>
#include <stack>
#include <math.h>
#include <QDebug>
#include <exception>


class BackEnd : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString exprInput READ exprInput WRITE setExprInput NOTIFY exprInputChanged)
    Q_PROPERTY(QString lastResult READ lastResult WRITE setLastResult NOTIFY lastResultChanged)

public:
    explicit BackEnd(QObject *parent = nullptr);

    QString exprInput();
    QString lastResult();
    void setLastResult(const QString &lastResult);

public slots:
    QString resolveExpr();
    void setExprInput(const QString &exprInput);

signals:
    void exprInputChanged();
    void lastResultChanged();

private:
    QString m_exprInput;
    QString m_lastResult;

    std::stack<QString> infixToPostfix(QString expression);
    double calculateExpr(double a, QChar op, double b = 2);
    template <typename T>
    bool isPrecedingOperator(T first, T second);
    int getOperatorOrder(QChar charOperator);
    int getOperatorOrder(QString stringOperator);
    QChar convertSciOperator(QString &expression, int size, int &currentIndex);
};

#endif // BACKEND_H
