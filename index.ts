import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

const test1 = await prisma.user.create({
  data: {
    email: `user${Math.random()}@prisma.io`,
  },
})
console.log(test1)

const count = await prisma.user.count();
console.log(`There are ${count} users in the database.`);
