package com.echannel.util;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Locale;
import java.util.Set;
import java.util.regex.Pattern;

/**
 * Intelligent Clinical Validation Utility.
 * Performs medical sanity checks, gibberish detection, and whitelist matching
 * for prescriptions before dispatching to pharmacy queues.
 */
public class ClinicalValidator {

    // Common keyboard mash patterns to reject
    private static final String[] MASH_PATTERNS = {
        "asdf", "sdfg", "dfgh", "fghj", "ghjk", "hjkl",
        "qwer", "wert", "erty", "rtyu", "tyui", "yuio", "uiop",
        "zxcv", "xcvb", "cvbn", "vbnm",
        "lkjh", "kjhg", "jhgf", "hgfd", "gfds", "fdsa",
        "poiu", "oiuy", "iuyt", "uytr", "ytre", "trew", "rewq",
        "mnbv", "nbvc", "bvcx", "vcxz",
        "1234", "2345", "3456", "4567", "5678", "6789", "7890",
        "abcd", "bcde", "cdef", "defg", "efgh"
    };

    // Whitelist of medical keywords, drug types, units, and clinical terms
    private static final Set<String> MEDICAL_TERMS = new HashSet<>(Arrays.asList(
        // Common conditions / diagnoses
        "acute", "chronic", "fever", "cough", "cold", "flu", "infection", "headache", "migraine",
        "hypertension", "diabetes", "bronchitis", "asthma", "gastritis", "gerd", "allergy", "allergic",
        "dermatitis", "sinusitis", "pneumonia", "tonsillitis", "otitis", "rhinitis", "anemia", "arthritis",
        "ulcer", "rash", "covid", "uti", "urinary", "cardiac", "renal", "sprain", "fracture", "wound",
        "conjunctivitis", "eczema", "dyspepsia", "colitis", "gastric", "diarrhea", "vomiting", "nausea",
        "pain", "chest", "back", "abdominal", "throat", "hyperlipidemia", "insomnia", "anxiety", "depression",
        "hypothyroidism", "hyperthyroidism", "gout", "sciatica", "cellulitis", "measles", "dengue", "malaria",
        "typhoid", "vertigo", "fatigue", "acne", "psoriasis", "glaucoma", "cataract", "stroke", "epilepsy",
        "syndrome", "disease", "disorder", "viral", "bacterial", "fungal", "deficiency", "inflammation",
        "trauma", "edema", "arrhythmia", "ischemia", "infarction", "angina", "stenosis", "sepsis", "abscess",
        "carcinoma", "adenoma", "lipoma", "sarcoma", "lymphoma", "melanoma", "cyst", "polyp", "calculus",

        // Common dosage forms & units
        "tablet", "tablets", "tab", "tabs", "capsule", "capsules", "cap", "caps", "syrup", "syr",
        "suspension", "susp", "injection", "inj", "ointment", "cream", "gel", "drops", "drop",
        "inhaler", "spray", "lotion", "solution", "suppository", "patch", "mg", "g", "mcg", "ml", "iu",
        "puff", "puffs", "tsp", "tbsp", "spoonful",

        // Common frequencies & timings
        "od", "bd", "tds", "qds", "qid", "tid", "bid", "prn", "stat", "daily", "once", "twice", "thrice",
        "morning", "night", "evening", "afternoon", "meals", "food", "water", "hours", "days", "weeks", "months",

        // Common drug names
        "paracetamol", "panadol", "amoxicillin", "augmentin", "ibuprofen", "brufen", "omeprazole",
        "pantoprazole", "esomeprazole", "rabeprazole", "metformin", "atorvastatin", "rosuvastatin",
        "losartan", "candesartan", "telmisartan", "valsartan", "azithromycin", "ciprofloxacin",
        "levofloxacin", "cefixime", "ceftriaxone", "cefuroxime", "amoxil", "doxycycline", "clarithromycin",
        "cetirizine", "fexofenadine", "loratadine", "chlorpheniramine", "piriton", "salbutamol",
        "ventolin", "budesonide", "fluticasone", "montelukast", "prednisolone", "dexamethasone",
        "hydrocortisone", "aspirin", "clopidogrel", "amlodipine", "nifedipine", "diltiazem", "verapamil",
        "atenolol", "bisoprolol", "metoprolol", "carvedilol", "nebivolol", "enalapril", "lisinopril",
        "ramipril", "perindopril", "hydrochlorothiazide", "furosemide", "lasix", "spironolactone",
        "glimepiride", "gliclazide", "vildagliptin", "sitagliptin", "empagliflozin", "dapagliflozin",
        "insulin", "insulatard", "actrapid", "novorapid", "lantus", "diclofenac", "cataflam", "voltaren",
        "aceclofenac", "mefenamic", "ponstan", "tramadol", "codeine", "morphine", "gabapentin", "pregabalin",
        "domperidone", "motilium", "metoclopramide", "plasil", "ondansetron", "gravol", "hyoscine", "buscopan",
        "mebeverine", "lactulose", "bisacodyl", "dulcolax", "senna", "loperamide", "imodium", "ors", "zinc",
        "calcium", "vitamin", "neurobion", "folic", "iron", "ferrous", "antacid", "gaviscon", "eno", "chlorhexidine",
        "betadine", "mupirocin", "fusidic", "clotrimazole", "fluconazole", "acyclovir", "miconazole",
        "timolol", "systane", "otrivin", "xylometazoline", "strepsils", "difflam", "betamethasone",
        "allopurinol", "colchicine", "thyroxine", "diazepam", "lorazepam", "alprazolam", "clonazepam",
        "fluoxetine", "sertraline", "escitalopram", "quetiapine", "olanzapine", "risperidone", "valproate",
        "carbamazepine", "levetiracetam", "baclofen", "levodopa", "donepezil", "betahistine", "cinnarizine",
        "tranexamic", "heparin", "enoxaparin", "warfarin", "rivaroxaban", "apixaban", "digoxin", "amiodarone",
        "glyceryl", "nitroglycerin", "isosorbide", "tamsulosin", "sildenafil", "tadalafil"
    ));

