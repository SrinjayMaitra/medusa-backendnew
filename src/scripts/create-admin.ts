import { ExecArgs } from "@medusajs/framework/types"
import { ContainerRegistrationKeys, Modules } from "@medusajs/framework/utils"
import { createUsersWorkflow } from "@medusajs/medusa/core-flows"

/**
 * Script to create an admin user
 * Usage: medusa exec ./src/scripts/create-admin.ts
 */
export default async function createAdmin({ container }: ExecArgs) {
  const logger = container.resolve(ContainerRegistrationKeys.LOGGER)
  const query = container.resolve(ContainerRegistrationKeys.QUERY)
  const authModule = container.resolve(Modules.AUTH)
  const userModule = container.resolve(Modules.USER)

  const email = process.env.ADMIN_EMAIL || "admin@medusa.com"
  const password = process.env.ADMIN_PASSWORD || "supersecret"

  logger.info(`🔧 Creating admin user: ${email}`)

  try {
    // Check if user already exists
    const existingUsersResult = await query.graph({
      entity: "user",
      fields: ["id", "email"],
      filters: {
        email: email,
      },
    })

    let userId: string

    if (existingUsersResult && existingUsersResult.data && existingUsersResult.data.length > 0) {
      userId = existingUsersResult.data[0].id
      logger.info(`✅ User already exists: ${email} (ID: ${userId})`)
    } else {
      // Create new user
      logger.info(`📝 Creating new user: ${email}`)
      const { result: users } = await createUsersWorkflow(container).run({
        input: {
          users: [
            {
              email,
            },
          ],
        },
      })
      userId = users[0].id
      logger.info(`✅ User created: ${email} (ID: ${userId})`)
    }

    // Mark user as admin
    try {
      await userModule.updateUsers({
        id: userId,
        metadata: {
          is_admin: true,
        },
      })
      logger.info(`✅ User marked as admin`)
    } catch (error: any) {
      logger.warn(`⚠️ Could not update user metadata: ${error?.message || error}`)
    }

    // Delete existing auth identity if it exists
    try {
      const allAuthIdentities = await authModule.listAuthIdentities({})
      if (allAuthIdentities && allAuthIdentities.length > 0) {
        const userAuthIdentity = allAuthIdentities.find(
          (auth: any) => auth.entity_id === userId
        )
        if (userAuthIdentity) {
          await authModule.deleteAuthIdentities([userAuthIdentity.id])
          logger.info(`🗑️ Deleted existing auth identity`)
        }
      }
    } catch (error: any) {
      logger.warn(`⚠️ Could not delete existing auth identity: ${error?.message || error}`)
    }

    // Create auth identity with plain text password
    // Medusa's emailpass provider will hash it automatically during authentication
    logger.info(`🔐 Creating auth identity with password`)
    
    await (authModule.createAuthIdentities as any)([
      {
        entity_id: userId,
        provider: "emailpass",
        provider_metadata: {
          password: password, // Plain text - Medusa hashes it during auth
        },
        user_metadata: {
          is_admin: true,
        },
      },
    ])

    logger.info(`✅ Admin user ready!`)
    logger.info(`📧 Email: ${email}`)
    logger.info(`🔑 Password: ${password}`)
    logger.info(`🌐 Login at: /app`)
  } catch (error: any) {
    logger.error(`❌ Error creating admin user: ${error.message}`)
    logger.error(error.stack)
    throw error
  }
}

