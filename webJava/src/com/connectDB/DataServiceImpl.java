package com.connectDB;

import java.sql.*;
import java.util.ArrayList;

public class DataServiceImpl
	{
		private Connection conn = null;
		private Statement stmt = null;
		// 以下是数据库以及驱动信息
		public final static String DRIVER = "com.microsoft.jdbc.sqlserver.SQLServerDriver";
		public final static String CONN_STR_PRE = "jdbc:microsoft:sqlserver://";
		public final static String HOST_NAME = "localhost:1433;";
		public final static String DATABASE_NAME = "DatabaseName=Lcds_db";
		public final static String USERNAME = "sa";
		public final static String PASSWORD = "123";

		public DataServiceImpl()
			{

			}

		// 查询数据库
		public ResultSet executeQuery(String sqlText)
			{
				try
					{
						Class.forName(DRIVER);
					}
				catch (ClassNotFoundException e)
					{
						e.printStackTrace();
					}
				try
					{
						conn = DriverManager
								.getConnection(CONN_STR_PRE + HOST_NAME
										+ DATABASE_NAME, USERNAME, PASSWORD);
						stmt = conn.createStatement();
						ResultSet rs = stmt.executeQuery(sqlText);
						return rs;
					}
				catch (SQLException e)
					{
						e.printStackTrace();
					}
				return null;
			}

		// 查询公告. 这个是本程序的关键代码
		public NoticeInfo[] getNotices()
			{
				ArrayList noticeList = new ArrayList();
				String sqlText = "select author,content,date,title from Bulletin";
				ResultSet rs = executeQuery(sqlText);
				try
					{
						while (rs.next())
							{
								NoticeInfo temp = new NoticeInfo();
								temp.setAuthor(rs.getString("author"));
								temp.setcontent(rs.getString("content"));
								//temp.setdates(rs.getDate("date"));
								temp.settitle(rs.getString("title"));
								noticeList.add(temp);
							}
						NoticeInfo[] notices = new NoticeInfo[noticeList.size()];
						for (int i = 0; i < noticeList.size(); i++)
							{
								notices[i] = (NoticeInfo) noticeList.get(i);
							}
						return notices;
					}
				catch (SQLException e)
					{
						e.printStackTrace();
						return null;
					}
			}
	}
