package com.lxyg.app.customer.platform.util;

/**
 * Created by 秦帅 on 2015/11/25.
 */
public class Quque {
    private int maxSize; //队列长度，由构造函数初始化
    private long[] queArray; // 队列
    private int front;//队头
    private int rear;//对尾
    private int nItems;//元素的个数
    public Quque(){

    }

    public Quque(int s){
        maxSize=s;
        queArray = new long[maxSize];
        front = 0;
        rear = -1;
        nItems = 0;
    }

    public void insert(long j){
        if(rear==maxSize-1){
            rear=-1;
        }
        queArray[++rear]=j;
        nItems++;
    }
    public long remove(){
        long temp = queArray[front++]; // 取值和修改队头指针
        if(front == maxSize){
            front = 0;
        }            // 处理循环
        nItems--;
        return temp;

    }
    public boolean isEmpty()     // 判队列是否为空。若为空返回一个真值，否则返回一个假值。
    {
        return (nItems==0);
    }
    public long peekFront(){
        return queArray[front];
    }
    public boolean isFull(){
        return (nItems==0);
    }
    public int size()            // 返回队列的长度
    {
        return nItems;
    }

    public static void main(String[] args) {
        Quque quque=new Quque(4);
        quque.insert(10);
        quque.insert(20);
        quque.insert(30);
        quque.insert(40);
        quque.insert(10);
        quque.remove();
        quque.insert(20);
        quque.insert(30);
        quque.insert(40);
        System.out.println(quque.size());
    }

}
