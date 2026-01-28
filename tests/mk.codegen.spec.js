import { test, expect } from '@playwright/test';

test('test', async ({ page }) => {
  await page.goto('https://mk.oxid.academy/');
  await expect(page.getByRole('list')).toContainText('Fast Delivery');
});