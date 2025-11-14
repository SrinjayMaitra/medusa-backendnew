# 🔧 Database Connection Fix

**Fixing PostgreSQL connection timeout errors.**

---

## 🚨 Error You're Seeing

```
warn:    Pg connection failed to connect to the database. Retrying...
{"name":"KnexTimeoutError","sql":"SELECT 1"}
```

**This means:** Medusa can't connect to your PostgreSQL database.

---

## ✅ Solution 1: Check Your .env File

### Your `.env` file should have:

```env
DATABASE_URL=postgresql://postgres:password@localhost:5432/medusa_db
```

**Common issues:**

1. **Wrong format** - Must be: `postgresql://user:password@host:port/database`
2. **Wrong password** - Must match your PostgreSQL password
3. **Wrong database name** - Database must exist
4. **Wrong port** - Default is `5432`

---

## ✅ Solution 2: Check PostgreSQL is Running

### Windows (PowerShell):

```powershell
# Check if PostgreSQL service is running
Get-Service -Name postgresql*

# If not running, start it:
Start-Service -Name postgresql-x64-XX  # Replace XX with your version
```

### Or check manually:

1. **Open Services** (Win + R → `services.msc`)
2. **Find:** `postgresql-x64-XX` or `PostgreSQL`
3. **Check status:** Should be "Running"
4. **If stopped:** Right-click → Start

---

## ✅ Solution 3: Create the Database

If the database doesn't exist, create it:

### Option 1: Using psql (Command Line)

```powershell
# Connect to PostgreSQL
psql -U postgres

# Create database
CREATE DATABASE medusa_db;

# Exit
\q
```

### Option 2: Using pgAdmin

1. **Open pgAdmin**
2. **Connect to PostgreSQL server**
3. **Right-click "Databases"** → **Create** → **Database**
4. **Name:** `medusa_db`
5. **Click "Save"**

---

## ✅ Solution 4: Test Connection Manually

Test if you can connect:

```powershell
# Test connection (replace with your password)
psql -U postgres -h localhost -p 5432 -d medusa_db

# If it asks for password and connects, your DATABASE_URL is correct
# If it fails, check:
# - Password is correct
# - Database exists
# - PostgreSQL is running
```

---

## ✅ Solution 5: Fix Your .env File

### Step-by-Step:

1. **Find your PostgreSQL password:**
   - Check if you set it during installation
   - Default might be `postgres` or `admin`
   - Or check pgAdmin connection settings

2. **Update `.env` file:**

```env
# Replace 'password' with your actual PostgreSQL password
DATABASE_URL=postgresql://postgres:YOUR_PASSWORD@localhost:5432/medusa_db
```

**Example:**
```env
# If your password is "mypassword123"
DATABASE_URL=postgresql://postgres:mypassword123@localhost:5432/medusa_db

# If your password is "admin"
DATABASE_URL=postgresql://postgres:admin@localhost:5432/medusa_db
```

3. **Save the file**

4. **Restart your dev server:**
   ```powershell
   # Stop current server (Ctrl+C)
   # Then restart:
   npm run dev
   ```

---

## ✅ Solution 6: Use Railway PostgreSQL (If Local Fails)

If local PostgreSQL is too complicated, use Railway's:

1. **Go to Railway:** https://railway.app
2. **Create new project**
3. **Add PostgreSQL service**
4. **Copy DATABASE_URL** from Railway
5. **Paste into your `.env` file:**

```env
DATABASE_URL=postgresql://postgres:xxxxx@xxxxx.railway.app:5432/railway
```

---

## 🔍 Quick Checklist

- [ ] PostgreSQL service is running
- [ ] `.env` file exists in project root
- [ ] `DATABASE_URL` is set correctly
- [ ] Password in `DATABASE_URL` matches PostgreSQL password
- [ ] Database `medusa_db` exists
- [ ] Port is `5432` (or correct port)
- [ ] No typos in `DATABASE_URL`

---

## 🧪 Test Your Connection

After fixing `.env`, test:

```powershell
# 1. Test connection string format
# Extract parts from DATABASE_URL:
# postgresql://USER:PASSWORD@HOST:PORT/DATABASE

# 2. Try connecting manually
psql -U postgres -h localhost -p 5432 -d medusa_db

# 3. If that works, restart Medusa
npm run dev
```

---

## 📋 Complete .env Template

Here's a complete `.env` file that should work:

```env
# Database (UPDATE PASSWORD!)
DATABASE_URL=postgresql://postgres:YOUR_PASSWORD@localhost:5432/medusa_db

# Redis (optional - can skip for now)
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

# Trust Proxy (false for local)
TRUST_PROXY=false

# Node Environment
NODE_ENV=development
```

**⚠️ Replace `YOUR_PASSWORD` with your actual PostgreSQL password!**

---

## 🆘 Still Not Working?

### Check PostgreSQL Logs:

```powershell
# Windows: Check Event Viewer
# Or check PostgreSQL log file:
# Usually at: C:\Program Files\PostgreSQL\XX\data\log\
```

### Common Issues:

1. **"password authentication failed"**
   - Wrong password in `DATABASE_URL`
   - Fix: Update password in `.env`

2. **"database does not exist"**
   - Database `medusa_db` doesn't exist
   - Fix: Create it (see Solution 3)

3. **"connection refused"**
   - PostgreSQL not running
   - Fix: Start PostgreSQL service

4. **"connection timeout"**
   - Wrong host/port
   - Fix: Check `localhost:5432` is correct

---

**After fixing, restart your dev server and try again!** 🚀

