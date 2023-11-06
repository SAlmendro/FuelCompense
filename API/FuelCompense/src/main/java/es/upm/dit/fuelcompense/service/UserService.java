package es.upm.dit.fuelcompense.service;

import es.upm.dit.fuelcompense.mapper.UserDTOtoUser;
import es.upm.dit.fuelcompense.persistance.entity.Status;
import es.upm.dit.fuelcompense.persistance.entity.User;
import es.upm.dit.fuelcompense.persistance.repository.StatusRepository;
import es.upm.dit.fuelcompense.persistance.repository.UserRepository;
import es.upm.dit.fuelcompense.service.dto.UserDTO;
import org.springframework.stereotype.Service;

import java.util.*;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final UserDTOtoUser userMapperIn;
    private final StatusRepository statusRepository;

    public UserService(UserRepository userRepository, UserDTOtoUser userMapperIn,
                       StatusRepository statusRepository) {
        this.userRepository = userRepository;
        this.userMapperIn = userMapperIn;
        this.statusRepository = statusRepository;
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
    public User findUserByUserNameWithStatuses(String userName) {
        User user = this.findUserByUserName(userName);
        return this.userRepository.findUserByIdWithStatuses(user.getId());
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

    public Boolean unfollow(String followerUserName, String followedUserName) {
        User follower = userRepository.findUserByUserName(followerUserName);
        follower.getFollowing().remove(userRepository.findUserByUserName(followedUserName));
        this.userRepository.saveAndFlush(follower);
        return !userRepository.findUserByUserName(followerUserName).getFollowing().contains(userRepository.findUserByUserName(followedUserName));
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

    public List<String> findAllUsersByKeyword(String keyword) {
        List<User> users = userRepository.findAllByUserNameContainingIgnoreCase(keyword);
        List<String> userNames = new ArrayList<String>();
        for (User u : users) {
            userNames.add(u.getUserName());
        }
        Collections.sort(userNames);
        return userNames;
    }

    public boolean deleteUserById(Long userId) {
        Optional<User> userOpt = userRepository.findByIdWithFavorites(userId);
        if (!userOpt.isPresent()) {
            return false;
        }
        User user = userOpt.get();
        user.setFollowing(null);
        userRepository.saveAndFlush(user);
        for (Status status : user.getFavorites()) {
            if (status.getFavorites().contains(user)) {
                status.getFavorites().remove(user);
                statusRepository.saveAndFlush(status);
            }
        }
        List<String> followers = findAllFollowers(user.getUserName());
        for (String follower : followers) {
            if (!unfollow(follower, user.getUserName())) {
                return false;
            }
        }
        userRepository.delete(user);
        return true;
    }
}
