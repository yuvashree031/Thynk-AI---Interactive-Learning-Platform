package com.ailearning.controller;

import com.ailearning.model.User;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class SettingsController {

    @GetMapping("/settings")
    public String showSettings(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/login";
        }

        model.addAttribute("user", user);
        model.addAttribute("theme", session.getAttribute("theme"));

        return "settings";
    }

    @PostMapping("/settings")
    public String updateTheme(@RequestParam("theme") String theme, HttpSession session, HttpServletResponse response) {
        if ("dark".equalsIgnoreCase(theme) || "light".equalsIgnoreCase(theme)) {
            session.setAttribute("theme", theme.toLowerCase());
            Cookie themeCookie = new Cookie("theme", theme.toLowerCase());
            themeCookie.setMaxAge(60 * 60 * 24 * 30);
            themeCookie.setPath("/");
            response.addCookie(themeCookie);
        }
        return "redirect:/settings";
    }
}