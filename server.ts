import { PrismaClient } from '@prisma/client'

const prisma = new PrismaClient()

const server = Bun.serve({
  port: 3000,
  async fetch(req) {
    const url = new URL(req.url);
    if (url.pathname === "/") {
      const count = await prisma.user.count();
      return new Response(`{"count": "${count}"}`, {
      headers: {
        "Content-Type": "application/json",
      },
    });
    }
    return new Response("404!");
  },
});

console.log(`Listening on localhost: ${server.port}`);
