# 📦 NPM Setup Instructions

**This project uses npm instead of yarn.**

---

## ✅ Quick Setup

### 1. Generate package-lock.json

If you don't have `package-lock.json` yet, run:

```powershell
cd medusabackend/medusa-backendnew
npm install
```

This will:
- ✅ Install all dependencies
- ✅ Generate `package-lock.json`
- ✅ Create `node_modules/` folder

---

## 🔄 Switching from Yarn to NPM

If you have `yarn.lock` but want to use npm:

1. **Delete yarn.lock** (optional):
   ```powershell
   Remove-Item yarn.lock
   ```

2. **Delete node_modules** (if exists):
   ```powershell
   Remove-Item -Recurse -Force node_modules
   ```

3. **Install with npm**:
   ```powershell
   npm install
   ```

4. **Verify package-lock.json exists**:
   ```powershell
   Test-Path package-lock.json
   ```

---

## 📋 All Commands Use NPM

### Development
```powershell
npm install          # Install dependencies
npm run dev          # Start dev server
npm run build        # Build for production
npm start            # Start production server
```

### Admin User
```powershell
npm run create-admin # Create admin user
npm run seed         # Seed demo data
```

### Medusa CLI
```powershell
npx medusa db:migrate
npx medusa user -e admin@medusa.com -p test123
```

---

## 🚀 Railway Deployment

The Dockerfile expects `package-lock.json`. Make sure it exists before deploying:

```powershell
# Verify package-lock.json exists
Test-Path package-lock.json

# If not, generate it
npm install

# Then commit and push
git add package-lock.json
git commit -m "Add package-lock.json for npm"
git push
```

---

## ✅ Verification

After setup, verify:

- [ ] `package-lock.json` exists
- [ ] `node_modules/` folder exists
- [ ] `npm install` completes without errors
- [ ] `npm run dev` starts the server

---

**All set!** The project is now configured to use npm. 🎉

