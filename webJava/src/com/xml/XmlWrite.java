/**   
 * desciption:java create xml file   
 * author:maomao   
 * datetime:2007/04/04 23:42   
 */
package com.xml;

import java.io.FileOutputStream;
import java.io.IOException;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Map;

import org.jdom.Document;
import org.jdom.Element;
import org.jdom.JDOMException;
import org.jdom.output.Format;
import org.jdom.output.XMLOutputter;

import com.connectDB.DataServiceImpl;
import com.connectDB.NoticeInfo;

public class XmlWrite
	{

		public String BuildXMLDoc(String TableName,String xml,String... args)
			{

				// 创建根节点 list;    
				Element root = new Element("list");

				// 根节点添加到文档中；    
				Document Doc = new Document(root);

				// 此处 for 循环可替换成 遍历 数据库表的结果集操作;    
				DataServiceImpl SqlSearch = new DataServiceImpl();
				
				XmlRead Sqlxml=new XmlRead();
				ArrayList<Map<String, String>> SqlList=new ArrayList<Map<String, String>>();
				SqlList=Sqlxml.xmlElements(xml);//解析传近来的查询xml
				
				
				String clounmName=new String();//存储返回的列名
				String Condition=new String();//存储查询条件
				
				//解析返回那些列
				for(int j=0;j<args.length;j++)
					{
						if(j==0)
							{
								clounmName+=args[j];
								
							}
						else
							{
								clounmName+=","+args[j];	
							}
						
					}
				
				//解析查询条件
				for(int i=0;i<SqlList.size();i++)
					{
						if(i==0)
							{
								Condition+=SqlList.get(i).get("ColumnName")+'='+SqlList.get(i).get("Value");
							}
						else
							{
								Condition+=","+SqlList.get(i).get("ColumnName")+'='+SqlList.get(i).get("Value");
							}
						
						
					}
				
				//sql语句
				String sqlText = "select "+clounmName+" from "+TableName+ " where "+Condition;
				// 查询
				ResultSet rs = SqlSearch.executeQuery(sqlText);

				try
					{
						while (rs.next())
							{
								// 创建结果节点 ; 
								Element elements = new Element("Records");
								//循环添加节点的子节点
								for(String arg:args )
									{
										elements.addContent(new Element(arg).setText(rs.getString(arg)));
									}
								root.addContent(elements);
							}
						//输出xml用Format.getPrettyFormat()格式化
						XMLOutputter XMLOut = new XMLOutputter(Format.getPrettyFormat());
						//输出为string型
						String outString = XMLOut.outputString(Doc);
						//返回
						return outString;
					} 
				//返回错误
				catch (SQLException e)
					{
						e.printStackTrace();
						return null;
					}
				/**for (int i = 0; i < 5; i++)
					{

						// 创建节点 user;    
						Element elements = new Element("user");

						// 给 user 节点添加属性 id;    
						elements.setAttribute("id", "" + i);

						// 给 user 节点添加子节点并赋值；    
						// new Element("name")中的 "name" 替换成表中相应字段，setText("xuehui")中 "xuehui 替换成表中记录值；    
						elements.addContent(new Element("name")
								.setText("xuehui"));
						elements.addContent(new Element("age").setText("28"));
						elements.addContent(new Element("sex").setText("Male"));

						// 给父节点list添加user子节点;   
						root.addContent(elements);

					}
				XMLOutputter XMLOut = new XMLOutputter(Format.getPrettyFormat());
				//Element root2 = new Element(XMLOut.outputString(Doc));
				//Document Doc2 = new Document(root2);
				//return Doc;
				String outString = XMLOut.outputString(Doc);
				return outString;
				//System.out.println(outString);
				//XMLOut.output(Doc,System.out);
				// 输出 user.xml 文件；   
				//XMLOut.output(Doc, new FileOutputStream("user.xml"));   */
			}

		/**public static void main(String[] args)
			{
				try
					{
						XmlWrite j2x = new XmlWrite();
						System.out.println("生成 mxl 文件...");

						j2x.BuildXMLDoc();
					} catch (Exception e)
					{
						e.printStackTrace();
					}
			}
		public static void main(String[] args)
			{
				XmlWrite doc = new XmlWrite();
				String xml = "<WhereCondition>"
						+ "<where ColumnName=\"id\" Value=\"1\" DataType=\"string\" Operator=\"Like\" Logic=\"or\"/>"
//						+ "<where ColumnName=\"id\" Value=\"2\" DataType=\"string\" Operator=\"Like\" Logic=\"or\"/>"
//						+ "<where ColumnName=\"id\" Value=\"3\" DataType=\"string\" Operator=\"Like\" Logic=\"or\"/>"
//						+ "<where ColumnName=\"id\" Value=\"4\" DataType=\"string\" Operator=\"Like\" Logic=\"or\"/>"
//						+ "<where ColumnName=\"id\" Value=\"5\" DataType=\"string\" Operator=\"Like\" Logic=\"or\"/>"
						+ "</WhereCondition>";
				doc.BuildXMLDoc("Bulletin",xml,"id","date","author","content");
			}*/
	}
