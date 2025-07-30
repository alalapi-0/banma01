package com.banma;

public class App {
    public static final int magic = 5;
    public static int add(int a, int b) {
        int result = a + b;
        if (a > 0) {
            if (b > 0) {
                return result;
            }
        }
        return result;
    }
}