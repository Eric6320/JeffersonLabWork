import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Random;

public class generateQuadraticStrengths {

	public static Random r;
	public static boolean percentage;
	
	public static void main(String[] args) {
		try {
			String quadName = args[0];
			int leftBound = Integer.parseInt(args[1]);
			int rightBound = Integer.parseInt(args[2]);
			int N = Integer.parseInt(args[3]);
			File readFile = new File(args[4]);
			File writeFile = new File(args[5]);

			BufferedReader br = new BufferedReader(new FileReader(readFile));
			PrintWriter pw = new PrintWriter(new FileWriter(writeFile));

//			System.out.printf("%s %f %d %016X %s %s\n",quadName,percentage,N,seed,writeFile,readFile);

			String[] splitLine;
			double strength = 0;
			String line;
			readLoop:
			while ((line = br.readLine()) != null) {
//				System.out.println(line);
				if (line.contains(quadName)) {
					line = br.readLine();
					
					splitLine = line.split(" ");
					strength = Double.parseDouble(splitLine[2].substring(3, splitLine[2].length()-1));
					break readLoop;
				}
			}
			
			double stepSize = (rightBound-leftBound);
			stepSize = stepSize / N;
			System.out.println("Left Bound: "+leftBound+", Right Bound: "+rightBound+", N: "+N+", stepSize: "+stepSize);
			for (double i = leftBound; i < rightBound; i += stepSize) {
//				System.out.println(i);
				pw.println(i);
			}

			br.close();
			pw.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
