package com.example.demo;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.test.web.servlet.MockMvc;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;

@WebMvcTest(HelloController.class)
public class HelloControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @Test
    public void testHelloEndpoint_ReturnsOk() throws Exception {
        mockMvc.perform(get("/hello"))
               .andExpect(status().isOk());
    }

    @Test
    public void testHelloEndpoint_ReturnsText() throws Exception {
        mockMvc.perform(get("/hello"))
               .andExpect(status().isOk())
               .andExpect(content().contentType("application/json"));
    }

    @Test
    public void testHelloEndpoint_InvalidPath() throws Exception {
        mockMvc.perform(get("/invalid"))
               .andExpect(status().isNotFound());
    }
}
