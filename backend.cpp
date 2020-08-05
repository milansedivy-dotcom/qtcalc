#include "backend.h"


BackEnd::BackEnd(QObject *parent) :
    QObject(parent)
{
}

QString BackEnd::exprInput()
{
    return m_exprInput;
}

QString BackEnd::lastResult()
{
    return m_lastResult;
}

void BackEnd::setExprInput(const QString &exprInput)
{
    if (exprInput == m_exprInput)
        return;

    m_exprInput = exprInput;
    emit exprInputChanged();
}

void BackEnd::setLastResult(const QString &lastResult)
{
    if (lastResult == m_lastResult)
        return;
    m_lastResult = lastResult;
    emit lastResultChanged();
}

//mathematical functions have the highest precedence e.g. 7
//parenthesis get 0 to make conditions simpler in if-else statements later on.
int BackEnd::getOperatorOrder(QChar charOperator)
{
    switch (charOperator.unicode()) {
        case '^': return 3;
        case '*': return 2;
        case '/': return 2;
        case '+': return 1;
        case '-': return 1;
        case ')': return 0;
        case '(': return 0;
    default: return 7;
    }

}

int BackEnd::getOperatorOrder(QString stringOperator)
{
    return 4;
}
template <typename T>
bool BackEnd::isPrecedingOperator(T first, T second)
{
    if (getOperatorOrder(first) > getOperatorOrder(second))
        return true;
    else
        return false;
}
//takes the expression, size of the string and current index to find the string containing
//the special operator and returns a character representing the operation (mathematical function)
//a - cos; b - sin; c - cotg; d - tg; l - log.
QChar BackEnd::convertSciOperator(QString &expression, int size, int &currentIndex)
{
    QString operatorConstruct = "";
    //not my best moment - could've been made better.
    while (currentIndex < size)
    {
        operatorConstruct += expression[currentIndex];

        if (operatorConstruct == "tg")
        {
            operatorConstruct = "d";
            break;
        } else if (operatorConstruct == "cos")
        {
            operatorConstruct = "a";
            break;
        } else if (operatorConstruct == "sin")
        {
            operatorConstruct = "b";
            break;
        } else if (operatorConstruct == "cotg")
        {
            operatorConstruct = "c";
            break;
        } else if (operatorConstruct == "log") {
            operatorConstruct = "l";
            break;
        }
        currentIndex++;

    }
    qDebug() << "operator: " << operatorConstruct[0];
    return operatorConstruct[0];
}

//an attempt at shunting yard algorithm
std::stack<QString> BackEnd::infixToPostfix(QString expression)
{
    // Should've made these as private members and access them via reference instead of passing them between functions
    std::stack <QChar> operatorStack;
    std::stack <QString> outputStack;

    QChar lastOperator;
    QString lastNumber;

    qDebug() << expression;

    for(int i=0; i<expression.size(); i++)
    {
        if((expression[i] >= '0' && expression[i] <= '9') || expression[i] == '.') {
            lastNumber.append(expression[i]);
            qDebug() << "lastNumber construction: " << lastNumber;
        }
        else if (getOperatorOrder(expression[i]) > 0) //i.e. it is not a parenthesis but still an operator.
        {
            outputStack.push(lastNumber);
            lastNumber = "";

            //begin - load special operator if there is one present
            if (getOperatorOrder(expression[i])==7)
                lastOperator = convertSciOperator(expression, expression.size(), i);
            else
                lastOperator = expression[i];
            //end

            while (!operatorStack.empty()
                   && (isPrecedingOperator<QChar>(operatorStack.top(), lastOperator)
                   || getOperatorOrder(operatorStack.top()) == getOperatorOrder(lastOperator))
                   && operatorStack.top() != '(')
            {
                    outputStack.push(operatorStack.top());
                    operatorStack.pop();
            }
            operatorStack.push(lastOperator);
        }
        else if (expression[i] == '(')
            operatorStack.push(expression[i]);
        else if (expression[i] == ')')
        {
            // These checks are in place because I didn't make a function that cycles through the string and constructs the number
            // i was trying to avoid nested loops. Probably not the smartest implementation.
            if (!lastNumber.isEmpty())
            {
                outputStack.push(lastNumber);
                lastNumber="";
            }
            while (operatorStack.top() != '(')
            {
                outputStack.push(operatorStack.top());
                operatorStack.pop();
            }
            operatorStack.pop();
        }
    }
    // These checks are in place because I didn't make a function that cycles through the string and constructs the number
    // Reason: I was trying to avoid nested loops. Probably not the smartest implementation.
    if (!lastNumber.isEmpty())
        outputStack.push(lastNumber);

    while (!operatorStack.empty())
    {
        outputStack.push(operatorStack.top());
        operatorStack.pop();
    }

    // please don't judge me :( - should've used a different data structure .. instead of std::stack
    std::stack<QString> reversedStack;
    while (!outputStack.empty())
    {
       qDebug() << "outputStack: " << outputStack.top();
       reversedStack.push(outputStack.top());
       //qDebug() << "reversedStack: " << reversedStack.top();
       outputStack.pop();
    }

    return reversedStack;
}
// a - cos;
// b - sin;
// c - cotg;
// d - tg;
// l - log.
// function parameter b defaults to 2
double BackEnd::calculateExpr(double a, QChar op, double b)
{
    switch(op.unicode())
    {
    case 'a': return cos(a);
    case 'b': return sin(a);
    case 'c': return (cos(a)/sin(a)); //probably 1/tan(a) would've been faster?!
    case 'd': return tan(a);
    case 'l': return log(a);
    case '*': return a * b;
    case '-': return a - b;
    case '+': return a + b;
    case '/': return a / b;
    case '^': return pow(a, b);
    }
}

QString BackEnd::resolveExpr()
{
    std::stack<QString> inputStack = infixToPostfix(m_exprInput); //eventualy becomes the operatorStack; should've been passed as a reference
    std::stack<double> operandStack;

    double a,b;
    //QString tmpOperand;
    QChar op;
    QString output;

    while (!inputStack.empty()) {
        qDebug() << "inputStack: " << inputStack.top();
        //hotfix
        if (inputStack.top() == "")
            inputStack.pop();

        //check if first number in QString on top of stack is a number then load it.
        if (*inputStack.top().begin() >= '0' && *inputStack.top().begin() <= '9')
        {
            operandStack.push(inputStack.top().toDouble());
            inputStack.pop();
        }
        else
        {
            op = *inputStack.top().begin();
            inputStack.pop();
            //special Operator is present
            if (getOperatorOrder(op) == 7 && operandStack.size() > 0)
            {
                a = operandStack.top();
                operandStack.pop();
                operandStack.push(calculateExpr(a,op));
            }
            else if (operandStack.size() > 1)
            {
                b = operandStack.top();
                operandStack.pop();
                a = operandStack.top();
                operandStack.pop();
                operandStack.push(calculateExpr(a, op, b));
            } else {
                return "Invalid Syntax";
            }
        }
    }

    output.append(QString::number(operandStack.top(), 'g', 5));

    return output;
}
