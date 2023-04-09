package es.upm.dit.fuelcompense.controller;

import es.upm.dit.fuelcompense.mapper.UserToUserDTO;
import es.upm.dit.fuelcompense.persistance.entity.User;
import es.upm.dit.fuelcompense.service.UserService;
import es.upm.dit.fuelcompense.service.dto.UserDTO;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/users")
public class UserController {

    private final UserService userService;
    private final UserToUserDTO userMapperOut;

    public UserController(UserService userService, UserToUserDTO userMapperOut) {
        this.userService = userService;
        this.userMapperOut = userMapperOut;
    }

    @PostMapping(value = "/new")
    public User createUser(@RequestBody UserDTO userDTO) {
        return this.userService.createUser(userDTO);
    }

    @PostMapping(value = "/follow/{followedUserName}")
    public List<String> follow(@RequestBody String followerUserName, @PathVariable("followedUserName") String followedUserName) {
        return this.userService.follow(followerUserName, followedUserName);
    }

    @GetMapping(value = "/following/{followerUserName}")
    public List<String> findAllFollowing(@PathVariable("followerUserName") String followerUserName) {
        return this.userService.findAllFollowing(followerUserName);
    }

    @GetMapping(value = "/followers/{followedUserName}")
    public List<String> findAllFollowers(@PathVariable("followedUserName") String followedUserName) {
        return this.userService.findAllFollowers(followedUserName);
    }

    @GetMapping
    public List<UserDTO> findAll() {
        return userMapperOut.listMap(this.userService.findAll());
    }

    @GetMapping(value = "/{userName}")
    public UserDTO findUser(@PathVariable("userName") String userName){
        return userMapperOut.map(this.userService.findUserByUserName(userName));
    }

}
