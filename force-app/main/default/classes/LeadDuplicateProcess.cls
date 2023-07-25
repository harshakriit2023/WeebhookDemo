public class LeadDuplicateProcess {
    public static Boolean isDuplicateAddress(String firstname,String lastname,String street) {
        System.debug('---isDuplicateAddress----');
        List<Lead> existingLeads = [SELECT Id,FirstName,LastName,Street FROM Lead WHERE Street != null AND FirstName != null AND LastName != null];
        System.debug('--existingLeads--'+existingLeads);
        
        for (Lead lead : existingLeads) {
            System.debug('---lead--'+lead);
            String existingFirstname = lead.FirstName;
            String existingLastname = lead.LastName;
            String existingStreet = lead.Street;
            Integer firstnameSimilarityRatio = calculateSimilarityRatio(firstname, existingFirstname);
            Integer lastnameSimilarityRatio = calculateSimilarityRatio(lastname, existingLastname);
            Integer streetSimilarityRatio = calculateSimilarityRatio(street, existingStreet);
            System.debug('===firstnameSimilarityRatio threshold ===' + firstnameSimilarityRatio);
            System.debug('===lastnameSimilarityRatio threshold===' + lastnameSimilarityRatio);
            System.debug('===streetSimilarityRatio threshold===' + streetSimilarityRatio);
            if (firstnameSimilarityRatio == 100 && lastnameSimilarityRatio == 100 && streetSimilarityRatio >= 80) {               
                    System.debug('-- This Lead is Duplicate ---' + lead);
                return true;
            }
        }       
        return false;
    }
    
    private static Integer calculateSimilarityRatio(String str1, String str2) {
        System.debug('--calculateSimilarityRatio----');
        System.debug('===str1==='+str1);
        System.debug('===str2==='+str2);
        Integer distance = calculateLevenshteinDistance(str1.toLowerCase(), str2.toLowerCase());
        System.debug('---distance--'+distance);
        Integer maxLength = Math.max(str1.length(), str2.length());
        System.debug('---maxLength--'+maxLength);
        return (Integer) ((1 - (distance / (double) maxLength)) * 100);
    } 
    private static Integer calculateLevenshteinDistance(String str1, String str2) {
        System.debug('---calculateLevenshteinDistance--');
        List<List<Integer>> dp = new List<List<Integer>>();
        
        for (Integer i = 0; i <= str1.length(); i++) {
            System.debug('---i--'+i);
            dp.add(new List<Integer>());
            dp[i].add(i);
        }     
        System.debug('--1st Dp----'+Dp);
        for (Integer j = 0; j <= str2.length(); j++) {
            dp[0].add(j);
        }
        System.debug('---2nd Dp---'+Dp);
        for (Integer i = 1; i <= str1.length(); i++) {
            for (Integer j = 1; j <= str2.length(); j++) {
                Integer substitutionCost = (str1.charAt(i - 1) != str2.charAt(j - 1)) ? 1 : 0;
                System.debug('---substitutionCost---'+substitutionCost);
                dp[i].add(Math.min(dp[i - 1][j] + 1, Math.min(dp[i][j - 1] + 1, dp[i - 1][j - 1] + substitutionCost)));
            }
            System.debug('---3nd DP---'+dp);
        }
        
        return dp[str1.length()][str2.length()];
    }
}