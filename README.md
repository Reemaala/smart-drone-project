
# Smart Drone Project

Smart Drone for Hajj and Umrah Safety Monitoring

This project integrates a Flutter mobile application with an AI-based hazard detection model to enhance safety during the Hajj and Umrah seasons.

---

## Team Members

- Reem Alamoudi
- Reham Alamoudi
- Nareman Turkistani

Effat University – Cybersecurity Majors  
Internship at Pixiliza – Digital Technologies

---

## Project Structure

```
smart-drone-project/
├── flutter_app/                  # Flutter-based mobile app
├── hazerd_model_cleaned.ipynb   # Cleaned AI model notebook for hazard detection
```

---

## Flutter App (`flutter_app/`)

The mobile app provides:
- Real-time camera preview
- Image classification through an API (hazard detection)
- Alerts for risks like crowding, fire, or fainting
- Interface designed for authorized security teams in the Haram area

---

## AI Model (`hazerd_model_cleaned.ipynb`)

The Jupyter notebook contains:
- Image classification logic
- Categories: crowd_dense, crowd_medium, crowd_low, fire, fainting
- Preprocessing, prediction, and API communication

---

## How to Use

1. Run the notebook in Colab or Jupyter
2. Deploy the Flask API backend
3. Launch the Flutter app and connect it to the API

---

## License

This project is licensed for academic and non-commercial use.
