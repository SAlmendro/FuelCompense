package es.upm.dit.fuelcompense.service;

import es.upm.dit.fuelcompense.mapper.UserDTOtoUser;
import es.upm.dit.fuelcompense.persistance.entity.User;
import es.upm.dit.fuelcompense.persistance.repository.UserRepository;
import es.upm.dit.fuelcompense.service.dto.UserDTO;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class UserService {

    private final UserRepository repository;
    private final UserDTOtoUser mapperIn;

    public UserService(UserRepository repository, UserDTOtoUser mapperIn) {
        this.repository = repository;
        this.mapperIn = mapperIn;
    }

    public User createUser(UserDTO userDTO) {
        User user = mapperIn.map(userDTO);
        return this.repository.save(user);
    }

    public List<User> findAll() {
        return this.repository.findAll();
    }

    public User findUserByUserName(String userName) {
        return this.repository.findUserByUserName(userName);
    }

    public List<String> follow(String followerUserName, String followedUserName) {
        User follower = repository.findUserByUserName(followerUserName);
        follower.getFollowing().add(repository.findUserByUserName(followedUserName));
        //this.repository.setUserFollowing(follower.getFollowing(), followerUserName);
        this.repository.saveAndFlush(follower);
        List<String> following = new ArrayList<String>();
        for (User u : follower.getFollowing()) {
            following.add(u.getUserName());
        }
        return following;
    }

    public List<String> findAllFollowing(String followerUserName) {
        User follower = repository.findUserByUserName(followerUserName);
        List<String> following = new ArrayList<String>();
        for (User u : follower.getFollowing()) {
            following.add(u.getUserName());
        }
        return following;
    }
}
