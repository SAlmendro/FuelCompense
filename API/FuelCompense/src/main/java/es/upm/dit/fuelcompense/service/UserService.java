package es.upm.dit.fuelcompense.service;

import es.upm.dit.fuelcompense.mapper.UserDTOtoUser;
import es.upm.dit.fuelcompense.persistance.entity.User;
import es.upm.dit.fuelcompense.persistance.repository.UserRepository;
import es.upm.dit.fuelcompense.service.dto.UserDTO;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final UserDTOtoUser userMapperIn;

    public UserService(UserRepository userRepository, UserDTOtoUser userMapperIn) {
        this.userRepository = userRepository;
        this.userMapperIn = userMapperIn;
    }

    public User createUser(UserDTO userDTO) {
        User user = userMapperIn.map(userDTO);
        return this.userRepository.save(user);
    }

    public List<User> findAll() {
        return this.userRepository.findAll();
    }

    public User findUserByUserName(String userName) {
        return this.userRepository.findUserByUserName(userName);
    }

    public List<String> follow(String followerUserName, String followedUserName) {
        User follower = userRepository.findUserByUserName(followerUserName);
        follower.getFollowing().add(userRepository.findUserByUserName(followedUserName));
        this.userRepository.saveAndFlush(follower);
        List<String> following = new ArrayList<String>();
        for (User u : follower.getFollowing()) {
            following.add(u.getUserName());
        }
        return following;
    }

    public List<String> findAllFollowing(String followerUserName) {
        User follower = userRepository.findUserByUserName(followerUserName);
        List<String> following = new ArrayList<String>();
        for (User u : follower.getFollowing()) {
            following.add(u.getUserName());
        }
        return following;
    }

    public List<String> findAllFollowers(String followedUserName) {
        User followed = userRepository.findUserByUserName(followedUserName);
        Set<User> followers = userRepository.findAllByFollowingContains(followed);
        List<String> followersUserNames = new ArrayList<String>();
        for (User u : followers) {
            followersUserNames.add(u.getUserName());
        }
        return followersUserNames;
    }
}
