import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

const count = await prisma.user.count();
console.log(`There are ${count} users in the database.`);
