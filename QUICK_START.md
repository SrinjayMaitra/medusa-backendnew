# ⚡ Quick Start Guide

**Get your fresh Medusa backend running locally, then deploy to Railway.**

---

## 🏃 Quick Start (Local)

### 1. Install Dependencies

```powershell
cd medusabackend/medusa-backendnew
npm install
```

### 2. Set Up Environment Variables

Create a `.env` file in the root directory:

```env
# Database (use local PostgreSQL or Railway's)
DATABASE_URL=postgresql://postgres:password@localhost:5432/medusa_db

# Redis (optional)
REDIS_URL=redis://localhost:6379

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

### 3. Run Database Migrations

```powershell
npx medusa db:migrate
```

### 4. Create Admin User

```powershell
npm run create-admin
# or
npx medusa exec ./src/scripts/create-admin.ts
```

### 5. Start Development Server

```powershell
npm run dev
```

### 6. Access Admin Panel

Open: http://localhost:9000/app

**Login:**
- Email: `admin@medusa.com`
- Password: `test123`

---

## 🚀 Deploy to Railway

See **[RAILWAY_DEPLOYMENT.md](./RAILWAY_DEPLOYMENT.md)** for complete deployment guide.

**Quick steps:**
1. Push to GitHub
2. Create Railway project
3. Add PostgreSQL
4. Set environment variables
5. Deploy!
6. Create admin user
7. Test login

---

## ✅ Verify Everything Works

### Local Test Checklist

- [ ] Server starts without errors
- [ ] Can access http://localhost:9000/app
- [ ] Can login with admin credentials
- [ ] Cookie is set in browser
- [ ] Can navigate admin panel

### Railway Test Checklist

- [ ] Deployment successful
- [ ] Can access `https://your-app.railway.app/app`
- [ ] Can login with admin credentials
- [ ] Cookie is set in browser
- [ ] No CORS errors in console

---

## 🐛 Common Issues

### "Cannot connect to database"
- Check `DATABASE_URL` is correct
- Make sure PostgreSQL is running locally
- Or use Railway's PostgreSQL URL

### "Port 9000 already in use"
- Change port in `medusa-config.ts` or
- Kill process using port 9000

### "Login returns 401"
- Make sure admin user exists
- Check password matches
- Verify `TRUST_PROXY` is set correctly

---

**Ready to deploy?** Follow the [Railway Deployment Guide](./RAILWAY_DEPLOYMENT.md) 🚀

