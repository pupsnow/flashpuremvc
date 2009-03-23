package com.connectDB;
public class NoticeInfo {
    private String title;        // 鏍囬
    private String author;  // 浣滆��
    private String content;// 鍐呭
    private String dates;       // 鏃堕棿
    
    public String getAuthor() {
        return author;
    }
    public void setAuthor(String author) {
        this.author = author;
    }
    
    public String gettitle() {
        return title;
    }
    public void settitle(String title) {
        this.title = title;
    }
    
    public String getcontent() {
        return content;
    }
    public void setcontent(String content) {
        this.content = content;
    }
    
    public String getdates() {
        return dates;
    }
    public void setdates(String dates) {
        this.dates = dates;
    }

}
