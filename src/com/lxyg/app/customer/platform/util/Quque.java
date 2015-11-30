package com.lxyg.app.customer.platform.util;

/**
 * Created by ��˧ on 2015/11/25.
 */
public class Quque {
    private int maxSize; //���г��ȣ��ɹ��캯����ʼ��
    private long[] queArray; // ����
    private int front;//��ͷ
    private int rear;//��β
    private int nItems;//Ԫ�صĸ���
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
        long temp = queArray[front++]; // ȡֵ���޸Ķ�ͷָ��
        if(front == maxSize){
            front = 0;
        }            // ����ѭ��
        nItems--;
        return temp;

    }
    public boolean isEmpty()     // �ж����Ƿ�Ϊ�ա���Ϊ�շ���һ����ֵ�����򷵻�һ����ֵ��
    {
        return (nItems==0);
    }
    public long peekFront(){
        return queArray[front];
    }
    public boolean isFull(){
        return (nItems==0);
    }
    public int size()            // ���ض��еĳ���
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
