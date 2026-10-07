package com.echannel.util;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class ClinicalValidatorTest {

    @Test
    public void testValidClinicalPayload() {
        ClinicalValidator.ValidationResult result = ClinicalValidator.validatePrescriptionPayload(
            "Acute Bronchitis",
            "Amoxicillin 500mg, Paracetamol 500mg",
            "1 Tablet TDS after meals for 5 Days",
            "Drink warm water, avoid cold drinks, review in 1 week"
        );
        assertTrue(result.isValid(), "Valid clinical prescription should pass validation");
    }

    @Test
    public void testGibberishDiagnosisRejected() {
        ClinicalValidator.ValidationResult result1 = ClinicalValidator.validateDiagnosis("asdfgh");
        assertFalse(result1.isValid(), "Keyboard mash diagnosis should be rejected");

        ClinicalValidator.ValidationResult result2 = ClinicalValidator.validateDiagnosis("123456");
        assertFalse(result2.isValid(), "Pure number diagnosis should be rejected");

        ClinicalValidator.ValidationResult result3 = ClinicalValidator.validateDiagnosis("aaaaa");
        assertFalse(result3.isValid(), "Repeated letter diagnosis should be rejected");
    }

    @Test
    public void testGibberishMedicinesRejected() {
        ClinicalValidator.ValidationResult result1 = ClinicalValidator.validateMedicines("qwertyuiop");
        assertFalse(result1.isValid(), "Keyboard mash medicines should be rejected");

        ClinicalValidator.ValidationResult result2 = ClinicalValidator.validateMedicines("zzzzzzz");
        assertFalse(result2.isValid(), "Invalid character string medicines should be rejected");
    }

    @Test
    public void testValidMedicinesAccepted() {
        ClinicalValidator.ValidationResult result1 = ClinicalValidator.validateMedicines("Paracetamol 500mg");
        assertTrue(result1.isValid(), "Standard medicine name and strength should pass");

        ClinicalValidator.ValidationResult result2 = ClinicalValidator.validateMedicines("Cough Syrup 100ml");
        assertTrue(result2.isValid(), "Syrup dosage form should pass");
    }

    @Test
    public void testGibberishDosageRejected() {
        ClinicalValidator.ValidationResult result = ClinicalValidator.validateDosage("asdfghjkl");
        assertFalse(result.isValid(), "Gibberish dosage should be rejected");
    }

    @Test
    public void testValidDosageAccepted() {
        ClinicalValidator.ValidationResult result1 = ClinicalValidator.validateDosage("1 Tablet TDS for 5 Days");
        assertTrue(result1.isValid(), "Standard dosage frequency and duration should pass");

        ClinicalValidator.ValidationResult result2 = ClinicalValidator.validateDosage(null);
        assertTrue(result2.isValid(), "Optional null dosage should pass");
    }

    @Test
    public void testInstructionsValidation() {
        ClinicalValidator.ValidationResult result1 = ClinicalValidator.validateInstructions("Take after meals with warm water");
        assertTrue(result1.isValid(), "Valid clinical instructions should pass");

        ClinicalValidator.ValidationResult result2 = ClinicalValidator.validateInstructions("asdfgh");
        assertFalse(result2.isValid(), "Gibberish instructions should be rejected");

        ClinicalValidator.ValidationResult result3 = ClinicalValidator.validateInstructions("");
        assertTrue(result3.isValid(), "Blank optional instructions should pass");
    }
}