    private static final Pattern REPEATED_CHARS = Pattern.compile("(?i)([a-z])\\1{3,}");
    private static final Pattern CONSONANT_CLUSTER = Pattern.compile("(?i)[bcdfghjklmnpqrstvwxz]{5,}");
    private static final Pattern LETTER_PATTERN = Pattern.compile(".*[a-zA-Z].*");

    public static class ValidationResult {
        private final boolean valid;
        private final String message;
        private final String field;

        public ValidationResult(boolean valid, String message, String field) {
            this.valid = valid;
            this.message = message;
            this.field = field;
        }

        public boolean isValid() { return valid; }
        public String getMessage() { return message; }
        public String getField() { return field; }
    }

    /**
     * Checks if a string exhibits characteristics of random typing, keyboard mashing, or gibberish.
     */
    public static boolean isGibberish(String text) {
        if (text == null) return true;
        String clean = text.trim().toLowerCase(Locale.ENGLISH);
        if (clean.length() < 2) return true;

        // 1. Must contain at least one letter
        if (!LETTER_PATTERN.matcher(clean).matches()) {
            return true;
        }

        // 2. Check for 4+ consecutive identical letters (e.g., "aaaaa", "zzzz")
        if (REPEATED_CHARS.matcher(clean).find()) {
            return true;
        }

        // 3. Check for keyboard mash patterns
        for (String pattern : MASH_PATTERNS) {
            if (clean.contains(pattern)) {
                return true;
            }
        }

        // 4. Check for unpronounceable consonant clusters (>= 5 consonants in a row)
        if (CONSONANT_CLUSTER.matcher(clean).find()) {
            boolean isKnownAcronym = false;
            for (String word : clean.split("\\W+")) {
                if (MEDICAL_TERMS.contains(word)) {
                    isKnownAcronym = true;
                    break;
                }
            }
            if (!isKnownAcronym) return true;
        }

        // 5. Check words without vowels (excluding numbers like 500mg, 100ml)
        String[] words = clean.split("[\\s,;:.|/\\-+()]+");
        for (String word : words) {
            String alphaOnly = word.replaceAll("[^a-z]", "");
            if (alphaOnly.length() >= 5 && !alphaOnly.matches(".*[aeiouy].*")) {
                if (!MEDICAL_TERMS.contains(alphaOnly)) {
                    return true;
                }
            }
        }

        return false;
    }

