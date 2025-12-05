package com.lab5;

import io.qameta.allure.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

@Epic("Demo Application Tests")
@Feature("Basic Operations")
public class AppTest {

    private App app;

    @BeforeEach
    void setUp() {
        app = new App();
    }

    @Test
    @Story("Greeting Message")
    @DisplayName("Test getMessage")
    @Severity(SeverityLevel.NORMAL)
    void testGetMessage() {
        String result = app.getMessage();
        assertNotNull(result);
        assertTrue(result.contains("Hello"));
    }

    @Test
    @Story("Addition")
    @DisplayName("Test add positive numbers")
    @Severity(SeverityLevel.CRITICAL)
    void testAddPositiveNumbers() {
        assertEquals(8, app.add(5, 3));
    }

    @Test
    @Story("Addition")
    @DisplayName("Test add negative numbers")
    @Severity(SeverityLevel.NORMAL)
    void testAddNegativeNumbers() {
        assertEquals(-2, app.add(-5, 3));
        assertEquals(-8, app.add(-5, -3));
    }

    @Test
    @Story("Addition")
    @DisplayName("Test add with zero")
    @Severity(SeverityLevel.MINOR)
    void testAddWithZero() {
        assertEquals(5, app.add(5, 0));
        assertEquals(0, app.add(0, 0));
    }

    @Test
    @Story("Subtraction")
    @DisplayName("Test subtract")
    @Severity(SeverityLevel.CRITICAL)
    void testSubtract() {
        assertEquals(2, app.subtract(5, 3));
        assertEquals(-2, app.subtract(3, 5));
    }

    @Test
    @Story("Multiplication")
    @DisplayName("Test multiply")
    @Severity(SeverityLevel.CRITICAL)
    void testMultiply() {
        assertEquals(15, app.multiply(5, 3));
        assertEquals(-15, app.multiply(-5, 3));
        assertEquals(0, app.multiply(5, 0));
    }

    @Test
    @Story("Division")
    @DisplayName("Test divide")
    @Severity(SeverityLevel.CRITICAL)
    void testDivide() {
        assertEquals(2, app.divide(6, 3));
        assertEquals(-2, app.divide(-6, 3));
    }

    @Test
    @Story("Division")
    @DisplayName("Test divide by zero")
    @Severity(SeverityLevel.BLOCKER)
    void testDivideByZero() {
        assertThrows(ArithmeticException.class, () -> app.divide(5, 0));
    }

    @Test
    @Story("Factorial")
    @DisplayName("Test factorial")
    @Severity(SeverityLevel.NORMAL)
    void testFactorial() {
        assertEquals(1, app.factorial(0));
        assertEquals(1, app.factorial(1));
        assertEquals(120, app.factorial(5));
        assertEquals(3628800, app.factorial(10));
    }

    @Test
    @Story("Factorial")
    @DisplayName("Test factorial negative")
    @Severity(SeverityLevel.NORMAL)
    void testFactorialNegative() {
        assertThrows(IllegalArgumentException.class, () -> app.factorial(-1));
    }

    @Test
    @Story("Palindrome")
    @DisplayName("Test palindrome")
    @Severity(SeverityLevel.NORMAL)
    void testIsPalindrome() {
        assertTrue(app.isPalindrome("radar"));
        assertTrue(app.isPalindrome("A man a plan a canal Panama"));
        assertFalse(app.isPalindrome("hello"));
    }

    @Test
    @Story("Palindrome")
    @DisplayName("Test palindrome null")
    @Severity(SeverityLevel.MINOR)
    void testIsPalindromeNull() {
        assertFalse(app.isPalindrome(null));
    }

    @Test
    @Story("Min/Max")
    @DisplayName("Test max")
    @Severity(SeverityLevel.NORMAL)
    void testMax() {
        assertEquals(5, app.max(5, 3));
        assertEquals(5, app.max(3, 5));
        assertEquals(5, app.max(5, 5));
    }

    @Test
    @Story("Min/Max")
    @DisplayName("Test min")
    @Severity(SeverityLevel.NORMAL)
    void testMin() {
        assertEquals(3, app.min(5, 3));
        assertEquals(3, app.min(3, 5));
        assertEquals(5, app.min(5, 5));
    }
}
