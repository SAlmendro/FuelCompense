package es.upm.dit.fuelcompense.controller;

import es.upm.dit.fuelcompense.mapper.UserToUserDTO;
import es.upm.dit.fuelcompense.persistance.entity.User;
import es.upm.dit.fuelcompense.service.UserService;
import es.upm.dit.fuelcompense.service.dto.UserDTO;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

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
        Logger.getAnonymousLogger().log(Level.WARNING, "Se ha solicitado crear usuario con el username: " + userDTO.getUserName());
        return this.userService.createUser(userDTO);
    }

    @PostMapping(value = "/follow/{followedUserName}")
    public List<String> follow(@RequestBody String followerUserName, @PathVariable("followedUserName") String followedUserName) {
        Logger.getAnonymousLogger().log(Level.WARNING, followerUserName + " ha solicitado seguir al usuario " + followedUserName);
        return this.userService.follow(followerUserName, followedUserName);
    }

    @GetMapping(value = "/following/{followerUserName}")
    public List<String> findAllFollowing(@PathVariable("followerUserName") String followerUserName) {
        Logger.getAnonymousLogger().log(Level.WARNING, "Se ha solicitado la lista de seguidos para el usuario " + followerUserName);
        return this.userService.findAllFollowing(followerUserName);
    }

    @GetMapping(value = "/followers/{followedUserName}")
    public List<String> findAllFollowers(@PathVariable("followedUserName") String followedUserName) {
        Logger.getAnonymousLogger().log(Level.WARNING, "Se ha solicitado la lista de seguidores para el usuario " + followedUserName);
        return this.userService.findAllFollowers(followedUserName);
    }

    @GetMapping(value = "/{userName}")
    public UserDTO findUser(@PathVariable("userName") String userName){
        Logger.getAnonymousLogger().log(Level.WARNING, "Se ha solicitado el login del usuario " + userName);
        return userMapperOut.map(this.userService.findUserByUserName(userName));
    }

    @GetMapping(value = "/search/{keyword}")
    public List<String> searchUsers(@PathVariable("keyword") String keyword) {
        Logger.getAnonymousLogger().log(Level.WARNING, "Se han buscado todos los usuarios que contengan " + keyword);
        return this.userService.findAllUsersByKeyword(keyword);
    }

    @DeleteMapping("/unfollow/{followedUserName}")
    public Boolean unfollow(@RequestBody String followerUserName, @PathVariable("followedUserName") String followedUserName) {
        Logger.getAnonymousLogger().log(Level.WARNING, "Se ha solicitado que el usuario " + followerUserName + " deje de seguir al usuario " + followedUserName);
        return this.userService.unfollow(followerUserName, followedUserName);
    }

    @DeleteMapping("/{userName}")
    public Boolean deleteUser(@PathVariable String userName) {
        Logger.getAnonymousLogger().log(Level.WARNING, "Se ha solicitado eliminar el usuario " + userName);
        Long userId = userService.findUserByUserName(userName).getId();
        return userService.deleteUserById(userId);
    }

}
