package com.lxyg.app.customer.platform.Queue;

import com.jfinal.plugin.activerecord.Record;
import com.lxyg.app.customer.platform.model.Order;
import com.lxyg.app.customer.platform.util.IConstant;
import com.lxyg.app.customer.platform.util.Quque;

import java.util.LinkedList;
import java.util.Queue;

/**
 * Created by ÇØË§ on 2015/11/25.
 */
public class orderQueue {
    Queue<Order> queue = new LinkedList<Order>();
    public void insert(Order order){
        queue.offer(order);
    }
    public boolean isEmpty(){
        if(queue.size()==0){
            return true;
        }else{
            return false;
        }
    }
    public Order peekFront(){
        return queue.peek();
    }
    public void remove(){
        queue.remove();
    }
}
