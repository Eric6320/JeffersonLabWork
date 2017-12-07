import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Collections;

public class calculateStatistics {
	static ArrayList<Double> linesList = new ArrayList<Double>();

	public static void readInValues(String fileName) {
		try {

			File file = new File(fileName);

			BufferedReader br;
			br = new BufferedReader(new FileReader(file));
			String line;

			while ((line = br.readLine()) != null) {
				linesList.add(Double.parseDouble(line));
			}

			br.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	public static double findAverage() {
		double sum = 0;
		
		for (double i : linesList) {
			sum += i;
		}
		
		return (sum/linesList.size());
	}
	
	public static double findMedian() {
		if (linesList.size()%2 != 0) {
			return linesList.get(linesList.size()/2);
		}
		
		return linesList.get((int) Math.floor(linesList.size()/2));
	}
	
	public static void main(String[] args) {
		readInValues(args[0]);
		Collections.sort(linesList);
		
		double max = linesList.get(linesList.size()-1);
		double min = linesList.get(0);
		double average = findAverage();
		double median = findMedian();
		
		System.out.println("Average: "+average);
		System.out.println("Max Value: "+max);
		System.out.println("Min Value: "+min);
		System.out.println("Spread: "+(max-min));
		System.out.println("Median Value: "+median);
	}
}
