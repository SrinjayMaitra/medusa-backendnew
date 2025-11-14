import { loadEnv, defineConfig } from '@medusajs/framework/utils'

loadEnv(process.env.NODE_ENV || 'development', process.cwd())

module.exports = defineConfig({
  projectConfig: {
    databaseUrl: process.env.DATABASE_URL,
    http: {
      storeCors: process.env.STORE_CORS!,
      adminCors: process.env.ADMIN_CORS!,
      authCors: process.env.AUTH_CORS!,
      jwtSecret: process.env.JWT_SECRET || "supersecret",
      cookieSecret: process.env.COOKIE_SECRET || "supersecret",
      // Cookie options for Railway/production
      cookieOptions: {
        secure: process.env.NODE_ENV === 'production' || process.env.TRUST_PROXY === 'true',
        sameSite: 'lax',
        httpOnly: true,
      },
    },
    // Trust proxy for Railway (handles X-Forwarded headers)
    trustProxy: process.env.TRUST_PROXY === 'true' || process.env.NODE_ENV === 'production',
  }
})
