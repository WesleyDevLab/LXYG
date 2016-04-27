package com.lxyg.app.customer.platform.classUtil;

/**
 * Created by ÇØË§ on 2016/4/21.
 */
public class StrategyContext {
    Strategy strategy;
    public StrategyContext( Strategy strategy){

        this.strategy=strategy;
    }
    public int ContextInterface(){

        return strategy.algorithmicInterface();
    }
}
