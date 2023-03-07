package es.upm.dit.fuelcompense.controller;

import es.upm.dit.fuelcompense.mapper.UserToUserOutDTO;
import es.upm.dit.fuelcompense.persistance.entity.User;
import es.upm.dit.fuelcompense.service.UserService;
import es.upm.dit.fuelcompense.service.dto.UserInDTO;
import es.upm.dit.fuelcompense.service.dto.UserOutDTO;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/users")
public class UserController {

    private final UserService userService;
    private final UserToUserOutDTO userMapperOut;

    public UserController(UserService userService, UserToUserOutDTO userMapperOut) {
        this.userService = userService;
        this.userMapperOut = userMapperOut;
    }

    @PostMapping(value = "/new")
    public User createUser(@RequestBody UserInDTO userInDTO) {
        return this.userService.createUser(userInDTO);
    }

    @PostMapping(value = "/follow/{followedUserName}")
    public List<String> follow(@RequestBody String followerUserName, @PathVariable("followedUserName") String followedUserName) {
        return this.userService.follow(followerUserName, followedUserName);
    }

    @GetMapping(value = "/following/{followerUserName}")
    public List<String> findAllFollowing(@PathVariable("followerUserName") String followerUserName) {
        return this.userService.findAllFollowing(followerUserName);
    }

    @GetMapping
    public List<UserOutDTO> findAll() {
        return userMapperOut.listMap(this.userService.findAll());
    }

    @GetMapping(value = "/{userName}")
    public UserOutDTO findUser(@PathVariable("userName") String userName){
        return userMapperOut.map(this.userService.findUserByUserName(userName));
    }

}
