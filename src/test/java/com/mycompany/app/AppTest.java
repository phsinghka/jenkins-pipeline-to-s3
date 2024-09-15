package com.mycompany.app;

import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class AppTest {

    @Test
    public void testGreet() {
        App app = new App();
        String result = app.greet("JUnit");
        assertEquals("Hello, JUnit", result);
    }
}

