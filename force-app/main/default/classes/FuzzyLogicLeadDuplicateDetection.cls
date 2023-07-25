public class FuzzyLogicLeadDuplicateDetection {
    
    // Fuzzy matching algorithm example using Levenshtein distance
    public static Integer calculateLevenshteinDistance(String s1, String s2) {
        if (s1 == null || s2 == null) {
            return 0;
        }
        
        //Integer[][] distance = new Integer[s1.length() + 1][s2.length() + 1];
        List<List<Integer>> dp = new List<List<Integer>>();
        for (Integer i = 0; i <= s1.length(); i++) {
            //distance[i][0] = i;
            dp.add(new List<Integer>());
            dp[i].add(i);
        }
        System.debug('-1st Dp-'+dp);
        for (Integer j = 0; j <= s2.length(); j++) {
            //distance[0][j] = j;
            dp[0].add(j);
        }
        System.debug('-2st Dp-'+dp);
        for (Integer i = 1; i <= s1.length(); i++) {      
            for (Integer j = 1; j <= s2.length(); j++) {
                Integer substitutionCost = (s1.charAt(i - 1) != s2.charAt(j - 1)) ? 1 : 0;
                System.debug('---substitutionCost---'+substitutionCost);
                dp[i].add(Math.min(dp[i - 1][j] + 1, Math.min(dp[i][j - 1] + 1, dp[i - 1][j - 1] + substitutionCost)));
            }
            System.debug('---In 3nd DP---'+dp);
        }
       	System.debug('---3nd DP---'+dp);
        return dp[s1.length()][s2.length()];
    }

    // Fuzzy logic implementation for lead duplicate detection
    public static void fuzzyLogicLeadDuplicateDetection(List<Lead> leads) {
        System.debug('fuzzyLogicLeadDuplicateDetection::lead::'+leads);
        Map<String, List<Lead>> fuzzyMatches = new Map<String, List<Lead>>();
        Double threshold = 0.8; // Example threshold value
        
        // Create a map of lead names and their respective leads
        Map<String, List<Lead>> leadMap = new Map<String, List<Lead>>();
        for (Lead lead : leads) {
            String key = lead.Name.toLowerCase().replaceAll('[^a-z0-9]', '');
            System.debug('--leadMap::key--'+key);
            if (!leadMap.containsKey(key)) {
                leadMap.put(key, new List<Lead>());
            }
            leadMap.get(key).add(lead);
        }
         System.debug('leadMap::lead::'+leadMap);
        // Iterate through the lead map to find fuzzy matches
        for (String key : leadMap.keySet()) {
            System.debug('--key--'+key);
            List<Lead> leadList = leadMap.get(key);
            System.debug('--leadList--'+leadList);
             System.debug('--leadList--'+leadList.size());
            if (!leadList.isEmpty()) {
                System.debug('-In If-');
                for (Integer i = 0; i < leadList.size(); i++) {
                    for (Integer j = i + 1; j < leadList.size(); j++) {
                        System.debug('--leadList[i]--'+leadList[i]);
                        System.debug('--leadList[j]--'+leadList[j]);
                        Lead lead1 = leadList[i];
                        Lead lead2 = leadList[j];
                        
                        Double similarityScore = calculateLevenshteinDistance(lead1.Name, lead2.Name) / (double) Math.max(lead1.Name.length(), lead2.Name.length());
                        System.debug('--similarityScore--'+similarityScore);
                        if (similarityScore >= threshold) {
                            String leadId1 = lead1.Id;
                            String leadId2 = lead2.Id;
                           	System.debug('--leadId1--'+leadId1);
                            if (!fuzzyMatches.containsKey(leadId1)) {
                                fuzzyMatches.put(leadId1, new List<Lead>());
                            }
                            fuzzyMatches.get(leadId1).add(lead2);
                            
                            if (!fuzzyMatches.containsKey(leadId2)) {
                                fuzzyMatches.put(leadId2, new List<Lead>());
                            }
                            fuzzyMatches.get(leadId2).add(lead1);
                            System.debug('--fuzzyMatches--'+fuzzyMatches);
                        }
                    }
                }
            }
        }
        
        // Process fuzzy matches
        for (String leadId : fuzzyMatches.keySet()) {
            System.debug('--leadId--'+leadId);
            List<Lead> matches = fuzzyMatches.get(leadId);
            
            // Perform actions for the duplicate leads based on your requirements
            // For example, you can update a custom field or merge the duplicate leads
            for (Lead match : matches) {
                // Perform your actions here
                System.debug('--match--'+match);
            }
        }
    }
}