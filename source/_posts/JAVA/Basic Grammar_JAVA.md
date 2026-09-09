---
title: JAVA Basic Grammar
mathjax: true
categories: JAVA
tags: notes
comments: true
---
# JAVA Basic Grammar
---
*tip:*
*Ctrl+/ 整行注释*
*Alt+/ 自动补全*

## Input&Output
* **Scanner in = new Scanner(System.in);**
* input: in.next();下一个字符/读到空白 in.nextline(); in.next[类型名]();
* output:System.out.println(in.nextline());
* 不同模块 + 拼接 //*表示运算时加()！！*
## 定义&赋值
* 运算符,变量名,类型名,强制转换 略(同C)
* JAVA是一种强类型语言
* 定义常量：final
* true/false 不对应1/0

## 语句
>if (panduan) 语句/{语句块} 
else ...//else就近匹配

>swith ([int]){
case 1: ... break;
...
default:...
}

>while (tiaojian){
  ...
}

>do{
...
}while()

>for (初值;判断;步进,){}

*循环标号： 标号名：循环 可使break/continue对该层循环作用*

## 数组
* 定义 类型名[] 变量名 = new 类型名[数组容量];//[][]
* 数组容量可以为变量：)
* 数组内部成员： .length() //数量 *二维数组 ~.length ~[i].length*
* ={,}; 初始化
* 可以数组整体赋值 存地址
* 自动初始化为0
* 数组遍历循环for-each 同

## 函数
public static 类型名(){ }

## 字符&字符串
采用unicode 16 编码
可直接赋值'\u0041' 65
* 逃逸字符 表略

string str = new String(初始化)
String s="";
可直接+连接（自动变str）
* charAt(0..len-1); 
* CompareTo();
* substring(a,b);[a,b)
* indexOf('',x);从x开始找 返回第一个首字母位置或-1
* startWith() endsWith()
* trim()删左右空格
* replace(c1,c2)
* toLowerCase() toUpperCase()
* 方法的对象可以是字符串常量~
**Java字符串不可变，所有的字符串操作都是产生一个新的字符串，而不是对原来的字符串的修改。**



## 包裹类型
Integer Character ..其他都是类型名的首字母大写

### Math类
* .abs()
* .random()  //[0,1)




<script type="text/javascript" src="http://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>
<script type="text/x-mathjax-config">
  MathJax.Hub.Config({ tex2jax: {inlineMath: [['$', '$']]}, messageStyle: "none" });
</script>