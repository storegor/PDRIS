package com.lab5;

public class App {

    public static void main(String[] args) {
        App app = new App();
        System.out.println("Demo Application Started");
        System.out.println("Message: " + app.getMessage());
        System.out.println("Sum of 5 and 3: " + app.add(5, 3));
        System.out.println("Factorial of 5: " + app.factorial(5));
    }

    public String getMessage() {
        return "Hello from Jenkins CI/CD Pipeline";
    }

    public int add(int a, int b) {
        return a + b;
    }

    public int subtract(int a, int b) {
        return a - b;
    }

    public int multiply(int a, int b) {
        return a * b;
    }

    public int divide(int a, int b) {
        if (b == 0) {
            throw new ArithmeticException("Division by zero");
        }
        return a / b;
    }

    public long factorial(int n) {
        if (n < 0) {
            throw new IllegalArgumentException("Negative number");
        }
        if (n <= 1) {
            return 1;
        }
        return n * factorial(n - 1);
    }

    public boolean isPalindrome(String str) {
        if (str == null) {
            return false;
        }
        String cleaned = str.toLowerCase().replaceAll("[^a-zA-Z0-9]", "");
        String reversed = new StringBuilder(cleaned).reverse().toString();
        return cleaned.equals(reversed);
    }

    public int max(int a, int b) {
        return a > b ? a : b;
    }

    public int min(int a, int b) {
        return a < b ? a : b;
    }
}
