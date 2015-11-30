package com.lxyg.app.customer.platform.Queue;

import com.jfinal.plugin.activerecord.Record;

/**
 * Created by 秦帅 on 2015/11/25.
 */
public class orderQueue {

    private Record[] recordArray;//订单队列
    private int maxSize; //队列长度，由构造函数初始化
    private int front;//队头
    private int rear;//对尾
    private int nItems;//元素的个数
    public orderQueue(){}
    public orderQueue(int size){
        maxSize=size;
        front=0;
        rear = -1;
        nItems = 0;
    }
    public void insert(Record record){
        if(rear==maxSize-1){
            rear=-1;
        }
        recordArray[++rear]=record;
        nItems++;
    }
    public Record remove(){
        Record record = recordArray[front++]; // 取值和修改队头指针
        if(front == maxSize){
            front = 0;
        }            // 处理循环
        nItems--;
        return record;

    }
    public boolean isEmpty()     // 判队列是否为空。若为空返回一个真值，否则返回一个假值。
    {
        return (nItems==0);
    }
    public Record peekFront(){
        return recordArray[front];
    }
    public boolean isFull(){
        return (nItems==0);
    }
    public int size()            // 返回队列的长度
    {
        return nItems;
    }
}
