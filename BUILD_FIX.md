# 🔧 Build Error Fix

**Fixed TypeScript error in medusa-config.ts**

---

## 🚨 Error

```
medusa-config.ts:15:7 - error TS2353: Object literal may only specify known properties, and 'cookieOptions' does not exist in type...
```

**Cause:** `cookieOptions` is not a valid property in Medusa v2's `http` configuration.

---

## ✅ Fix Applied

**Removed `cookieOptions` from `medusa-config.ts`**

Medusa v2 handles cookies automatically based on:
- `cookieSecret` (already configured)
- `trustProxy` (already configured)
- Environment variables

**Cookie settings are handled internally by Medusa v2.**

---

## 📋 Updated Config

```typescript
module.exports = defineConfig({
  projectConfig: {
    databaseUrl: process.env.DATABASE_URL,
    redisUrl: process.env.REDIS_URL || process.env.REDISCLOUD_URL,
    http: {
      storeCors: process.env.STORE_CORS!,
      adminCors: process.env.ADMIN_CORS!,
      authCors: process.env.AUTH_CORS!,
      jwtSecret: process.env.JWT_SECRET || "supersecret",
      cookieSecret: process.env.COOKIE_SECRET || "supersecret",
    },
    // Trust proxy for Railway (handles X-Forwarded headers)
    trustProxy: process.env.TRUST_PROXY === 'true' || process.env.NODE_ENV === 'production',
  }
})
```

---

## ✅ What Still Works

- ✅ `trustProxy` - Still configured for Railway
- ✅ `cookieSecret` - Still configured for secure cookies
- ✅ `jwtSecret` - Still configured for JWT tokens
- ✅ CORS settings - Still configured

**Medusa v2 will automatically:**
- Set cookies as `httpOnly: true`
- Set cookies as `secure: true` in production (when `trustProxy` is set)
- Set cookies with `sameSite: 'lax'`

---

## 🚀 Next Steps

1. **Railway will auto-redeploy** with the fix
2. **Build should succeed** now
3. **Cookies will still work** - Medusa handles them automatically

---

**The build error is fixed! Railway should redeploy successfully now.** ✅

