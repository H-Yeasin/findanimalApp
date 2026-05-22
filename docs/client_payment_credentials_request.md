# Hesteka Payment Credentials Request

This document lists the credentials, account access, and setup decisions needed to move Hesteka payments from development/test mode to production-ready Stripe, PayPal, Apple Pay, and Google Pay.

Please do not send secret keys in plain email or chat. Share them through a password manager, encrypted note, or by inviting the developer to the relevant dashboard with limited permissions.

## 1. Project Context

Hesteka is a registered nonprofit/association. Payments in the app are treated as support/fundraising contributions, not purchases of digital content or locked app features.

Current payment providers:

- Stripe: card payments now, Apple Pay / Google Pay later through Stripe
- PayPal: PayPal support payments

Production API endpoint:

```text
https://api.hesteka.com/api/v1
```

Production webhook endpoints:

```text
https://api.hesteka.com/api/v1/webhook/stripe
https://api.hesteka.com/api/v1/webhook/paypal
```

## 2. Preferred Access Method

The safest method is dashboard access, not copy-pasting secrets.

Please invite the developer to:

- Stripe Dashboard with Developer/Admin access, or temporary access sufficient to read API keys and configure webhooks.
- PayPal Developer Dashboard or PayPal Business account access sufficient to create/read REST app credentials and webhooks.
- Apple Developer account access later for Apple Pay merchant setup.
- Google Play Console access later for release/payment testing if needed.

If direct access is not possible, provide the exact values listed below using a secure channel.

## 3. Stripe Credentials Needed

Required for production:

```env
STRIPE_PUBLISHABLE_KEY=pk_live_...
STRIPE_SECRET_KEY=sk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...
```

Optional but useful:

```text
Stripe account country
Default currency, expected: EUR
Business/legal name
Statement descriptor to show on card statements
Support email shown by Stripe
Whether fiscal receipts are required for any support payments
```

Stripe dashboard steps:

1. Log in to Stripe.
2. Make sure the account is fully activated for live payments.
3. Go to Developers > API keys.
4. Copy the live publishable key.
5. Copy the live secret key, or create a restricted key if preferred.
6. Go to Developers > Webhooks.
7. Add endpoint:

```text
https://api.hesteka.com/api/v1/webhook/stripe
```

8. Enable these events:

```text
payment_intent.succeeded
payment_intent.payment_failed
```

9. Copy the webhook signing secret, which starts with:

```text
whsec_
```

Official Stripe references:

- API keys: https://docs.stripe.com/keys
- API authentication and secret key safety: https://docs.stripe.com/api/authentication
- Webhooks: https://docs.stripe.com/webhooks

## 4. PayPal Credentials Needed

Required for production:

```env
PAYPAL_CLIENT_ID=...
PAYPAL_CLIENT_SECRET=...
PAYPAL_MODE=live
PAYPAL_WEBHOOK_ID=...
```

Optional but useful:

```text
PayPal business account email
Merchant ID
Default currency, expected: EUR
Business/legal name
```

PayPal dashboard steps:

1. Log in to PayPal Developer.
2. Open Apps & Credentials.
3. Switch from Sandbox to Live.
4. Create or open the Hesteka REST app.
5. Copy the live Client ID.
6. Copy the live Secret.
7. Add webhook endpoint:

```text
https://api.hesteka.com/api/v1/webhook/paypal
```

8. Enable these events:

```text
CHECKOUT.ORDER.APPROVED
PAYMENT.CAPTURE.COMPLETED
PAYMENT.CAPTURE.DENIED
PAYMENT.CAPTURE.REFUNDED
```

9. Copy the PayPal Webhook ID.

Official PayPal references:

- REST API credentials: https://developer.paypal.com/api/rest/
- Webhooks overview: https://developer.paypal.com/api/rest/webhooks/
- Webhook signature verification: https://developer.paypal.com/docs/api/webhooks/v1/

## 5. Apple Pay Later Through Stripe

Apple Pay will be handled through Stripe, but the Apple Developer account still needs a merchant identifier and app capability.

Needed from the client later:

