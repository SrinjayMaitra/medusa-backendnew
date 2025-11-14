# 🔧 Railway Variables Setup Guide

**What to modify in Railway Variables tab.**

---

## 🚨 Critical Changes Needed

### Step 1: Add PostgreSQL Database First

**Before setting variables, add PostgreSQL service:**

1. **In Railway dashboard**, click **"+ New"**
2. **Select:** "Database" → "Add PostgreSQL"
3. **Wait** for it to provision (30-60 seconds)
4. ✅ `DATABASE_URL` will be **automatically added**

---

## ✅ Variables to Modify

### 1. DATABASE_URL ⚠️ CRITICAL

**Current (WRONG):**
```
postgres://postgres:gulab1234@localhost:5432/medusa
```

**Fix:**
- **After adding PostgreSQL service**, Railway will auto-add this
- **Should show:** `${{Postgres.DATABASE_URL}}` (Railway reference)
- **OR** the actual connection string from Railway

**Action:** 
- Add PostgreSQL service first
- Railway will auto-populate this
- **Don't use localhost!**

---

### 2. REDIS_URL (Optional)

**Current (WRONG):**
```
redis://localhost:6379
```

**Fix Options:**

**Option A: Add Railway Redis (Recommended)**
1. Click **"+ New"** → **Database** → **Add Redis**
2. Railway will auto-add `REDIS_URL`
3. Should show: `${{Redis.REDIS_URL}}`

**Option B: Remove if not using Redis**
- Click the **X** to remove this variable
- Medusa will use a fake Redis instance (works fine)

**Action:** Either add Railway Redis or remove this variable.

---

### 3. JWT_SECRET ⚠️ SECURITY

**Current (INSECURE):**
```
supersecret
```

**Fix:** Generate a secure random string

**PowerShell command:**
```powershell
-join ((48..57) + (65..90) + (97..122) | Get-Random -Count 64 | ForEach-Object {[char]$_})
```

**Or use online:** https://randomkeygen.com/

**Action:** 
- Generate a 64-character random string
- Replace `supersecret` with the generated value
- **Example:** `aB3xK9mP2qR7vT5wY8zN1cF4hJ6dL0sG9bM3nV5xC8`

---

### 4. COOKIE_SECRET ⚠️ SECURITY

**Current (INSECURE):**
```
supersecret
```

**Fix:** Generate a **different** secure random string

**Action:**
- Generate a **different** 64-character random string
- Replace `supersecret` with the generated value
- **Must be different from JWT_SECRET!**

---

### 5. ADMIN_CORS ⚠️ CRITICAL

**Current:**
```
http://localhost:5173,http://localhost:9000,https://docs.medusajs.com
```

**Fix:** Add your Railway backend URL

**Steps:**
1. **Get your Railway URL:**
   - Go to **Settings** → **Networking**
   - Copy your public domain
   - Example: `https://medusa-backendnew-production.up.railway.app`

2. **Update ADMIN_CORS:**
```
https://medusa-backendnew-production.up.railway.app,http://localhost:5173,http://localhost:9000
```

**Action:** 
- Get Railway URL from Settings → Networking
- Add it to the beginning of ADMIN_CORS
- Keep localhost URLs for local development

---

### 6. AUTH_CORS ⚠️ CRITICAL

**Current:**
```
http://localhost:8000,http://127.0.0.1:8000
```

**Fix:** Must match ADMIN_CORS and include Railway URL

**Update to:**
```
https://medusa-backendnew-production.up.railway.app,http://localhost:5173,http://localhost:9000
```

**Action:**
- Must match ADMIN_CORS exactly!
- Include Railway URL
- Include localhost URLs

---

### 7. STORE_CORS

**Current:**
```
http://localhost:8000,http://127.0.0.1:8000
```

**Fix:** Add your storefront URL (if you have one)

**For now, keep as is:**
```
http://localhost:8000,http://127.0.0.1:8000
```

**Later, when you deploy storefront, add:**
```
https://your-storefront.vercel.app,http://localhost:8000,http://127.0.0.1:8000
```

---

## ➕ Variables to ADD

### 8. TRUST_PROXY ⚠️ CRITICAL - MUST ADD!

**Click "+ New Variable" and add:**

```
Name: TRUST_PROXY
Value: true
```

**Why:** Required for Railway to set cookies correctly. Without this, login won't work!

---

### 9. ADMIN_EMAIL

**Click "+ New Variable" and add:**

```
Name: ADMIN_EMAIL
Value: admin@medusa.com
```

