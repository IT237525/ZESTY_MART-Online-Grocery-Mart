package model;

public class Product {
    private int id;
    private String name;
    private int categoryId;
    private double price;
    private int stock;
    private String description;
    private String image;

    // Constructor
    public Product(String name, int categoryId, double price, int stock, String description, String image) {
        this.name = name;
        this.categoryId = categoryId;
        this.price = price;
        this.stock = stock;
        this.description = description;
        this.image = image;
    }
    

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public int getStock() { return stock; }
    public void setStock(int stock) { this.stock = stock; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getImage() { return image; }
    public void setImage(String image) { this.image = image; }
}
