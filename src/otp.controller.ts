import { Controller, Get, Param, HttpException, HttpStatus } from '@nestjs/common';
import { getDbPool } from './database';

@Controller('otp')
export class OtpController {

  @Get(':msisdn')
  async getOtp(@Param('msisdn') msisdn: string) {
    if (!msisdn || msisdn.trim() === '') {
      throw new HttpException('MSISDN is required', HttpStatus.BAD_REQUEST);
    }

    const cleanMsisdn = msisdn.trim();

    try {
      const pool = await getDbPool();
      const result = await pool.request()
        .input('msisdn', cleanMsisdn)
        .query(`
          SELECT TOP 1
            MSISDN,
            OTP,
            CREATED_DATE
          FROM SW_TBL_JSONRX_REGISTRATION
          WHERE MSISDN = @msisdn
          ORDER BY CREATED_DATE DESC
        `);

      if (!result.recordset || result.recordset.length === 0) {
        throw new HttpException(
          { success: false, message: `No OTP record found for MSISDN: ${cleanMsisdn}` },
          HttpStatus.NOT_FOUND,
        );
      }

      const record = result.recordset[0];

      return {
        success: true,
        data: {
          msisdn: record.MSISDN,
          otp: record.OTP,
          created_at: record.CREATED_DATE,
        },
      };
    } catch (err: any) {
      if (err instanceof HttpException) throw err;

      console.error('[OTP Lookup Error]', err.message);
      throw new HttpException(
        { success: false, message: 'Database error', detail: err.message },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }
}