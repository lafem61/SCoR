/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at-
 * limitations under the License.
 */

package my.spark;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Pattern;

import scala.Tuple2;

import com.google.common.io.Files;
import com.sun.jersey.core.impl.provider.entity.XMLJAXBElementProvider.Text;

import Jama.Matrix;

import org.apache.spark.SparkConf;
import org.apache.spark.api.java.JavaRDD;
import org.apache.spark.api.java.JavaSparkContext;
import org.apache.spark.api.java.function.*;
import org.apache.spark.broadcast.Broadcast;
import org.apache.spark.streaming.Duration;
import org.apache.spark.streaming.Durations;
import org.apache.spark.streaming.StreamingContext;
import org.apache.spark.streaming.api.java.JavaDStream;
import org.apache.spark.streaming.api.java.JavaPairDStream;
import org.apache.spark.streaming.api.java.JavaReceiverInputDStream;
import org.apache.spark.streaming.api.java.JavaStreamingContext;
import org.apache.spark.util.LongAccumulator;
import org.jblas.DoubleMatrix;
import org.apache.spark.*;
import org.apache.spark.api.java.function.*;
import org.apache.spark.streaming.*;
import org.apache.spark.streaming.api.java.*;
import scala.Tuple2;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.mapred.TextOutputFormat;
import org.apache.log4j.Level;
import org.apache.log4j.Logger;



/**
 * Use this singleton to get or register a Broadcast variable.
 */


/**
 * Counts words in text encoded with UTF8 received from the network every second. This example also
 * shows how to use lazily instantiated singleton instances for Accumulator and Broadcast so that
 * they can be registered on driver failures.
 *
 * Usage: JavaRecoverableNetworkWordCount <hostname> <port> <checkpoint-directory> <output-file>
 *   <hostname> and <port> describe the TCP server that Spark Streaming would connect to receive
 *   data. <checkpoint-directory> directory to HDFS-compatible file system which checkpoint data
 *   <output-file> file to which the word counts will be appended
 *
 * <checkpoint-directory> and <output-file> must be absolute paths
 *
 * To run this on your local machine, you need to first run a Netcat server
 *
 *      `$ nc -lk 9999`
 *
 * and run the example as
 *
 *      `$ ./bin/run-example org.apache.spark.examples.streaming.JavaRecoverableNetworkWordCount \
 *              localhost 9999 ~/checkpoint/ ~/out`
 *
 * If the directory ~/checkpoint/ does not exist (e.g. running for the first time), it will create
 * a new StreamingContext (will print "Creating new context" to the console). Otherwise, if
 * checkpoint data exists in ~/checkpoint/, then it will create StreamingContext from
 * the checkpoint data.
 *
 * Refer to the online documentation for more details.
 */
public final class currentStream2 {


