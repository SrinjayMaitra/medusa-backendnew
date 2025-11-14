# 🚀 Railway Deployment Guide - Fresh Medusa Template

**Complete guide to deploy your fresh Medusa backend to Railway.**

---

## ✅ Prerequisites

- [ ] GitHub account
- [ ] Railway account (sign up at https://railway.app)
- [ ] Git installed locally

---

## 📋 Step 1: Prepare Your Code

### 1.1 Push to GitHub

```powershell
cd medusabackend/medusa-backendnew

# Make sure package-lock.json exists (required for npm)
npm install

# Initialize git (if not already done)
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit - Fresh Medusa template ready for Railway"

# Create a new repository on GitHub, then:
git remote add origin https://github.com/your-username/medusa-backendnew.git
git branch -M main
git push -u origin main
```

**⚠️ Important:** Make sure `package-lock.json` is committed (it's required for the Dockerfile to work with npm).

---

## 🚂 Step 2: Deploy to Railway

### 2.1 Create New Project

1. **Go to Railway:** https://railway.app
2. **Click:** "New Project"
3. **Select:** "Deploy from GitHub repo"
4. **Choose:** Your `medusa-backendnew` repository
5. **Click:** "Deploy Now"

Railway will start deploying automatically!

---

## 🗄️ Step 3: Add PostgreSQL Database

1. **In Railway dashboard**, click **"+ New"**
2. **Select:** "Database" → "Add PostgreSQL"
3. **Wait** for PostgreSQL to provision (30-60 seconds)
4. ✅ `DATABASE_URL` will be **automatically added** to your environment variables

---

## ⚙️ Step 4: Configure Environment Variables

1. **Go to:** Your service → **Variables** tab
2. **Add the following variables:**

```env
# Database (auto-added by Railway, but verify it exists)
DATABASE_URL=${{Postgres.DATABASE_URL}}

# Redis (optional, but recommended)
# Add Redis service first, then:
REDIS_URL=${{Redis.REDIS_URL}}

# Security Secrets (GENERATE NEW ONES!)
# Use PowerShell to generate:
# -join ((48..57) + (65..90) + (97..122) | Get-Random -Count 64 | ForEach-Object {[char]$_})
JWT_SECRET=your-64-character-random-string-here
COOKIE_SECRET=your-different-64-character-random-string-here

# CORS Configuration
# For now, use localhost + Railway URL (update after deployment)
STORE_CORS=http://localhost:8000,http://localhost:3000
ADMIN_CORS=http://localhost:5173,http://localhost:9000,https://your-app.railway.app
AUTH_CORS=http://localhost:5173,http://localhost:9000,https://your-app.railway.app

# Admin User Credentials
ADMIN_EMAIL=admin@medusa.com
ADMIN_PASSWORD=test123

# CRITICAL: Trust Proxy (REQUIRED for Railway!)
TRUST_PROXY=true

# Node Environment
NODE_ENV=production
```

### 4.1 Get Your Railway URL

1. **Go to:** Settings → **Networking**
2. **Copy** your public domain (e.g., `https://medusa-backendnew-production.up.railway.app`)
3. **Update** `ADMIN_CORS` and `AUTH_CORS` to include this URL:
   ```
   ADMIN_CORS=http://localhost:5173,http://localhost:9000,https://medusa-backendnew-production.up.railway.app
   AUTH_CORS=http://localhost:5173,http://localhost:9000,https://medusa-backendnew-production.up.railway.app
   ```
4. Railway will **auto-redeploy** when you save

---

## ⏳ Step 5: Wait for Deployment

1. **Go to:** Deployments tab
2. **Watch** the build logs
3. **Wait** for "Build successful" and "Deploy successful"
4. **Check** logs for any errors

**Expected build time:** 2-5 minutes

---

## 👤 Step 6: Create Admin User

After deployment completes, create your admin user:

### Option 1: Using Railway CLI (Recommended)

```powershell
# Install Railway CLI (if not installed)
npm install -g @railway/cli

# Login to Railway
railway login

# Link to your project
railway link

# SSH into the container and create admin user
railway run npm run create-admin
# or
railway run npx medusa exec ./src/scripts/create-admin.ts
```

### Option 2: Using Railway Web Interface

1. **Go to:** Your service → **Deployments** → **Latest**
2. **Click:** "View Logs"
3. **Click:** "Shell" (or "Open Shell")
4. **Run:**
   ```bash
   npx medusa exec ./src/scripts/create-admin.ts
   ```

### Option 3: Using Medusa CLI

```powershell
railway run npx medusa user -e admin@medusa.com -p test123
```

### Option 4: Using npm script

```powershell
railway run npm run create-admin
```

---

## 🧪 Step 7: Test Login

1. **Open:** `https://your-app.railway.app/app`
2. **Login with:**
   - Email: `admin@medusa.com`
   - Password: `test123`
3. **Check DevTools:**
   - Network tab → `POST /auth/user/emailpass` → Should be 200 OK
   - Response Headers → Should have `Set-Cookie: _medusa_jwt`
   - Application → Cookies → Should see `_medusa_jwt` cookie

---

## ✅ Success Checklist

- [ ] Code pushed to GitHub
- [ ] Railway project created
- [ ] PostgreSQL added
- [ ] All environment variables set
- [ ] `TRUST_PROXY=true` set
- [ ] CORS includes Railway URL
- [ ] Deployment successful
- [ ] Admin user created
- [ ] Login works at `/app`
- [ ] Cookie is set in browser

---

## 🐛 Troubleshooting

### Issue: Build Fails

**Error:** `Cannot find module 'ts-node'`
**Fix:** The Dockerfile should install all dependencies. Check build logs.

**Error:** `npm run build` fails
**Fix:** Check TypeScript errors in build logs.

---

### Issue: Login Returns 401

**Check:**
1. ✅ `TRUST_PROXY=true` is set
2. ✅ CORS includes Railway URL
3. ✅ Admin user exists (check logs)
4. ✅ Password matches what you're typing

**Fix:**
```powershell
# Recreate admin user
railway run npx medusa exec ./src/scripts/create-admin.ts
```

---

### Issue: No Set-Cookie Header

**Check:**
1. ✅ `TRUST_PROXY=true` is set
2. ✅ `cookieOptions` in `medusa-config.ts`
3. ✅ CORS includes Railway URL

**Fix:** Make sure `medusa-config.ts` has:
```typescript
cookieOptions: {
  secure: process.env.NODE_ENV === 'production' || process.env.TRUST_PROXY === 'true',
  sameSite: 'lax',
  httpOnly: true,
}
```

---

### Issue: CORS Errors

**Check:**
1. ✅ `ADMIN_CORS` includes Railway URL
2. ✅ `AUTH_CORS` includes Railway URL
3. ✅ No spaces in CORS values
4. ✅ Exact match between `ADMIN_CORS` and `AUTH_CORS`

**Fix:** Update CORS variables and wait for redeploy.

---

## 📚 Next Steps

After successful deployment:

1. **Update CORS** for your frontend URLs
2. **Set up custom domain** (optional)
3. **Configure Redis** for better performance
4. **Set up monitoring** and alerts
5. **Backup database** regularly

---

## 🎯 Quick Reference

**Railway Dashboard:** https://railway.app
**Your App URL:** `https://your-app.railway.app`
**Admin Panel:** `https://your-app.railway.app/app`
**API Docs:** `https://your-app.railway.app/docs`

**Admin Credentials:**
- Email: `admin@medusa.com`
- Password: `test123` (change this in production!)

---

**Good luck with your deployment! 🚀**

