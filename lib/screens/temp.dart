/*void main() {
  int a=1;
  double b=4.45;
  num c=2;
  String s='nishtha';
  bool flag=  true;
  print(flag);
  print(a);
  print(b);
  print(c.runtimeType);
  print(s);
  print(a.toString()==s);
  print(s +" " + a.toString()); 
  print("$s  $a");
  print("$s $a");
}*/
/*void main()
{
  int age=15;
  if(age>18)
  {
    print('eligible to vote');
  }
  else
  {
    print('Not eligible');
  }
}*/
/*void main()
{
  int x=20;
  switch(x)
  {
      case 10 : print("not eligible");
              break;
    case 20 : print("eligible");
      break;
      default : print("wrong choice");
  }*/
/*void main()
{
  for(int i=1; i<10; i++)
  {
    if(i==5)
    {
      print("hello");
      break;
    }
    print(i);
  }
}*/
/*void main()
{
  int x=10;
  while(x>=0)
  {
    print(x);
    x--;
  }
}*/
/*void main()
{
  var  List =[1,2,3];
  //print(List);
  List.forEach((item)
  {
    print(item);
  });
}*/
// void main()
// {
//   var map1= {
//     "name" : "Nishtha",
//     "age"  : 19
//     };
//   print(map1["age"] );
//   map1.forEach((item, v) => print('${item}'));
// //   var usrMap = {"name": "Tom", 'Email': 'tom@xyz.com'};
// //    usrMap.forEach((k,v) => print('${k}: ${v}'));
//  }
// void main()
// {
//   int x=10;
//   void printIt(String name, [String age])
//   {
//     print(x);
//     print(name);
//     print(age??"");
//   }
//   printIt("Nishtha");
// }
// import 'dart.io';
// void main()
// {
//   print("Enter 2 nos. of your choice");
//   int n1= int.parse(stdin.readLineSync());
//   int n2 = int.parse(stdin.readLineSync());
//   print("Which operation do u want to perform?");
//   var operator
//   switch(operator)
//   {
//     case
//   }
// }
// double recur(){
//   return 0;
// }
// void main() {
//   List<dynamic> a = [1,"+",2,"+",3,"*",4,"/",5];
//   num cur = a[0];
//   for(int i=1; i<a.length; i+=2){
//     if(a[i]=="+") cur+=a[i+1];
//     else if(a[i]=='-') cur-=a[i+1];
//     else if(a[i]=='') cur=a[i+1];
//     else cur/=a[i+1];
//   }
//   print(cur);
// }
// double add(double a, double b){
//   double sum = a+b;
//   print("The addition of $a and $b is :- $sum");
//   return 0;
// }
// double sub(double a, double b){
//   double min = a-b;
//   print("The Subtraction of $a and $b is :- $min");
//   return 0;
// }
// double multi(double a, double b){
//   double mul = a*b;
//   print("The multiplication of $a and $b is :- $mul");
//   return 0;
// }
// double div(double a, double b){
//   double divi = a/b;
//   print("The Division of $a and $b is :- $divi");
//   return 0;
// }
// void main(){
//   double x = 6;
//   double y = 3;
//   //to take from input
//   int i = 3;
//   print("To Exit (press):- 0");
//   print("To perform Addition (press):- 1");
//   print("To perform Subtraction (press):- 2");
//   print("To perform Multiplication (press):- 3");
//   print("To perform Division (press):- 4\n");
//   switch(i){
//     case 0 :
//       break;
//     case 1 :
//       add(x,y);
//       break;
//     case 2 :
//       sub(x,y);
//       break;
//     case 3 :
//       multi(x,y);
//       break;
//     case 4 :
//       div(x,y);
//       break;
//   }
// }
// void main()
// {
//   var myList = new List(2);
//   myList[1] = 2;
//   print(myList);
// }
// void main()
// {
//   int n1=2;
//   int n2=5;
//   print("Which operation do u want to perform?");
//   var operator = '/';
//   num c;
//   switch(operator)
//   {
//     case '+': c = n1 + n2;
//       print(c);
//       break;
//     case '-': c = n1 - n2;
//       print(c);
//       break;
//     case '*':c =  n1 * n2;
//       print(c);
//       break;
//     case '/': c=  n1/n2;
//       print(c);
//       break;
//   }
// }
// void main() {
//   List<dynamic> a = [1,"*",2,"*",3,"*",4,"*",5];
//   num cur = a[0];
//   for(int i=1; i<a.length; i+=2){
//     if(a[i]=="+") cur+=a[i+1];
//     else if(a[i]=='-') cur-=a[i+1];
//     else if(a[i]=='*') cur*=a[i+1];
//     else cur/=a[i+1];
//   }
//   print(cur);
// }
// [1,2,3,4,5,6,7,8,9] length = n
// void main()
// {
//   List <dynamic> a =[1,"+",4,"/",2,"-",5,"*",10];
//   int i;
//   int n =a.length;
//   print(n);
//   for(i=1; i<n-1; i=i+2)
//   {
//     if(a[i]=='/')
//     {
//       a[i-1]= a[i-1]/a[i+1];
//       a[i]=0;
//       a[i+1]=0;
//     }
//   }
//   print(a);
//   for(i=1; i<n-1; i=i+2)
//   {
//     if(a[i]=='*')
//     {
//       a[i-1]= a[i-1]*a[i+1];
//       a[i]=0;
//       a[i+1]=0;
//     }
//   }
//     print(a);
//   for(i=1; i<n-1; i=i+2)
//   {
//     if(a[i]=='+')
//     {
//       a[i-1]= a[i-1]+a[i+1];
//       a[i]=0;
//       a[i+1]=0;
//     }
//   }
//     print(a);
//   for(i=1; i<n-1; i=i+2)
//   {
//     if(a[i]=='-')
//     {
//       a[i-1]= a[i-1]-a[i+1];
//       a[i]=0;
//       a[i+1]=0;
//     }
//   }
//   print(a);
// }
// Calculate(){
//   List <String> st = [];
//   String top = '';
//   String s = '5+2-3/6';
//   for(int i=0;i<s.length;i++){
//     //algo goes here...
//    top = st[n-1];
//     st.remove(n-1);
//   }
// }
var stack = List();
int top = -1;
// Push function here, inserts value in stack and increments stack top by 1
void push(var oper) {
  if (top == stack.length - 1) {
    print("stackfull");
  } else {
    top++;
    stack[top] = oper;
  }
}

