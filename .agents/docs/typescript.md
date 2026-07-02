# TypeScript Patterns

## Preferences
- Package manager: `pnpm` > `npm` > `yarn`
- `strict: true` in tsconfig.json
- Union types over enums for string literals

## Zod Validation (Fastify)
```typescript
import { z, ZodError } from "zod";

function formatZodError(error: ZodError): string {
  return error.errors.map((e) => `${e.path.join(".")}: ${e.message}`).join(", ");
}

const querySchema = z.object({
  latitude: z.string().transform((v) => parseFloat(v))
    .refine((v) => !isNaN(v) && v >= -90 && v <= 90, { message: "Latitude must be -90..90" }),
  longitude: z.string().transform((v) => parseFloat(v))
    .refine((v) => !isNaN(v) && v >= -180 && v <= 180, { message: "Longitude must be -180..180" }),
});

// Route: ZodError → 400, not 500
fastify.get("/api/endpoint", async (request, reply) => {
  try {
    const params = querySchema.parse(request.query);
  } catch (e) {
    if (e instanceof ZodError) {
      return reply.status(400).send({ error: "Bad Request", message: formatZodError(e) });
    }
    throw e;
  }
});
```

## Quality
```sh
npx prettier --write . && npx eslint . --fix && npx tsc --noEmit
```
