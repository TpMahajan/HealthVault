// index.js - HealthVault Backend Ready Version

import express from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";
import cors from "cors";
import authRoutes from "./routes/authRoutes.js";
import jwt from "jsonwebtoken";
import multer from "multer";
import { ObjectId, GridFSBucket } from "mongodb";

dotenv.config({ path: "./db.env" });

const app = express();
app.use(cors());
app.use(express.json());

// Multer in-memory storage for file uploads
const upload = multer({ storage: multer.memoryStorage() });

// Routes
app.use("/api/auth", authRoutes);

// Root route
app.get('/', (req, res) => {
  res.send('HealthVault API running...');
});

const PORT = process.env.PORT || 5000;

// MongoDB connection with Mongoose
let bucket;
mongoose.connect(process.env.MONGO_URI)
  .then(async () => {
    console.log("MongoDB connected (Mongoose)");

    // Native MongoDB client for GridFS
    const client = mongoose.connection.getClient();
    const db = client.db(); // default DB from URI
    bucket = new GridFSBucket(db, { bucketName: 'uploads' });

    // Start server
    app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
  })
  .catch(err => console.log('Mongo connection error:', err));

// Helper for documents collection
const Documents = () => mongoose.connection.db.collection('documents');

// -------------------- Upload Route --------------------
app.post('/api/docs/upload', upload.single('file'), async (req, res) => {
  try {
    if (!req.file) return res.status(400).json({ msg: 'No file uploaded' });

    const { originalname, mimetype, buffer } = req.file;

    const uploadStream = bucket.openUploadStream(originalname, { contentType: mimetype });
    uploadStream.end(buffer);

    uploadStream.on('finish', async (file) => {
      const doc = {
        fileId: file._id,
        title: originalname,
        mimeType: mimetype,
        createdAt: new Date()
      };
      const { insertedId } = await Documents().insertOne(doc);
      res.json({ ok: true, docId: insertedId.toString() });
    });

    uploadStream.on('error', (err) => res.status(500).json({ msg: 'Upload error', err: String(err) }));

  } catch (err) {
    res.status(500).json({ msg: 'Server error', err: String(err) });
  }
});

// -------------------- Share Token Route --------------------
app.post('/api/docs/:docId/share', async (req, res) => {
  try {
    const doc = await Documents().findOne({ _id: new ObjectId(req.params.docId) });
    if (!doc) return res.status(404).json({ msg: 'Document not found' });

    const token = jwt.sign(
      { docId: doc._id.toString(), scope: 'share' },
      process.env.JWT_SECRET,
      { expiresIn: '10m' } // QR token valid 10 minutes
    );

    res.json({ token });
  } catch (err) {
    res.status(500).json({ msg: 'Server error', err: String(err) });
  }
});

// -------------------- Access Document Route --------------------
app.get('/api/docs/access', async (req, res) => {
  try {
    const { token } = req.query;
    if (!token) return res.status(400).json({ msg: 'Token required' });

    const payload = jwt.verify(token, process.env.JWT_SECRET);
    if (payload.scope !== 'share') return res.status(403).json({ msg: 'Invalid scope' });

    const doc = await Documents().findOne({ _id: new ObjectId(payload.docId) });
    if (!doc) return res.status(404).json({ msg: 'Document not found' });

    res.setHeader('Content-Type', doc.mimeType || 'application/octet-stream');
    res.setHeader('Content-Disposition', 'inline');
    bucket.openDownloadStream(doc.fileId).pipe(res).on('error', () => res.status(500).end());

  } catch {
    res.status(401).json({ msg: 'Invalid or expired token' });
  }
});
