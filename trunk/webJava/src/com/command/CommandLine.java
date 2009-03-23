package com.command;

import java.io.BufferedInputStream;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

public class CommandLine {
    public static String ExcuteCommand(String[] args) throws IOException {
    	String lineStr = "";
    	String result = "";
        if (args == null || args.length == 0) {
            System.out.println("请输入命令行参数(例：java CommandLine 'netstat')");
        } else {
            String cmd = "";
            for (int i = 0; i < args.length; i++)
                cmd += " " + args[i];
            try {
                Runtime run = Runtime.getRuntime();
                Process p = run.exec(cmd);//启动另一个进程来执行命令S
                BufferedInputStream in = new BufferedInputStream(p.getInputStream());
                BufferedInputStream err = new BufferedInputStream(p.getErrorStream());
                BufferedReader inBr = new BufferedReader(new InputStreamReader(in));
                BufferedReader errBr = new BufferedReader(new InputStreamReader(err));
                
                while ((lineStr = errBr.readLine()) != null)
                    result+=lineStr+'\n';
                while ((lineStr = inBr.readLine()) != null)
                	result+=lineStr;
                //检查命令是否执行失败。
                try {
                    if (p.waitFor()!=0) {
                        if(p.exitValue()==1)//p.exitValue()==0表示正常结束，1：非正常结束
                        	result="命令执行失败!";
                    }
                }catch (InterruptedException e){
                    e.printStackTrace();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return result;
    }
}