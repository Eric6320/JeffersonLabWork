import java.util.Arrays;

public class setVariable {
	public static void main(String[] args) {
		String stringToFind = args[0];
		String result = args[1];
		
		String argString = String.join(" ", Arrays.copyOfRange(args, 2, args.length));
		int indexOfStringToFind = argString.indexOf(stringToFind);
		
		if (indexOfStringToFind > -1) {
			indexOfStringToFind += +stringToFind.length()+1;
			String newSubstring = argString.substring(indexOfStringToFind);
			int indexOfColon = argString.substring(indexOfStringToFind).indexOf(',') + (argString.length()-newSubstring.length());
			
			result = argString.substring(indexOfStringToFind, indexOfColon);
			
		}
		
		System.out.println(result);
		
	}
}
