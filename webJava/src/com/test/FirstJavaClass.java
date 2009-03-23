package com.test;

import java.util.ArrayList;

public class FirstJavaClass {

	public NoticeInfo[] sayHello(String str){
//		System.out.println(str);
//		Object[] lst = new Object[]{"aa","bb","cc"};
//		 List lst = new List();
//		 lst.add("Mercury");
//		 lst.add("Venus");
//		 lst.add("Earth");
//		 lst.add("JavaSoft");
//		 lst.add("Mars");
//		return lst;
		ArrayList<NoticeInfo> noticeList = new ArrayList<NoticeInfo>();
		for(int i=0;i<10;i++)
		{
		NoticeInfo temp = new NoticeInfo();
		temp.setAuthor("111");
		temp.setContent("222");
		temp.setDates("333");
		temp.setTitle("444");
		noticeList.add(temp);
		}
		NoticeInfo[] notices = new NoticeInfo[noticeList.size()];
		for (int i = 0; i < noticeList.size(); i++)
			{
				notices[i] = (NoticeInfo) noticeList.get(i);
			}
		return notices;
	}
	
	public int add(int a,int b)
	{
		//String a="adfadfadfadf";
		return a+b;
	}
}
