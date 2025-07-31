package com.banma.service;

import com.banma.dao.UserDao;

public class UserService {
    public static void testService(){
        System.out.println("testService!!!");
        //调用Maven_dao模块的方法
        UserDao.testDao();
    }
}
