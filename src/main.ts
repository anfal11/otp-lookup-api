import 'reflect-metadata';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  const port = process.env.PORT || 3000;
  await app.listen(port, '0.0.0.0');

  console.log(`[OTP Lookup API] Running on http://0.0.0.0:${port}`);
  console.log(`[OTP Lookup API] Usage: GET /otp/{msisdn}`);
}

bootstrap();