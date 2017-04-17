package my.spark;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.URI;
import java.net.URISyntaxException;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.FSDataInputStream;
import org.apache.hadoop.fs.FileSystem;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;
import org.ejml.simple.SimpleMatrix;
import org.jblas.DoubleMatrix;
import org.jblas.Solve;

import Jama.Matrix;



public class driver {

		public static void main(String[] args) throws IOException, ClassNotFoundException, InterruptedException, URISyntaxException {
			// TODO Auto-generated method stub

			// broken joint
			//set equal to 1 for broken joint
			double broken1 = 0;
			double broken2 = 1;
			double broken3 = 0;
			double broken4 = 0;
			double broken5 = 0;
			
			int numHealthy = 5 - (int)(broken1+broken2+broken3+broken4+broken5);
			boolean broken = false;
			int jacobSize = 6;
			
			double robotJoints[] = {broken1, broken2, broken3, broken4, broken5};
			
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
			
			Double []maxRow = {maxtv1, maxtv2, maxtv3, maxtv4, maxtv5};
			Double[]minRow = {mintv1, mintv2, mintv3, mintv4, mintv5};
			
			//encoder ticks in total range of motion
			double joint1 = 2871.165;
			double joint2 = 1651.335;
			double joint3 = 3068;
			double joint4 = 2286.835;
			double joint5 = 1431;
			
			//thetas
//			double theta1 = 2.27; 
//			double theta2 =  -2.27;
//			double theta3 = 2.27;
//			double theta4 = 0;
//			double theta5 = 0.0;
			
			double theta1 = 2.27; 
			double theta2 =  -2.27;
			double theta3 = -1.5;
			double theta4 = 1.27;
			double theta5 = 0.0;
			
			//ranges 
			int [] rang6 = {0,1,2,3,4,5};
			int[] rang3 = {0,1,2}; 
			
			
			double thetaRow[] = {theta1,theta2,theta3,theta4,theta5};
			
			//current position
			DoubleMatrix cPos = fK(theta1,theta2,theta3,theta4,theta5);
			
			// real 6 point position
			DoubleMatrix rPos = cPos;
			
			//
			//cPos = [ newDog(1,1);newDog(2,1);newDog(3,1); newEul(1,1); newEul(2,1); newEul(3,1) ];
			if (broken1 == 1 || broken2 == 1|| broken3 == 1 || broken4 == 1|| broken5 == 1) {
			    cPos = cPos.get(rang3, 0);
			    broken = true;
			    jacobSize = 3;
			}
			
			System.out.println(cPos.toString());
			
			//target position
			//[1.65;0;1.5948;0.4;0.93;2.3];
			//%targetPos = [.08;.2977;1.89;-1.2;1.3;0];
			DoubleMatrix tPos = new DoubleMatrix(6,1);
//			tPos.put(0, 0, .124);
//			tPos.put(1, 0, -.148);
//			tPos.put(2, 0, 2.485955);
//			tPos.put(3, 0, -1.2);
//			tPos.put(4, 0, 1.3);
//			tPos.put(5, 0, 0);
			
			tPos.put(0, 0, -.57);
			tPos.put(1, 0, -.69);
			tPos.put(2, 0, .75);
			tPos.put(3, 0, -1.2);
			tPos.put(4, 0, 1.3);
			tPos.put(5, 0, 0);
//			
			//6 value error
			DoubleMatrix trueError = tPos.sub(rPos);
			
			//cPos = [ newDog(1,1);newDog(2,1);newDog(3,1); newEul(1,1); newEul(2,1); newEul(3,1) ];
			if (broken1 == 1 || broken2 == 1|| broken3 == 1 || broken4 == 1|| broken5 == 1) {
			    tPos = tPos.get(rang3, 0);
			    trueError.put(3,0,0);
			    trueError.put(4,0,0);
			    trueError.put(5,0,0);
			    jacobSize = 3;
			}
			
			
			DoubleMatrix error = tPos.sub(cPos);
			
			double eScale = 1;
			double dtheta = .01;
			
			//allocatre space maybe
			
			DoubleMatrix jacobian = new DoubleMatrix(jacobSize,numHealthy);
			DoubleMatrix jFull = new DoubleMatrix(6,5);
			DoubleMatrix jinv = new DoubleMatrix(5,6);
			SimpleMatrix dthetab = new SimpleMatrix(6,1);
			SimpleMatrix derror = new SimpleMatrix(6,1);

			
			int n = 0;
			
			int counter = 0;
			
			//tick values
			short tick1 = 0;
			short tick2 = 0;
			short tick3 = 0;
			short tick4 = 0;
			short tick5 = 0;
//			
//			Configuration conf = new Configuration();
//			
//			//prepare a job onbject
//			Job job = new Job();
			
			//psth to files
			String dog = "hdfs://master:9000/test/helper";
			String cat = "hdfs://master:9000/test/thetas6";
			
            Configuration conf = new Configuration();
            conf.set("fs.default.name", "hdfs://master:9000");
            FileSystem fs = FileSystem.get(conf);
			
			//FileSystem fs = FileSystem.get(new URI("hdfs://master:9000"),new Configuration());
			
			Path nFile = new Path(cat);
			//FSDataInputStream nThetas = fs.open(file);
			//BufferedWriter nBr=new BufferedWriter(new OutputStreamWriter(fs.create(nFile,true)));
			

	        String wLine;
	        wLine="0"  + " "+theta1 + " " +theta2 + " " +theta3 + " " +theta4 + " " +theta5 + " 0" + " dog" + "/"
	        	+ "1" + " "+theta1 + " " +theta2 + " " +theta3 + " " +theta4 + " " +theta5 + " 0" + "/"
	        	+ "2" + " "+theta1 + " " +theta2 + " " +theta3 + " " +theta4 + " " +theta5 + " 0" + "/"
	        	+ "3" + " "+theta1 + " " +theta2 + " " +theta3 + " " +theta4 + " " +theta5 + " 0" + "/"
	        	+ "4" + " "+theta1 + " " +theta2 + " " +theta3 + " " +theta4 + " " +theta5 + " 0" + "/"
	        	+ "5" + " "+theta1 + " " +theta2 + " " +theta3 + " " +theta4 + " " +theta5 + " 0" + "";
	        
	        //System.out.println(System.currentTimeMillis());

			BufferedWriter nBr=new BufferedWriter(new OutputStreamWriter(fs.create(nFile,true)));
			
			long last = System.currentTimeMillis();
	        nBr.write(wLine);

	        nBr.close();
	        //long last = System.currentTimeMillis();
			while(!(fs.exists(new Path(cat)))) {
				
			}
			//long now = System.currentTimeMillis();
			
			//System.out.println("the time spent:" + (now-last));
			
			BufferedReader brz=new BufferedReader(new InputStreamReader(fs.open(new Path(cat))));

			//brz=new BufferedReader(new InputStreamReader(in));
			while (!brz.ready()) {
				brz=new BufferedReader(new InputStreamReader(fs.open(new Path(cat))));
			}
			
			long now = System.currentTimeMillis();
			
			System.out.println("the time spent:" + (now-last));
			//BufferedReader brz=new BufferedReader(new InputStreamReader(fs.open(new Path(cat))));
			
			
	       // System.out.println(wLine);
			
	        String ayo1="hdfs://master:9000/results/ayo1.0";
	        String ayo2="hdfs://master:9000/results/ayo2.0";
	        String ayo3="hdfs://master:9000/results/ayo3.0";
	        String ayo4="hdfs://master:9000/results/ayo4.0";
	        String ayo5="hdfs://master:9000/results/ayo5.0";
//	        String ayo6="hdfs://master:9000/results/ayo6";
	        String fin="hdfs://master:9000/finished/hey";
	        Path pJ1 = new Path(ayo1);
	        Path pJ2 = new Path(ayo2);
	        Path pJ3 = new Path(ayo3);
	        Path pJ4 = new Path(ayo4);
	        Path pJ5 = new Path(ayo5);
//	        Path pJ6 = new Path(ayo6);
	        
			
			Path file = new Path(dog);
			FSDataInputStream in = fs.open(file);
			//BufferedReader br=new BufferedReader(new InputStreamReader(in));
			///BufferedReader br0=new BufferedReader(new InputStreamReader(in));
			BufferedReader br1=new BufferedReader(new InputStreamReader(in));
			BufferedReader br2=new BufferedReader(new InputStreamReader(in));
			BufferedReader br3=new BufferedReader(new InputStreamReader(in));
			BufferedReader br4=new BufferedReader(new InputStreamReader(in));
			BufferedReader br5=new BufferedReader(new InputStreamReader(in));
//			BufferedReader br6=new BufferedReader(new InputStreamReader(in));
			
            //String line;
            //line=br.readLine();
            
            
            long before = System.currentTimeMillis();
            long after = System.currentTimeMillis();
            
            System.out.println();
            
            
			while ( counter < 0) {
    		//while ( Math.abs(trueError.get(0,0)) > .05 || Math.abs(trueError.get(1,0)) > .05 || Math.abs(trueError.get(2,0)) > .05 ||  Math.abs(trueError.get(3,0)) > .05 || Math.abs(trueError.get(4,0)) > .05 || Math.abs(trueError.get(5,0)) > .05 ) {
    			
//    			before = System.currentTimeMillis();
//    			after = System.currentTimeMillis();
				
				while(!(fs.exists(new Path("hdfs://master:9000/done/work1" + counter)))) {
					
				}
				
				while(!(fs.exists(new Path("hdfs://master:9000/done/work2" + counter)))) {
					
				}
				

				//before = System.currentTimeMillis();
//				while(!(fs.exists(new Path(ayo1)))) {
//					
//				}
//				while(!(fs.exists(new Path(ayo2)))) {
//					
//				}
//				while(!(fs.exists(new Path(ayo3)))) {
//					
//				}
//				while(!(fs.exists(new Path(ayo4)))) {
//					
//				}
//				while(!(fs.exists(new Path(ayo5)))) {
//					
//				}
				

				
				//Thread.sleep(500);
				
				//System.out.println(System.currentTimeMillis());

				in = fs.open(pJ1);
				br1=new BufferedReader(new InputStreamReader(in));
//				while (!br1.ready()) {
//					br1=new BufferedReader(new InputStreamReader(fs.open(new Path(ayo1))));
//				}
				String j1[] = br1.readLine().split(" "); 
	            //System.out.println(System.currentTimeMillis());

				
				in = fs.open(pJ2);
				br2=new BufferedReader(new InputStreamReader(in));
//				while (!br2.ready()) {
//					br2=new BufferedReader(new InputStreamReader(fs.open(new Path(ayo2))));
//				}
				String j2[]= br2.readLine().split(" ");
				
				in = fs.open(pJ3);
				br3=new BufferedReader(new InputStreamReader(in));
//				while (!br3.ready()) {
//					br3=new BufferedReader(new InputStreamReader(fs.open(new Path(ayo3))));
//				}
				String j3[]= br3.readLine().split(" ");
				
				in = fs.open(pJ4);
				br4=new BufferedReader(new InputStreamReader(in));
//				while (!br4.ready()) {
//					br4=new BufferedReader(new InputStreamReader(fs.open(new Path(ayo4))));
//				}
				String j4[]= br4.readLine().split(" "); 
				
				in = fs.open(new Path(ayo5));
				br5=new BufferedReader(new InputStreamReader(in));
//				while (!br5.ready()) {
//					br5=new BufferedReader(new InputStreamReader(fs.open(new Path(ayo5))));
//				}
				String j5[]=br5.readLine().split(" "); 
				
				//after = System.currentTimeMillis();
//				in = fs.open(pJ6);
//				 br6=new BufferedReader(new InputStreamReader(in));
//				String j6[]=br6.readLine().split(" "); 
//				
	            int position = 0;
	            
	            //System.out.println(j1[1]);
	            while (position < 6) {
            		jFull.put(position, 0, Double.parseDouble(j1[position]));
            		jFull.put(position, 1,Double.parseDouble(j2[position]));
            		jFull.put(position, 2,Double.parseDouble(j3[position]));
            		jFull.put(position, 3,Double.parseDouble(j4[position]));
            		jFull.put(position, 4,Double.parseDouble(j5[position]));
            		//jFull.put(position, 5,Double.parseDouble(j6[position]));
	            	
            		position++;
	            }

	            
	            //System.out.println(jacobian.toString());
	            
	            
				 //loop values
				 int l = 0;
				 int o = 0;
				 
				//construct used jacobian, depenfs on if any joints broken
				 while (l < 5) {
					 if (robotJoints[l] == 0) {
						 if (broken == false) {
							 jacobian.put(rang6,o,jFull.get(rang6,l));
						 }
						 else {
							 jacobian.put(rang3,o,jFull.get(rang3,l));
						 }
						 o++;
					 }
					 l++;
				 }
				 //System.out.println(error);
				 
				 //used SimpleMatrix because its pinv is better than DoubleMatrix
				 SimpleMatrix simpleJac = new SimpleMatrix(jacobian.toArray2());
				 SimpleMatrix simpleIn = simpleJac.pseudoInverse();
				 
	    		//finding inverse
	    		//jinv = Solve.pinv(jacobian);
	    		//System.out.println("THIS IS SIMPLE JAC");
	    		//System.out.println(simpleJac);
	    		derror = new SimpleMatrix(error.div(eScale).toArray2());
	    		//System.out.println(derror);
	    		
	    		dthetab = simpleIn.mult(derror);
	    		
	    		//loop values
	    		int h = 0;
	    		int g = 0;
	    		
	    		//System.out.println(dthetab.toString());
	    		
	    		//divide if inverse spits values that are too big
	    		while (h < 5) {
	    			while (Math.abs(dthetab.get(g,0)) > .69) {
	    				dthetab.set(g,0,dthetab.get(g,0)/10);
	    				g++;
	    			}
	    			h++;
	    		}
	    		

	    		//loop values
	    		int index = 0;
	    		int z = 0;
	    		
	    		//move theta by small amount and enfore theta limits
	    		for (index=0; index < 5; index++) {
	    		    if (robotJoints[index] == 0) {
	    		        thetaRow[index] = (thetaRow[index] + dthetab.get(z,0));
	    		        if (thetaRow[index] > maxRow[index]){
	    		            thetaRow[index] = thetaRow[index] - dthetab.get(z,0);
	    		            dthetab.set(z,0,0);
	    		        }
	    		        else if (thetaRow[index] < minRow[index]){
	    		        	thetaRow[index] = thetaRow[index] - dthetab.get(z,0);
	    		        	dthetab.set(z,0,0);
	    		        }
	    		        z++;
	    		    }
	    		    
	    		}
	    		
//	    		thetaRow[0] = thetaRow[0] + dthetab.get(0,0);
//	    		thetaRow[1] = thetaRow[1]+ dthetab.get(1,0);
//	    		thetaRow[2] = thetaRow[2] + dthetab.get(2,0);
//	    		thetaRow[3] = thetaRow[3] + dthetab.get(3,0);
//	    		thetaRow[4] = thetaRow[4] + dthetab.get(4,0);
	    		theta1 = thetaRow[0];
	    		theta2 = thetaRow[1];
	    		theta3 = thetaRow[2];
	    		theta4 = thetaRow[3];
	    		theta5 = thetaRow[4];
//	    		
	    		
	    		//update real position
	    		rPos = fK(thetaRow[0],thetaRow[1],thetaRow[2],thetaRow[3],thetaRow[4]);
	    		
	    		//updare cPos accordingly
				 if (broken == false) {
					 //System.out.println("Here " + numHealthy);
					 cPos.put(rang6,0,rPos.get(rang6,0));
				 }
				 else {
					 cPos.put(rang3,rPos.get(rang3,0));
				 }
	    		error = tPos.sub(cPos);
	    	
	    		//System.out.println("C Pos is " +cPos.toString());
	    		n = n + 1;
	    		//System.out.println(n);
	    		
	    		//fs.delete(new Path(cat), true);
	    		
	    		//before = System.currentTimeMillis();
	    		
	    		fs.delete(new Path(ayo1), true);
//				while((fs.exists(new Path(ayo1)))) {
//					
//				}
	    		fs.delete(new Path(ayo2), true);
//				while((fs.exists(new Path(ayo2)))) {
//					
//				}
	    		fs.delete(new Path(ayo3), true);
//				while((fs.exists(new Path(ayo3)))) {
//					
//				}
	    		fs.delete(new Path(ayo4), true);
//				while((fs.exists(new Path(ayo4)))) {
//					
//				}
	    		fs.delete(new Path(ayo5), true);
	    		//fs.delete(new Path(fin), true);
	    		




//				while((fs.exists(new Path(ayo5)))) {
//					
//				}
				
				//in = fs.open(new Path(ayo5));
				//br5=new BufferedReader(new InputStreamReader(in));
				while (br5.ready()) {
				}
	    		
	    		cat = "hdfs://master:9000/test/thetas9" + counter+1 + "";
	    		
				//before = System.currentTimeMillis();
				nFile = new Path(cat);
	    		
				int nugent = counter+1;
	    		//nBr=new BufferedWriter(new OutputStreamWriter(fs.create(nFile,true)));
	            wLine="0"+ " "+theta1 + " " +theta2 + " " +theta3 + " " +theta4 + " " +theta5 + " " + nugent + " dog" + "/"
	    	        	+ "1" + " "+theta1 + " " +theta2 + " " +theta3 + " " +theta4 + " " +theta5 + " "  + nugent + "/"
	                	+ "2" + " "+theta1 + " " +theta2 + " " +theta3 + " " +theta4 + " " +theta5 + " "+ nugent +  "/"
	                	+ "3" + " "+theta1 + " " +theta2 + " " +theta3 + " " +theta4 + " " +theta5 + " "  + nugent +  "/"
	                	+ "4" + " "+theta1 + " " +theta2 + " " +theta3 + " " +theta4 + " " +theta5 + " "  + nugent +  "/"
	                	+ "5" + " "+theta1 + " " +theta2 + " " +theta3 + " " +theta4 + " " +theta5 + " " + nugent + "";
	            
	            nBr=new BufferedWriter(new OutputStreamWriter(fs.create(nFile,true)));
	            nBr.write(wLine);
	            nBr.close();
	            //after = System.currentTimeMillis();
	            
	            //System.out.println(wLine);

	            
				//System.out.println("JOBDONE");
				counter++;
				
				tick1 = (short) (joint1/Math.toDegrees(theta1));
				tick2 = (short) (joint2/Math.toDegrees(theta2));
				tick3 = (short) (joint3/Math.toDegrees(theta3));
				tick4 = (short) (joint4/Math.toDegrees(theta4));
				tick5 = (short) (joint5/Math.toDegrees(theta5));
				
			
//				try{
//				    PrintWriter writer = new PrintWriter("/home/hduser/Rodman.txt", "UTF-8");
//				    writer.println("" + tick1 + " " + tick2
//				    + " " + tick3  + " " + tick4
//				    + " " + tick5);
//				    writer.println("");
//				    writer.close();
//				} catch (IOException e) {
//				   // do something
//				}
				
				//make true error to enable entry in loop
				if (broken == true) {
					trueError.put(0, 0,error.get(0,0));
					trueError.put(1, 0,error.get(1,0));
					trueError.put(2, 0,error.get(2,0));
					trueError.put(3, 0,0);
					trueError.put(4, 0,0);
					trueError.put(5, 0,0);
				}
				
				before = after;
				after = System.currentTimeMillis();
				System.out.println("Time taken is:" + ((after-before)) + "");
				//System.out.println(theta1);
				//System.out.println(theta2);
				//System.out.println(theta3);
				//System.out.println(theta4);
				//System.out.println(theta5);
				//System.out.println("error is: " + error);
				
				System.out.println(n);
				System.out.println("C Pos is " +cPos.toString());
				
			}
			//System.out.println(System.currentTimeMillis());
			
    		System.out.println("TOTALLY DONE DUDE");
			int finishFlag = 1000;
            wLine="0"+ " "+theta1 + " " +theta2 + " " +theta3 + " " +theta4 + " " +theta5 + " " + finishFlag + " dog" + "/"
            		+ "1" + " "+theta1 + " " +theta2 + " " +theta3 + " " +theta4 + " " +theta5 + " "  + finishFlag + "/"
                	+ "2" + " "+theta1 + " " +theta2 + " " +theta3 + " " +theta4 + " " +theta5 + " "+ finishFlag +  "/"
                	+ "3" + " "+theta1 + " " +theta2 + " " +theta3 + " " +theta4 + " " +theta5 + " "  + finishFlag +  "/"
                	+ "4" + " "+theta1 + " " +theta2 + " " +theta3 + " " +theta4 + " " +theta5 + " "  + finishFlag +  "/"
                	+ "5" + " "+theta1 + " " +theta2 + " " +theta3 + " " +theta4 + " " +theta5 + " " + finishFlag +  "/"
                	+ "6" + " "+theta1 + " " +theta2 + " " +theta3 + " " +theta4 + " " +theta5 + " "  + finishFlag +  "";
            
            nBr=new BufferedWriter(new OutputStreamWriter(fs.create(nFile,true)));
            nBr.write(wLine);
            
            
            nBr.close();
            
    		fs.delete(new Path(ayo1), true);
//			while((fs.exists(new Path(ayo1)))) {
//				
//			}
    		fs.delete(new Path(ayo2), true);
//			while((fs.exists(new Path(ayo2)))) {
//				
//			}
    		fs.delete(new Path(ayo3), true);
//			while((fs.exists(new Path(ayo3)))) {
//				
//			}
    		fs.delete(new Path(ayo4), true);
//			while((fs.exists(new Path(ayo4)))) {
//				
//			}
    		fs.delete(new Path(ayo5), true);
    		//fs.delete(new Path(fin), true);
            
            System.out.println("C Pos is " +cPos.toString());
            
			
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
			double r4 = 0;
			double r5 = 0;
			
			double d1 = 1.145;
			double d2 = 0;
			double d3 = 0;
			double d4 = 0;
			double d5 = .354;
			
		
			
//			DoubleMatrix A1 = findT(theta1,r1,d1,alpha1);
//			DoubleMatrix A2 = findT(theta2,r2,d2,alpha2);
//			DoubleMatrix A3 = findT(theta3,r3,d3,alpha3);
//			DoubleMatrix A4 = findT(theta4,r4,d4,alpha4);
//			DoubleMatrix A5 = findT(theta5,r5,d5,alpha5);
			
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
