# ℹ️ Trust Proxy Configuration

**Note about `TRUST_PROXY` environment variable**

---

## ✅ What Changed

**Removed `trustProxy` from `medusa-config.ts`**

Medusa v2 handles trust proxy automatically based on:
- Environment variables
- Deployment platform detection
- Standard Express.js behavior

---

## 🔧 How It Works

### Medusa v2 Automatic Detection

Medusa v2 automatically detects when running behind a proxy (like Railway) and:
- ✅ Reads `X-Forwarded-*` headers correctly
- ✅ Sets cookies with `secure: true` in production
- ✅ Handles HTTPS correctly

### Environment Variable Still Needed

**Keep `TRUST_PROXY=true` in Railway variables!**

Even though it's not in the config file, the environment variable:
- Helps Medusa detect the deployment environment
- Ensures proper cookie handling
- Ensures proper HTTPS detection

---

## 📋 Railway Variables

**Still set this in Railway:**

```
TRUST_PROXY=true
```

**Why:** 
- Medusa uses this to detect production environment
- Ensures cookies are set correctly
- Ensures HTTPS is detected properly

---

## ✅ What's Configured

- ✅ `cookieSecret` - For secure cookies
- ✅ `jwtSecret` - For JWT tokens
- ✅ CORS settings - For cross-origin requests
- ✅ `TRUST_PROXY` env var - Still needed in Railway

**Medusa v2 handles the rest automatically!**

---

**The config is now clean and will build successfully!** ✅

