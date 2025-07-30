package com.banma;

public class MakeFriends {
	public String makeFriends(String name) {
	    HelloFriend friend = new HelloFriend();
	    friend.sayHelloToFriend(name);
	    String str = "Hey, " + friend.getMyName() + " make a friend please.";
	    System.out.println(str);
	    return str;
	}
}
