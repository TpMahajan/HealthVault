import express from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";
import cors from "cors";
import authRoutes from "./routes/authRoutes.js";

dotenv.config({ path: "./db.env" });

const app = express();
app.use(cors());
app.use(express.json());

// Routes
app.use("/api/auth", authRoutes);

// MongoDB connection
// MongoDB connection
mongoose.connect(process.env.MONGO_URI)
  .then(() => {
    console.log("MongoDB connected");
    app.listen(5000, () => console.log("Server running on port 5000"));
  })
  .catch(err => console.log(err));