String pop() {
  String ch;
  if (top == -1) {
    print("stackempty!!!!");
  } else {
    ch = stack[top];
    stack[top] = '\0';
    top--;
    return (ch);
  }
  return '0';
}

int priority(var alpha) {
  if (alpha == '+' || alpha == '-') {
    return (1);
  }
  if (alpha == '*' || alpha == '/') {
    return (2);
  }
  if (alpha == '^') {
    return (3);
  }
  return 0;
}

List<String> convert(String infix) {
  int i = 0;
  List<String> postfix = [];
  while (infix[i] != '\0') {
    int k = int.parse(infix[i]);
    if (k >= 0 && k <= 9) {
      postfix.add(infix[i]);
      i++;
    } else if (infix[i] == '(' || infix[i] == '{' || infix[i] == '[') {
      stack.add(infix[i]);
      i++;
    } else if (infix[i] == ')' || infix[i] == '}' || infix[i] == ']') {
      if (infix[i] == ')') {
        while (stack[top] != '(') {
          postfix.add(stack.removeLast());
        }
        pop();
        i++;
      }
      if (infix[i] == ']') {
        while (stack[top] != '[') {
          postfix.add(stack.removeLast());
        }
        pop();
        i++;
      }
      if (infix[i] == '}') {
        while (stack[top] != '{') {
          postfix.add(stack.removeLast());
        }
        pop();
        i++;
      }
    } else {
      if (top == -1) {
        push(infix[i]);
        i++;
      } else if (priority(infix[i]) <= priority(stack[top])) {
        postfix.add(stack.removeLast());
        while (priority(stack[top]) == priority(infix[i])) {
          postfix.add(stack.removeLast());
          if (top < 0) {
            break;
          }
        }
        push(infix[i]);
        i++;
      } else if (priority(infix[i]) > priority(stack[top])) {
        push(infix[i]);
        i++;
      }
    }
  }
  while (top != -1) {
    postfix.add(stack.removeLast());
  }
  print("The converted postfix string is : $postfix");
  return postfix;
}

void main() {
  String s = '5+2-3/6';
  List<String> postfix;
  postfix = convert(s);
  print(postfix);
}