  public static void main(String[] args) throws Exception {
	  //JavaSparkContext sc = new JavaSparkContext(new SparkConf().setAppName("Spark Count").setMaster("local"));
	  
	  /**
	   * Counts words in new text files created in the given directory
	   * Usage: HdfsWordCount <directory>
	   *   <directory> is the directory that Spark Streaming will use to find and read new text files.
	   *
	   * To run this on your local machine on directory `localdir`, run this example
	   *    $ bin/run-example \
	   *       org.apache.spark.examples.streaming.HdfsWordCount localdir
	   *
	   * Then create a text file in `localdir` and the words in the file will get counted.
	   */

//	      if (args.length < 1) {
//	        System.out.println("Usage: HdfsWordCount <directory>");
//	        System.exit(1);
//	      }
	   
	      //StreamingExamples.setStreamingLogLevels()
	  		//spark heartbeat executor was 10000s last time
	     // SparkConf conf = new SparkConf().setAppName("HdfsWordCount");
//	      SparkConf conf = new SparkConf().setAppName("HdfsWordCount").setMaster("spark://192.168.1.107:7077").set("spark.driver.host", "192.168.1.107")
//	    		  .set("spark.executor.heartbeatInterval", "1000000s");
//	      System.setProperty("spark.executor.memory", "256m");
//	      System.setProperty("spark.driver.memory", "256m");
//	      System.setProperty("spark.executor.instances", "999");
	  
      SparkConf conf = new SparkConf().setAppName("HdfsWordCount").setMaster("spark://192.168.1.107:7077").set("spark.driver.host", "192.168.1.107")
    		  .set("spark.executor.heartbeatInterval", "1000000s").set("spark.cores.max", "2").set("spark.driver.memory", "512m");
	      // Create the context
	      JavaStreamingContext ssc = new JavaStreamingContext(conf, new Duration(500));
	     
	      
	      Logger rootLogger = Logger.getRootLogger();
	      
	      rootLogger.setLevel(Level.ERROR);
	   
	      // Create the FileInputDStream on the directory and use the
	      // stream to count words in new files created
	       JavaDStream<String> lines = ssc.textFileStream("hdfs://master:9000/test/");
	      
	      

	      
	      
	      JavaDStream<String> words = lines.flatMap(
	    		  new FlatMapFunction<String, String>() {
	    		    @Override public Iterator<String> call(String x) {
	    		    	System.out.println("starting flatMap at" + System.currentTimeMillis());
	    		    	
		    			double maxtv1 = 5.41;
		    			double maxtv2 = .61;
		    			double maxtv3 = 2.27;
		    			double maxtv4 = 2.27;
		    			double maxtv5 = 2.27;

		    			double mintv1 = 0;
		    			double mintv2 = -2.27;
		    			double mintv3 = -2.27;
		    			double mintv4 = -2.27;
		    			double mintv5 = -2.27;
//		    			
		    			String words[] = x.split(" ");
		    			double joint = Double.parseDouble(words[0]);
		    			double theta1 = Double.parseDouble(words[1]);
		    			double theta2 = Double.parseDouble(words[2]);
		    			double theta3 = Double.parseDouble(words[3]);
		    			double theta4 = Double.parseDouble(words[4]);
		    			double theta5 = Double.parseDouble(words[5]);
		    			
		    			double t1 = 41.29;
		    			double t2 = 10.008;
		    			double t3 = 33.46;
		    			double t4 = 15;
		    			double t5 = 10.278;
		    			
		    			int tick1 = (int) (t1*Math.toDegrees(theta1 + (-mintv1))) - 5800;
		    			int tick2 = (int) (t2*Math.toDegrees(theta2 + (-mintv2)));
		    			int tick3 = (int) (t3*Math.toDegrees(theta3 + (-mintv3)));
		    			int tick4 = (int) (t4*Math.toDegrees(theta4 + (-mintv4))) -2800;
		    			int tick5 = (int) (t5*Math.toDegrees(theta5 + (-mintv5))) -2600;
		    			
		    			//if (Integer.parseInt(words[6]) == 0 ||Integer.parseInt(words[6]) == 1000) {
		    			
		    			if (Integer.parseInt(words[6]) == 10) {
		    			try{
		    			    PrintWriter writer = new PrintWriter("/home/hduser/thetas.txt", "UTF-8");

		    			    writer.printf("" + (float) tick1 + "\n" + (float) tick2 + "\n" + (float) tick3 + "\n" + (float) tick4 + "\n" + (float) -tick4 + "");
		    			    writer.close();
		    			} catch (IOException e) {
		    			   // do something
		    			}
		    			}
	    		      return Arrays.asList(x.split("/")).iterator();
	    		    }
	    		  });
	      
	      
	      

	      
	      //JavaDStream jacobian = words.map(f);
	      
	      //JavaDStream<String> dog1 = words.map(new jacobPart());
	      
	      
		//dog1.print();
	      
	      class jacobPart implements Function2<String, String, String> {

	    	  public String call(String v, String s) throws IOException, URISyntaxException { 
	    		  System.out.println("first time reducing " +System.currentTimeMillis());
	    		  long before = System.currentTimeMillis();
	    		  //System.out.println("Actual calculations time: " +System.currentTimeMillis());
	    		  String currentLine = s.toString();
	    		  String words[] = currentLine.split(" ");
	    		  double joint = Double.parseDouble(words[0]);
	    		  String output = "";
	    		  if (joint ==3 || joint == 4 || joint == 5) {
	    			double dtheta = .01;
	    			
//	    			//System.out.println("MyMapper.map(): Offset" + offset + "  :: CurrentLine=" + currentLine);
//
//	    			// apple dog cat
	    			
	    			double maxtv1 = 5.41;
	    			double maxtv2 = .61;
	    			double maxtv3 = 2.27;
	    			double maxtv4 = 2.27;
	    			double maxtv5 = 2.27;

	    			double mintv1 = 0;
	    			double mintv2 = -2.27;
	    			double mintv3 = -2.27;
	    			double mintv4 = -2.27;
	    			double mintv5 = -2.27;
//	    			
	    			double theta1 = Double.parseDouble(words[1]);
	    			double theta2 = Double.parseDouble(words[2]);
	    			double theta3 = Double.parseDouble(words[3]);
	    			double theta4 = Double.parseDouble(words[4]);
	    			double theta5 = Double.parseDouble(words[5]);
	    			
	    			double t1 = 41.29;
	    			double t2 = 10.008;
	    			double t3 = 33.46;
	    			double t4 = 15;
	    			double t5 = 10.278;
	    			
	    			int tick1 = (int) (t1*Math.toDegrees(theta1 + (-mintv1)));
	    			int tick2 = (int) (t2*Math.toDegrees(theta2 + (-mintv2)));
	    			int tick3 = (int) (t3*Math.toDegrees(theta3 + (-mintv3)));
	    			int tick4 = (int) (t4*Math.toDegrees(theta4 + (-mintv4)));
	    			int tick5 = (int) (t5*Math.toDegrees(theta5 + (-mintv5)));
	    			
	    			//if (Integer.parseInt(words[6]) == 0 ||Integer.parseInt(words[6]) == 1000) {
//	    			try{
//	    			    PrintWriter writer = new PrintWriter("/home/hduser/thetas.txt", "UTF-8");
//
//	    			    writer.printf("" + (float) tick1 + "\n" + (float) tick2 + "\n" + (float) tick3 + "\n" + (float) tick4 + "\n" + (float) tick5 + "");
//	    			    writer.close();
//	    			} catch (IOException e) {
//	    			   // do something
//	    			}
//	    			//}
	    			
	    			DoubleMatrix cPos = fK(theta1,theta2,theta3,theta4,theta5);
	    			
	    			if (joint == 1) {
	    				theta1 = theta1 + dtheta;
	    			}
	    			else if (joint == 2) {
	    				theta2 = theta2 + dtheta;
	    			}
	    			else if (joint == 3) {
	    				theta3 = theta3 + dtheta;
	    			}
	    			else if (joint == 4) {
	    				theta4 = theta4 + dtheta;
	    			}
	    			else if (joint == 5) {
	    				theta5 = theta5 + dtheta;
	    			}
	    			
//	    			 //Do something............
	    			
	    			
	    			
	    			 DoubleMatrix fk1 = fK(theta1,theta2,theta3,theta4,theta5);
	    			 DoubleMatrix jPiece = new DoubleMatrix(7,1);
	    			 int i = 0;
	    			 for( i = 0; i < 6; i++) {
	    				 jPiece.put(i,0, (fk1.get(i,0) - cPos.get(i,0))/dtheta );
	    			 }
	    			 jPiece.put(6,0,joint);
	    			 
	    			 output = "" + jPiece.get(0,0) + " " +
	    					 jPiece.get(1,0) + " " +
	    					 jPiece.get(2,0) + " " +
	    					 jPiece.get(3,0) + " " +
	    					 jPiece.get(4,0) + " " +
	    					 jPiece.get(5,0) + " " +
	    					 jPiece.get(6,0) + " " + " " + words[5] + "";
	    			 
	    			 //output = "0 1 2 3 4 5 " + joint + "";
	    			 
		                Configuration conf = new Configuration();
		                conf.set("fs.default.name", "hdfs://master:9000");
		                
		                
	 			      FileSystem ds = FileSystem.get(new URI("hdfs://master:9000"),new Configuration());
	 			      Path file = new Path("hdfs://master:9000/results/ayo" + joint + "");
	 			      //FSDataInputStream in = ds.open(file);
	 			      BufferedWriter nBr=new BufferedWriter(new OutputStreamWriter(ds.create(file,true)));


	 				
	 			        //wLine=pairs.toString();
	 			        //pairs.save
	 			        nBr.write(output);
	 			        nBr.close();
	 			        
	 			        if (joint == 5) {
	 			        	Path done = new Path("hdfs://master:9000/done/work2" + words[6] + "");
	 		 			    BufferedWriter dBr=new BufferedWriter(new OutputStreamWriter(ds.create(done,true)));
	 		 			    dBr.write("0");
	 		 			    dBr.close();
	 			        }
	 			       long after = System.currentTimeMillis();			
	 			       System.out.println("Time taken is:" + ((after-before)) + "");
	    		  }
	    			 

	    		  return output; }
	    	}
	     
		words.foreachRDD(
		  new VoidFunction<JavaRDD<String>>() {
			  
			  
			
		    @Override
		    
		    public void call(JavaRDD<String> rdd) throws IOException, URISyntaxException {

		    	
		    	if (!rdd.partitions().isEmpty()) {
		    		
		            long before = System.currentTimeMillis();
		    		//System.out.println("Ayo we got here");
		    		//dog1.dstream().saveAsObjectFiles("hdfs://ayo/here","txt");
		    		rdd.reduce(new jacobPart());
		    		
		    		
		    		long after = System.currentTimeMillis();
		    		
		    		

		    		//System.out.println("Time taken is:" + ((after-before)) + "");
		    		
		    	}
		    }

		  }
		);

			
	      ssc.start();
	      ssc.awaitTermination();
	      
  }
  
