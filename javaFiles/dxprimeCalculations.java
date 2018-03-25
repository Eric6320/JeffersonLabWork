import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;

/**
* Determines the quadrupole strength settings necessary to trace out an ellipse at a given BPM
*/
public class dxprimeCalculations {

	public double Xbpm;
	public double Xprimebpm;
	
	public double Abpm;
	public double B1;
	public double B2;
	public double Bbpm;
	public double P1;
	public double P2;
	public double Pbpm;
	
	public double B1bpm;
	public double B2bpm;
	public double B1Dbpm;
	public double B2Dbpm;
	
	public double P1bpm;
	public double P2bpm;
	
	public dxprimeCalculations(String[] args) {
		// Read in each command line argument, and parse it into the correct Twiss parameter variable
		Xbpm = Double.parseDouble(args[0]);
		Xprimebpm = Double.parseDouble(args[1]);
		Abpm = Double.parseDouble(args[2]);
		B1 = Double.parseDouble(args[3]);
		B2 = Double.parseDouble(args[4]);
		Bbpm = Double.parseDouble(args[5]);
		P1 = Double.parseDouble(args[6]);
		P2 = Double.parseDouble(args[7]);
		Pbpm = Double.parseDouble(args[8]);
		
		// Define some commonly repeated Beta terms for the sake of readability
		B1bpm = Math.sqrt(B1 * Bbpm);
		B2bpm = Math.sqrt(B2 * Bbpm);
		B1Dbpm = Math.sqrt(B1 / Bbpm);
		B2Dbpm = Math.sqrt(B2 / Bbpm);

		// Define some commonly repeated Psi terms for the sake of readability
		P1bpm = P1 - Pbpm;
		P2bpm = P2 - Pbpm;
	}

	// Use the global Twiss parameters to calculate kicker strength one
	public double calculateKickerStrengthOne() {
		double numeratorOne = Xprimebpm*B2bpm*Math.sin(P2bpm);
		double numeratorTwo = Xbpm*B2Dbpm*(Math.cos(P2bpm)+Abpm*Math.sin(P2bpm));
		double denominator = B1Dbpm*B2bpm*(Math.cos(P1bpm)+Abpm*Math.sin(P1bpm))*Math.sin(P2bpm)-B2Dbpm*B1bpm*Math.sin(P1bpm)*(Math.cos(P2bpm)+Abpm*Math.sin(P2bpm));
		double numeratorFinal = numeratorOne + numeratorTwo;
		double answer = numeratorFinal/denominator;
		
		return answer;
	}

	// Use the global Twiss parameters to calculate kicker strength two
	public double calculateKickerStrengthTwo() {
		double numeratorOne = -Xprimebpm*B1bpm*Math.sin(P1bpm);
		double numeratorTwo = -Xbpm*B1Dbpm*(Math.cos(P1bpm)+Abpm*Math.sin(P1bpm));
		double denominator = B1Dbpm*B2bpm*(Math.cos(P1bpm)+Abpm*Math.sin(P1bpm))*Math.sin(P2bpm)-B2Dbpm*B1bpm*Math.sin(P1bpm)*(Math.cos(P2bpm)+Abpm*Math.sin(P2bpm));
		double numeratorFinal = numeratorOne + numeratorTwo;
		double answer = numeratorFinal/denominator;
		
		return answer;
	}

	public static void main(String[] args) {
		
		try {
			BufferedReader br = new BufferedReader(new FileReader("betatronPositions.dat")); 
			PrintWriter pw = new PrintWriter(new FileWriter(args[0]));
			String line = br.readLine();
			double strengthOne;
			double strengthTwo;
			
			//Write all strengths to the file
			while (line != null) {
				dxprimeCalculations temp = new dxprimeCalculations(line.split(" "));
				strengthOne = temp.calculateKickerStrengthOne();
				strengthTwo = temp.calculateKickerStrengthTwo();
				
				if (strengthOne != 0 && strengthTwo != 0) {
					pw.printf("%s %s\n", strengthOne,strengthTwo);					
				}
				line = br.readLine();
			}

			br.close();
			pw.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
			
		
		
		//dxprimeCalculations temp = new dxprimeCalculations(args);
		
		//System.out.println(temp.calculateKickerStrengthOne()+" "+temp.calculateKickerStrengthTwo());
	}
}