```text
Apple Developer Team ID
Apple account holder/admin access, or developer access with capability management
Apple Pay Merchant Identifier, for example merchant.com.hesteka.app
iOS Bundle ID, expected: com.emmafve.app unless changed
Country code for merchant, expected: FR if the association is registered in France
```

Apple Pay setup steps:

1. In Apple Developer, create a Merchant Identifier.
2. Create the Apple Pay payment processing certificate if required by the payment setup.
3. Enable Apple Pay capability for the iOS app.
4. Select the merchant identifier in Xcode.
5. Enable Apple Pay in Stripe payment method settings.
6. Developer will configure Flutter Stripe with the merchant identifier.

Official Apple reference:

- Apple Pay setup: https://developer.apple.com/documentation/passkit/setting-up-apple-pay
- Apple Pay sandbox testing: https://developer.apple.com/apple-pay/sandbox-testing/

Flutter Stripe reference:

- PaymentSheet Apple Pay / Google Pay: https://docs.page/flutter-stripe/flutter_stripe/sheet

## 6. Google Pay Later Through Stripe

Google Pay will also be handled through Stripe.

Needed from the client later:

```text
Google Play Console access if production testing/submission needs it
Android package name, expected: com.emmafve.app unless changed
Merchant display name, expected: Hesteka
Merchant country code, expected: FR if the association is registered in France
Confirmation that Google Pay is enabled in Stripe payment methods
```

Developer will also ensure Android has:

```xml
<meta-data
    android:name="com.google.android.gms.wallet.api.enabled"
    android:value="true" />
```

Official Flutter Stripe Google Pay reference:

- Google Pay with Flutter Stripe: https://docs.page/flutter-stripe/flutter_stripe/google_pay

## 7. Backend Production Environment Variables

These values need to exist on the backend hosting provider:

```env
STRIPE_SECRET_KEY=sk_live_...
STRIPE_WEBHOOK_SECRET=whsec_...

PAYPAL_CLIENT_ID=...
PAYPAL_CLIENT_SECRET=...
PAYPAL_MODE=live
PAYPAL_WEBHOOK_ID=...

FRONTEND_URL=https://hesteka.com
PUBLIC_URL=https://api.hesteka.com
BACKEND_URL=https://api.hesteka.com
```

Do not expose `STRIPE_SECRET_KEY`, `STRIPE_WEBHOOK_SECRET`, `PAYPAL_CLIENT_SECRET`, or `PAYPAL_WEBHOOK_ID` in the mobile app.

## 8. Mobile Build-Time Values

These values are passed when building the app:

```env
API_BASE_URL=https://api.hesteka.com/api/v1
STRIPE_PUBLISHABLE_KEY=pk_live_...
PAYPAL_CLIENT_ID=...
GOOGLE_MAPS_API_KEY=...
```

Only publishable/client-side values belong in the mobile app.

## 9. Production Readiness Checklist

Before release:

- Stripe live payment succeeds.
- Stripe webhook confirms the payment status.
- PayPal live order creation works.
- PayPal approval and capture work.
- PayPal webhook confirms the payment status.
- Support receipt email wording is correct.
- App wording says support/fundraising, not paid digital product.
- No test keys remain in the mobile app or backend.
- Payment failure, cancellation, and retry flows are tested.
- Refund process is agreed internally.
- Stripe and PayPal dashboards show the correct business/legal entity.
- Privacy policy mentions payment processors and support payments.

## 10. Secure Sharing Checklist For Client

Please send:

```text
1. Stripe live publishable key
2. Stripe live secret key or restricted key
3. Stripe webhook signing secret for https://api.hesteka.com/api/v1/webhook/stripe
4. PayPal live client ID
5. PayPal live client secret
6. PayPal webhook ID for https://api.hesteka.com/api/v1/webhook/paypal
7. Confirm payment currency: EUR
8. Confirm legal business/association name
9. Confirm receipt wording: Support Receipt / Reçu de soutien
10. Later: Apple Developer access for Apple Pay merchant ID
11. Later: Google Play Console access for Google Pay/release testing
```

Please share secrets through a secure password manager or encrypted note, not regular email.
