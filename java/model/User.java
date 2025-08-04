package model;
import java.time.LocalDateTime;

public class User {
    private int userId;
    private String firstName;
    private String lastName;
    private String gender;
    private String phone;
    private String address;
    private String password;
    private byte[] profileImage;
    private String profileImageType;

    private transient String profileImageBase64;
    
    public User() {
    }

    public User(int userId, String firstName, String lastName, String gender, String phone,
                String address, String password, byte[] profileImage, String profileImageType) {
        this.userId = userId;
        this.firstName = firstName;
        this.lastName = lastName;
        this.gender = gender;
        this.phone = phone;
        this.address = address;
        this.password = password;
        this.profileImage = profileImage;
        this.profileImageType = profileImageType;
        
        
    }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFirstName() { return firstName; }
    public void setFirstName(String firstName) { this.firstName = firstName; }

    public String getLastName() { return lastName; }
    public void setLastName(String lastName) { this.lastName = lastName; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public byte[] getProfileImage() { return profileImage; }
    public void setProfileImage(byte[] profileImage) { this.profileImage = profileImage; }

    public String getProfileImageType() { return profileImageType; }
    public void setProfileImageType(String profileImageType) { this.profileImageType = profileImageType; }
    	
    
    public String getProfileImageBase64() {
        if (this.profileImage != null && this.profileImageType != null) {
            return "data:" + this.profileImageType + ";base64," + 
                   java.util.Base64.getEncoder().encodeToString(this.profileImage);
        }
        return null;
    }
}