**Why:** Used by admin creation script.

---

### 10. ADMIN_PASSWORD

**Click "+ New Variable" and add:**

```
Name: ADMIN_PASSWORD
Value: test123
```

**Why:** Used by admin creation script.

**⚠️ Change this to a secure password in production!**

---

### 11. NODE_ENV

**Click "+ New Variable" and add:**

```
Name: NODE_ENV
Value: production
```

**Why:** Tells Node.js this is a production environment.

---

## 📋 Complete Variable List

After all changes, you should have:

| Variable | Value | Notes |
|----------|-------|-------|
| `DATABASE_URL` | `${{Postgres.DATABASE_URL}}` | Auto-added by Railway |
| `REDIS_URL` | `${{Redis.REDIS_URL}}` | Optional, or remove |
| `JWT_SECRET` | `[64-char random string]` | Generate new! |
| `COOKIE_SECRET` | `[64-char random string]` | Generate new, different! |
| `STORE_CORS` | `http://localhost:8000,http://127.0.0.1:8000` | Add storefront URL later |
| `ADMIN_CORS` | `https://your-app.railway.app,http://localhost:5173,http://localhost:9000` | **Include Railway URL!** |
| `AUTH_CORS` | `https://your-app.railway.app,http://localhost:5173,http://localhost:9000` | **Match ADMIN_CORS!** |
| `TRUST_PROXY` | `true` | **MUST ADD!** |
| `ADMIN_EMAIL` | `admin@medusa.com` | Must add |
| `ADMIN_PASSWORD` | `test123` | Must add (change in production!) |
| `NODE_ENV` | `production` | Must add |

---

## 🎯 Step-by-Step Action Plan

### Step 1: Add PostgreSQL
1. Click **"+ New"** → **Database** → **Add PostgreSQL**
2. Wait for it to provision
3. ✅ `DATABASE_URL` auto-added

### Step 2: Update DATABASE_URL
- Verify it shows `${{Postgres.DATABASE_URL}}`
- If it shows localhost, delete and Railway will re-add it

### Step 3: Generate Secrets
```powershell
# Generate JWT_SECRET
-join ((48..57) + (65..90) + (97..122) | Get-Random -Count 64 | ForEach-Object {[char]$_})

# Generate COOKIE_SECRET (run again for different value)
-join ((48..57) + (65..90) + (97..122) | Get-Random -Count 64 | ForEach-Object {[char]$_})
```

### Step 4: Update JWT_SECRET and COOKIE_SECRET
- Replace `supersecret` with generated values

### Step 5: Get Railway URL
- Go to **Settings** → **Networking**
- Copy your public domain

### Step 6: Update CORS
- Update `ADMIN_CORS` to include Railway URL
- Update `AUTH_CORS` to match `ADMIN_CORS`

### Step 7: Add Missing Variables
- Click **"+ New Variable"** for each:
  - `TRUST_PROXY` = `true`
  - `ADMIN_EMAIL` = `admin@medusa.com`
  - `ADMIN_PASSWORD` = `test123`
  - `NODE_ENV` = `production`

### Step 8: Handle REDIS_URL
- Either add Railway Redis service
- Or click **X** to remove the variable

### Step 9: Click "Add" Button
- Click the purple **"Add"** button at bottom right
- Railway will redeploy automatically

---

## ✅ Verification Checklist

After setup, verify:

- [ ] PostgreSQL service added
- [ ] `DATABASE_URL` shows Railway reference (not localhost)
- [ ] `JWT_SECRET` is a random 64-char string (not "supersecret")
- [ ] `COOKIE_SECRET` is a different random 64-char string
- [ ] `ADMIN_CORS` includes Railway URL
- [ ] `AUTH_CORS` matches `ADMIN_CORS` exactly
- [ ] `TRUST_PROXY=true` is added
- [ ] `ADMIN_EMAIL` is added
- [ ] `ADMIN_PASSWORD` is added
- [ ] `NODE_ENV=production` is added
- [ ] All variables saved (clicked "Add")

---

## 🚨 Most Critical Items

**These 3 are ABSOLUTELY REQUIRED:**

1. ✅ **TRUST_PROXY=true** - Without this, login won't work!
2. ✅ **ADMIN_CORS includes Railway URL** - Without this, admin panel won't work!
3. ✅ **AUTH_CORS matches ADMIN_CORS** - Without this, authentication won't work!

---

**After making all changes, Railway will auto-redeploy. Wait for deployment to complete, then create admin user!** 🚀

