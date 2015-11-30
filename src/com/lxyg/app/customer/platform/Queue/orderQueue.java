package com.lxyg.app.customer.platform.Queue;

import com.jfinal.plugin.activerecord.Record;

/**
 * Created by ��˧ on 2015/11/25.
 */
public class orderQueue {

    private Record[] recordArray;//��������
    private int maxSize; //���г��ȣ��ɹ��캯����ʼ��
    private int front;//��ͷ
    private int rear;//��β
    private int nItems;//Ԫ�صĸ���
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
        Record record = recordArray[front++]; // ȡֵ���޸Ķ�ͷָ��
        if(front == maxSize){
            front = 0;
        }            // ����ѭ��
        nItems--;
        return record;

    }
    public boolean isEmpty()     // �ж����Ƿ�Ϊ�ա���Ϊ�շ���һ����ֵ�����򷵻�һ����ֵ��
    {
        return (nItems==0);
    }
    public Record peekFront(){
        return recordArray[front];
    }
    public boolean isFull(){
        return (nItems==0);
    }
    public int size()            // ���ض��еĳ���
    {
        return nItems;
    }
}
