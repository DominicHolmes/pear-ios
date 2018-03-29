
import Foundation

class PearUser: NSObject {
    
    var firstName: String!
    var lastName: String!
    let id: String!
    var username: String!
    
    //var phone: String?
    /*
    var birthdate: String?
    var startWeight: Int?
    var currentWeight: Int?
    var targetWeight: Int?
    var startBodyFat: Int?
    var currentBodyFat: Int?
    var oldHabit: String?
    var newHabit: String?
    var fitnessGoal: String?
    var teamId: String?*/
    
    // User's social profiles
    var profiles = [SocialProfile]()
    
    init(fname: String, lname: String, id: String, username: String) {
        self.firstName = fname
        self.lastName = lname
        self.id = id
        self.username = username
    }
    
    init(of dict: Dictionary<String, String>) {
        self.firstName = dict["name-first"]
        self.lastName = dict["name-last"]
        self.id = dict["id"]
        self.username = dict["username"]
    }
    
    func loadSocialProfiles(from dict: Dictionary<String, String>) {
        for eachProfile in dict {
            let newProfile = SocialProfile(withProvider provider: eachSocialProfile.key, 
                forProfileCalled profileName: dict[eachProfile.key])
            profiles.append(newProfile)
        }
        // sort profiles according to user preference
    }
}