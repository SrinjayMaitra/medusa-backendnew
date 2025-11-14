# 🔧 Database Migrations Fix

**Fixed: Database tables don't exist error**

---

## 🚨 The Problem

**Error:**
```
relation "currency" does not exist
relation "tax_provider" does not exist
relation "payment_provider" does not exist
relation "notification_provider" does not exist
relation "fulfillment_provider" does not exist
Error starting server
```

**Cause:** Database migrations haven't been run. The database is empty, so Medusa can't find the required tables.

---

## ✅ The Fix

**Updated Dockerfile to run migrations before starting the server:**

```dockerfile
CMD ["sh", "-c", "npx medusa db:migrate && npm start"]
```

**What this does:**
1. Runs `npx medusa db:migrate` to create all database tables
2. Then starts the Medusa server
3. If migrations fail, the server won't start (prevents errors)

---

## 🔄 How It Works

### On Railway Deployment:

1. **Dockerfile builds** the application
2. **Container starts** and runs the CMD
3. **Migrations run first:**
   - Creates all required tables
   - Sets up database schema
   - Seeds initial data (if any)
4. **Server starts** after migrations complete
5. **Medusa is ready** to handle requests

---

## 📋 Migration Process

**What migrations do:**
- ✅ Create all database tables
- ✅ Set up indexes
- ✅ Create foreign keys
- ✅ Set up initial schema

**Tables created:**
- `currency`
- `tax_provider`
- `payment_provider`
- `notification_provider`
- `fulfillment_provider`
- `region`
- `region_country`
- `user`
- `auth_identity`
- `provider_identity`
- And many more...

---

## ✅ Verification

After Railway redeploys, check logs:

**Should see:**
```
Running migrations...
Migration completed successfully
Starting server...
```

**Should NOT see:**
```
relation "currency" does not exist
Error starting server
```

---

## 🚀 Next Steps

1. **Railway will auto-redeploy** with the fix
2. **Migrations will run** automatically on startup
3. **Server will start** after migrations complete
4. **Create admin user** after server is running

---

## 🧪 Manual Migration (If Needed)

If you need to run migrations manually on Railway:

```powershell
# Using Railway CLI
railway run npx medusa db:migrate

# Or via Railway web console
# Go to: Service → Deployments → Latest → Shell
# Run: npx medusa db:migrate
```

---

## ⚠️ Important Notes

1. **Migrations are idempotent** - Safe to run multiple times
2. **First deployment** - Migrations will create all tables
3. **Subsequent deployments** - Migrations will only update if schema changed
4. **Database must exist** - Make sure PostgreSQL service is added in Railway

---

**The database migration issue is fixed! Railway will now run migrations automatically on startup.** ✅