	public static DoubleMatrix fK(double theta1,double theta2,double theta3,double theta4,double theta5)  {
		
		double alpha1 = - (Math.PI/2);
		double alpha2 = 0;
		double alpha3 = 0;
		double alpha4 = Math.PI/2;
		double alpha5 = 0;
		
		//distance in the x direction from frame to frame
		double r1 = 0;
		double r2 = 0.729;
		double r3 = 0.729;
		double r4 = 0.0;
		double r5 = 0.0;
		
		double d1 = 1.145;
		double d2 = 0;
		double d3 = 0;
		double d4 = 0;
		double d5 = .354;

		
		Matrix nA1 = new Matrix(findT(theta1,r1,d1,alpha1).toArray2());
		Matrix nA2 = new Matrix(findT(theta2,r2,d2,alpha2).toArray2());
		Matrix nA3 = new Matrix(findT(theta3,r3,d3,alpha3).toArray2());
		Matrix nA4 = new Matrix(findT(theta4,r4,d4,alpha4).toArray2());
		Matrix nA5 = new Matrix(findT(theta5,r5,d5,alpha5).toArray2());
		
		//System.out.println(nA1.get(1,2));
		Matrix homoGen1 =(((((nA1.times(nA2)).times(nA3)).times(nA4)).times(nA5)));
		
		DoubleMatrix homoGen = (new DoubleMatrix(homoGen1.getArray()));
		
		DoubleMatrix cPos = new DoubleMatrix(6,1);
		
		
		
		
		cPos.put(0,0,homoGen.get(0,3));
		cPos.put(1,0,homoGen.get(1,3));
		cPos.put(2,0,homoGen.get(2,3));
		cPos.put(3,0, Math.atan2(-homoGen.get(2,0),(Math.sqrt(homoGen.get(2,1)*homoGen.get(2,1) + homoGen.get(2,2)*homoGen.get(2,2)))));
		cPos.put(4,0,Math.atan2(homoGen.get(1,0), homoGen.get(0,0)));
		cPos.put(5,0,Math.atan2(homoGen.get(2,1), homoGen.get(2,2)));
		
		return cPos;
		
		
		
	}
	
	
	
	public static DoubleMatrix findT(double theta, double r, double d, double alpha) {
		
		DoubleMatrix A1 = new DoubleMatrix(4,4);
		A1.put(0, 0, Math.cos(theta));
		A1.put(0, 1, -Math.sin(theta)*Math.cos(alpha));
		A1.put(0, 2, Math.sin(theta)*Math.sin(alpha));
		A1.put(0, 3, r*Math.cos(theta));
		
		A1.put(1, 0, Math.sin(theta));
		A1.put(1, 1, Math.cos(theta)*Math.cos(alpha));
		A1.put(1, 2, -Math.cos(theta)*Math.sin(alpha));
		A1.put(1, 3, r*Math.sin(theta));
		
		A1.put(2, 0, 0);
		A1.put(2, 1, Math.sin(alpha));
		A1.put(2, 2, Math.cos(alpha));
		A1.put(2, 3, d);
		
		A1.put(3, 0, 0);
		A1.put(3, 1, 0);
		A1.put(3, 2, 0);
		A1.put(3, 3, 1);
		
	
		return A1;
	
	}
}