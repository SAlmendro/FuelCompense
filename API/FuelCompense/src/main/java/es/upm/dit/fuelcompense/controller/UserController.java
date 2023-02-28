package es.upm.dit.fuelcompense.controller;

import es.upm.dit.fuelcompense.persistance.entity.User;
import es.upm.dit.fuelcompense.service.UserService;
import es.upm.dit.fuelcompense.service.dto.UserInDTO;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    @PostMapping
    public User createUser(@RequestBody UserInDTO userInDTO) {
        return this.userService.createUser(userInDTO);
    }

    @GetMapping
    public List<User> findAll() {
        return this.userService.findAll();
    }

}