    /**
     * Validates Clinical Diagnosis field.
     */
    public static ValidationResult validateDiagnosis(String diagnosis) {
        if (diagnosis == null || diagnosis.trim().length() < 3) {
            return new ValidationResult(false, "Clinical diagnosis is required and must be at least 3 characters.", "diagnosis");
        }
        String clean = diagnosis.trim();
        if (isGibberish(clean)) {
            return new ValidationResult(false, "Diagnosis contains invalid or nonsensical text. Please enter a valid clinical condition.", "diagnosis");
        }
        return new ValidationResult(true, null, "diagnosis");
    }

    /**
     * Validates Prescribed Medicines field.
     */
    public static ValidationResult validateMedicines(String medicines) {
        if (medicines == null || medicines.trim().length() < 3) {
            return new ValidationResult(false, "Prescribed medicines are required and must be at least 3 characters.", "medicines");
        }
        String clean = medicines.trim();
        if (isGibberish(clean)) {
            return new ValidationResult(false, "Prescribed medicines contain invalid drug names or gibberish. Please enter valid medication.", "medicines");
        }

        // Check if at least one recognizable drug or dosage unit/form exists
        String lower = clean.toLowerCase(Locale.ENGLISH);
        boolean hasMedicalRef = false;
        for (String term : MEDICAL_TERMS) {
            if (lower.contains(term)) {
                hasMedicalRef = true;
                break;
            }
        }

        // Also accept structured patterns like "DrugName 500mg" or "Syrup 100ml" or standard words
        if (!hasMedicalRef && !lower.matches(".*\\d+\\s*(mg|g|mcg|ml|tab|caps|puff|drop|iu).*")) {
            // If the text is well-formed words with letters and spaces, allow if >= 4 chars without mash
            if (lower.length() < 4 || isGibberish(lower)) {
                return new ValidationResult(false, "Prescribed medicines must include recognizable drug names or dosage forms (e.g., Tablet, Syrup, Mg, Paracetamol).", "medicines");
            }
        }

        return new ValidationResult(true, null, "medicines");
    }

    /**
     * Validates Dosage & Duration field.
     */
    public static ValidationResult validateDosage(String dosage) {
        if (dosage == null || dosage.trim().isEmpty()) {
            return new ValidationResult(true, null, "dosage"); // optional
        }
        String clean = dosage.trim();
        if (clean.length() < 2 || isGibberish(clean)) {
            return new ValidationResult(false, "Dosage & Duration contains invalid instructions. Follow standard frequency (e.g., '1 Tablet TDS after meals for 5 Days').", "dosage");
        }
        return new ValidationResult(true, null, "dosage");
    }

    /**
     * Validates Special Instructions field.
     */
    public static ValidationResult validateInstructions(String instructions) {
        if (instructions == null || instructions.trim().isEmpty()) {
            return new ValidationResult(true, null, "instructions"); // optional
        }
        String clean = instructions.trim();
        if (clean.length() < 3 || isGibberish(clean)) {
            return new ValidationResult(false, "Special instructions contain inappropriate or gibberish text.", "instructions");
        }
        return new ValidationResult(true, null, "instructions");
    }

    /**
     * Performs full validation check on the entire clinical prescription payload.
     */
    public static ValidationResult validatePrescriptionPayload(String diagnosis, String medicines, String dosage, String instructions) {
        ValidationResult r1 = validateDiagnosis(diagnosis);
        if (!r1.isValid()) return r1;

        ValidationResult r2 = validateMedicines(medicines);
        if (!r2.isValid()) return r2;

        ValidationResult r3 = validateDosage(dosage);
        if (!r3.isValid()) return r3;

        ValidationResult r4 = validateInstructions(instructions);
        if (!r4.isValid()) return r4;

        return new ValidationResult(true, "Validation passed", null);
    }
}
