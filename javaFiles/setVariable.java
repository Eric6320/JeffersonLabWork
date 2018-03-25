import java.util.Arrays;

public class setVariable {
	
	/**
	 * Script used to set a variable to either a designated value, or default value if identification string is not found
	 * @param args Arguments to search through in order to find the specified string
	 */
	public static void main(String[] args) {
		String stringToFind = args[0]; // Variable identifier
		String result = args[1]; // Initialize the result value as the default value. Will not update if string isn't found
		
		// Merge all of the arguments into one string
		String argString = String.join(" ", Arrays.copyOfRange(args, 2, args.length));
		// Find the starting index of stringToFind
		int indexOfStringToFind = argString.indexOf(stringToFind);
		
		// If the string is found, set result equal to everything between the '=' and ','
		if (indexOfStringToFind > -1) {
			indexOfStringToFind += +stringToFind.length()+1;
			String newSubstring = argString.substring(indexOfStringToFind);
			int indexOfColon = argString.substring(indexOfStringToFind).indexOf(',') + (argString.length()-newSubstring.length());
			
			result = argString.substring(indexOfStringToFind, indexOfColon);
			
		}
		
		// Print the result to terminal so it can be stored as a shell script variable
		System.out.println(result);
		
	}
}
