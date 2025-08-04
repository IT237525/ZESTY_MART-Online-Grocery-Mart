package model;

public class Category {
    private int categoryId;
    private String description;
    private String image;

    // Constructors
    public Category() {}

    public Category(int categoryId, String description, String image) {
        this.categoryId = categoryId;
        this.description = description;
        this.image = image;
    }

    // Getters and Setters
    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }
}
