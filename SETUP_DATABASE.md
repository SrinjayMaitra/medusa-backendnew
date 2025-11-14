# 🗄️ Database Setup Guide

**Quick guide to set up PostgreSQL for your Medusa backend.**

---

## 🚨 Current Issue

You're getting:
```
Pg connection failed to connect to the database. Retrying...
KnexTimeoutError
```

**This means:** PostgreSQL is not configured or not running.

---

## ✅ Quick Fix Options

### Option 1: Use Railway PostgreSQL (Easiest - Recommended)

**No local PostgreSQL needed!**

1. **Go to Railway:** https://railway.app
2. **Create new project**
3. **Add PostgreSQL service**
4. **Copy the `DATABASE_URL`** from Railway
5. **Paste into your `.env` file:**

```env
DATABASE_URL=postgresql://postgres:xxxxx@xxxxx.railway.app:5432/railway
```

**That's it!** No local setup needed.

---

### Option 2: Install PostgreSQL Locally

#### Step 1: Install PostgreSQL

1. **Download:** https://www.postgresql.org/download/windows/
2. **Run installer**
3. **Remember the password** you set for `postgres` user
4. **Complete installation**

#### Step 2: Create Database

```powershell
# Open PowerShell and run:
psql -U postgres

# Then in psql, run:
CREATE DATABASE medusa_db;

# Exit psql:
\q
```

#### Step 3: Update .env File

Open `.env` and update:

```env
# Replace 'password' with the password you set during installation
DATABASE_URL=postgresql://postgres:YOUR_PASSWORD@localhost:5432/medusa_db
```

#### Step 4: Start PostgreSQL Service

```powershell
# Check if running
Get-Service -Name postgresql*

# If not running, start it (replace XX with your version):
Start-Service -Name postgresql-x64-XX
```

---

## 🧪 Test Your Setup

### Test 1: Check PostgreSQL is Running

```powershell
Get-Service -Name postgresql*
```

**Should show:** Status = "Running"

### Test 2: Test Connection

```powershell
# Replace 'password' with your actual password
psql -U postgres -h localhost -p 5432 -d medusa_db
```

**If it connects:** ✅ Your setup is correct!
**If it fails:** Check password and database name.

### Test 3: Start Medusa

```powershell
cd medusabackend/medusa-backendnew
npm run dev
```

**Should see:** No database connection errors!

---

## 📋 Complete .env File

Your `.env` file should look like this:

```env
# Database (UPDATE PASSWORD!)
DATABASE_URL=postgresql://postgres:YOUR_PASSWORD@localhost:5432/medusa_db

# Redis (optional)
# REDIS_URL=redis://localhost:6379

# Security Secrets
JWT_SECRET=supersecret
COOKIE_SECRET=supersecret

# CORS
STORE_CORS=http://localhost:8000,http://localhost:3000
ADMIN_CORS=http://localhost:5173,http://localhost:9000
AUTH_CORS=http://localhost:5173,http://localhost:9000

# Admin User
ADMIN_EMAIL=admin@medusa.com
ADMIN_PASSWORD=test123

# Trust Proxy
TRUST_PROXY=false

# Node Environment
NODE_ENV=development
```

**⚠️ Important:** Replace `YOUR_PASSWORD` with your actual PostgreSQL password!

---

## 🔍 Troubleshooting

### Issue: "password authentication failed"

**Fix:** Update password in `.env` file to match your PostgreSQL password.

### Issue: "database does not exist"

**Fix:** Create the database:
```powershell
psql -U postgres
CREATE DATABASE medusa_db;
\q
```

### Issue: "connection refused"

**Fix:** Start PostgreSQL service:
```powershell
Start-Service -Name postgresql-x64-XX
```

### Issue: Can't find psql command

**Fix:** Add PostgreSQL to PATH, or use full path:
```powershell
"C:\Program Files\PostgreSQL\XX\bin\psql.exe" -U postgres
```

---

## 🎯 Recommendation

**For quick testing:** Use Railway PostgreSQL (Option 1)
- No local installation needed
- Works immediately
- Same as production environment

**For local development:** Install PostgreSQL locally (Option 2)
- Faster (no network latency)
- Works offline
- More control

---

**After setup, restart your dev server!** 🚀

