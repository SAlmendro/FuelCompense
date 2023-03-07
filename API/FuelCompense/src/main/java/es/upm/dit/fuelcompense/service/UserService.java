package es.upm.dit.fuelcompense.service;

import es.upm.dit.fuelcompense.mapper.UserInDTOtoUser;
import es.upm.dit.fuelcompense.persistance.entity.User;
import es.upm.dit.fuelcompense.persistance.repository.UserRepository;
import es.upm.dit.fuelcompense.service.dto.UserInDTO;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@Service
public class UserService {

    private final UserRepository repository;
    private final UserInDTOtoUser mapper;

    public UserService(UserRepository repository, UserInDTOtoUser mapper) {
        this.repository = repository;
        this.mapper = mapper;
    }

    public User createUser(UserInDTO userInDTO) {
        User user = mapper.map(userInDTO);
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
