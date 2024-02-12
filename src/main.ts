import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { Logger } from '@nestjs/common';

const PORT = process.env.PORT;
async function bootstrap() {
  const logger = new Logger('Bootstrap');
  const app = await NestFactory.create(AppModule, {});
  await app.listen(PORT);
  logger.log(`App running in port ${PORT} 🚀`);
}
bootstrap();
