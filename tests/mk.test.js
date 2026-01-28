const { test, expect } = require('@playwright/test');

test('smoke: start page loads', async ({ page }) => {
    await page.goto('https://mk.oxid.academy');
    await expect(page.getByRole('heading', {
        name: 'Example Domain'
    })).toBeVisible();
});