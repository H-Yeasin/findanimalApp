import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../core/localization/app_localizations.dart';

class PaymentWebviewScreen extends StatefulWidget {
  final String paymentMethod; // 'stripe' or 'paypal'
  final double amount;
  final String donorName;
  final String donorEmail;
  final bool isCompanyDonation;

  const PaymentWebviewScreen({
    super.key,
    required this.paymentMethod,
    required this.amount,
    required this.donorName,
    required this.donorEmail,
    this.isCompanyDonation = false,
  });

  @override
  State<PaymentWebviewScreen> createState() => _PaymentWebviewScreenState();
}

class _PaymentWebviewScreenState extends State<PaymentWebviewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    final htmlString = widget.paymentMethod == 'stripe'
        ? _generateStripeHtml()
        : _generatePayPalHtml();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..addJavaScriptChannel(
        'PaymentChannel',
        onMessageReceived: (JavaScriptMessage message) {
          debugPrint('WebView Message: ${message.message}');
          if (message.message == 'success') {
            Navigator.of(context).pop(true);
          } else if (message.message == 'error') {
            Navigator.of(context).pop(false);
          } else if (message.message.startsWith('error:')) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message.message.substring(6))),
            );
          } else if (message.message.startsWith('log:')) {
            debugPrint('JS Log: ${message.message.substring(4)}');
          }
        },
      )
      ..loadHtmlString(htmlString, baseUrl: 'https://hesteka.com');
  }

  String _generateStripeHtml() {
    return """
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <title>Stripe Checkout</title>
    <script src="https://js.stripe.com/v3/"></script>
    <style>
      body {
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        background: #FBF4E9;
        margin: 0;
        padding: 15px;
        display: flex;
        justify-content: center;
        align-items: flex-start;
        height: 100vh;
      }
      .card {
        background: white;
        padding: 30px;
        border-radius: 20px;
        width: 100%;
        max-width: 450px;
        box-shadow: 0 10px 25px rgba(186, 74, 34, 0.1);
        border: 1px solid rgba(186, 74, 34, 0.1);
      }
      h2 { margin-top: 0; color: #BA4A22; text-align: center; font-size: 24px; font-weight: 800; }
      .field { margin-bottom: 25px; }
      #card-element {
        padding: 16px;
        border: 1.5px solid #E8DDD0;
        border-radius: 12px;
        background: #FDFDFD;
        min-height: 40px; /* Ensure field is visible */
      }
      button {
        width: 100%;
        padding: 16px;
        background: #BA4A22;
        color: white;
        border: none;
        border-radius: 30px;
        font-size: 16px;
        font-weight: 900;
        cursor: pointer;
        transition: transform 0.2s, background 0.2s;
        box-shadow: 0 4px 12px rgba(186, 74, 34, 0.3);
      }
      button:active { transform: scale(0.98); }
      button:disabled { background: #E8DDD0; cursor: not-allowed; box-shadow: none; }
      #message { margin-top: 20px; padding: 12px; border-radius: 10px; display: none; text-align: center; font-size: 14px; font-weight: 600; }
      .success { background: #E7F3EF; color: #2D6A4F; display: block; }
      .error { background: #FDECEC; color: #C53030; display: block; }
      .loading { background: #FFF9E6; color: #B7791F; display: block; }
      .summary { margin-bottom: 30px; text-align: center; font-size: 18px; color: #3A2A1A; }
      .summary strong { font-size: 24px; color: #BA4A22; }
    </style>
  </head>
  <body>
    <div class="card">
      <h2>Assistance complète</h2>
      <div class="summary">
        Amount: <strong>${widget.amount}€</strong><br/>
      </div>
      
      <div class="field">
        <div id="card-element"></div>
      </div>
      <button id="pay-btn">Pay Now</button>
      <div id="message"></div>
    </div>

    <script>
      (function() {
        try {
          const log = (msg) => { if(window.PaymentChannel) PaymentChannel.postMessage('log:' + msg); console.log(msg); };
          const error = (msg) => { if(window.PaymentChannel) PaymentChannel.postMessage('error:' + msg); console.error(msg); };

          const BACKEND_URL = "https://api.hesteka.com";
          const stripe = Stripe("pk_test_51ShzG65v6xjmDo05UhGMIsToDUCvN1B0ZrJlTjiYYNuwQ2xrc4ZnHAhPP3mbMQkGHo5gJqlrlQuobgQpSvLSbZOj00U9EPKZMw");
          const elements = stripe.elements();
          
          const style = {
            base: {
              color: '#32325d',
              fontFamily: '"Helvetica Neue", Helvetica, sans-serif',
              fontSmoothing: 'antialiased',
              fontSize: '16px',
              '::placeholder': { color: '#aab7c4' }
            },
            invalid: { color: '#fa755a', iconColor: '#fa755a' }
          };
          
          const card = elements.create("card", { style: style });
          card.mount("#card-element");
          log("Stripe card element mounted");

          const btn = document.getElementById("pay-btn");
          const msg = document.getElementById("message");

          function show(type, text) {
            msg.style.display = "block";
            msg.className = type;
            msg.textContent = text;
          }

          btn.onclick = async () => {
            log("Pay button clicked");
            btn.disabled = true;
            show("loading", "Processing payment securely...");

            try {
              const payload = {
                amount: ${widget.amount},
                currency: "eur",
                donorEmail: "${widget.donorEmail}",
                donorName: "${widget.donorName}",
                type: "one-time",
                isCompanyDonation: ${widget.isCompanyDonation},
              };
              log("Initiating payment with: " + JSON.stringify(payload));

              const res = await fetch(`\${BACKEND_URL}/api/v1/donations/stripe/initiate`, {
                method: "POST",
                headers: { "Content-Type": "application/json" },
                body: JSON.stringify(payload),
              });

              const data = await res.json();
              if (!res.ok) {
                error("Initiation failed: " + (data.message || "Unknown error"));
                show("error", data.message || "Failed to initiate payment");
                btn.disabled = false;
                return;
              }

              const clientSecret = data.data.clientSecret;
              log("Payment intent initiated, confirming...");

              const { error: stripeError, paymentIntent } = await stripe.confirmCardPayment(clientSecret, {
                payment_method: {
                  card,
                  billing_details: {
                    name: "${widget.donorName}",
                    email: "${widget.donorEmail}",
                  },
                },
              });

              if (stripeError) {
                error("Stripe confirm error: " + stripeError.message);
                show("error", stripeError.message);
                btn.disabled = false;
                return;
              }

              if (paymentIntent && paymentIntent.status === 'succeeded') {
                log("Payment succeeded!");
                show("success", "Payment successful!");
                if(window.PaymentChannel) PaymentChannel.postMessage('success');
              } else {
                log("Payment in state: " + (paymentIntent ? paymentIntent.status : 'unknown'));
                show("loading", "Waiting for final confirmation...");
                setTimeout(() => {
                   if(window.PaymentChannel) PaymentChannel.postMessage('success');
                }, 3000);
              }
            } catch (e) {
              error("Runtime error: " + e.message);
              show("error", "Something went wrong. Please try again.");
              btn.disabled = false;
            }
          };
        } catch (e) {
          if(window.PaymentChannel) PaymentChannel.postMessage('error:Script Load Error: ' + e.message);
        }
      })();
    </script>
  </body>
</html>
""";
  }

  String _generatePayPalHtml() {
    return """
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
    <title>PayPal Checkout</title>
    <style>
      body {
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
        background: #FBF4E9;
        margin: 0;
        padding: 15px;
        display: flex;
        justify-content: center;
        align-items: flex-start;
        height: 100vh;
      }
      .card {
        background: white;
        padding: 30px;
        border-radius: 20px;
        width: 100%;
        max-width: 450px;
        box-shadow: 0 10px 25px rgba(186, 74, 34, 0.1);
        border: 1px solid rgba(186, 74, 34, 0.1);
        text-align: center;
      }
      h2 { margin-top: 0; color: #BA4A22; font-size: 24px; font-weight: 800; }
      .summary { margin-bottom: 30px; font-size: 18px; color: #3A2A1A; }
      .summary strong { font-size: 24px; color: #BA4A22; }
      #message { margin-top: 20px; padding: 12px; border-radius: 10px; display: none; text-align: center; font-size: 14px; font-weight: 600; }
      .success { background: #E7F3EF; color: #2D6A4F; display: block; }
      .error { background: #FDECEC; color: #C53030; display: block; }
      .loading { background: #FFF9E6; color: #B7791F; display: block; }
    </style>
  </head>
  <body>
    <div class="card">
      <h2>Assistance via PayPal</h2>
      <div class="summary">
        Amount: <strong>${widget.amount}€</strong><br/>
      </div>
      <div id="paypal-button-container"></div>
      <div id="message"></div>
    </div>

    <script src="https://www.paypal.com/sdk/js?client-id=AfLVJRUUAehybaJ2Xy9dyBJNqWYOxGfHHf0ZMc2RtEdX2067Y1LA5X42Qwp_oxL7inGdEAr1E7uMTvxG&currency=EUR"></script>
    <script>
      (function() {
        try {
          const log = (msg) => { if(window.PaymentChannel) PaymentChannel.postMessage('log:' + msg); console.log(msg); };
          const error = (msg) => { if(window.PaymentChannel) PaymentChannel.postMessage('error:' + msg); console.error(msg); };

          const msg = document.getElementById("message");
          function show(type, text) {
            msg.style.display = "block";
            msg.className = type;
            msg.textContent = text;
          }

          paypal.Buttons({
            createOrder: async () => {
              log("PayPal createOrder initiated");
              show("loading", "Initiating secure connection...");
              try {
                const res = await fetch("https://api.hesteka.com/api/v1/donations/paypal/initiate", {
                  method: "POST",
                  headers: { "Content-Type": "application/json" },
                  body: JSON.stringify({
                    amount: ${widget.amount},
                    donorEmail: "${widget.donorEmail}",
                    donorName: "${widget.donorName}",
                    type: "one-time",
                    currency: "eur",
                    isCompanyDonation: ${widget.isCompanyDonation}
                  }),
                });
                const data = await res.json();
                if (!res.ok) {
                  error("PayPal Initiate failed: " + (data.message || "Unknown error"));
                  show("error", data.message || "Failed to start PayPal session");
                  return;
                }
                msg.style.display = "none";
                log("PayPal order created: " + data.data.orderId);
                return data.data.orderId;
              } catch (e) {
                error("PayPal createOrder runtime error: " + e.message);
                show("error", "Failed to connect to PayPal.");
              }
            },
            onApprove: async (data) => {
              log("PayPal payment approved, capturing...");
              show("loading", "Processing payment...");
              try {
                const res = await fetch("https://api.hesteka.com/api/v1/donations/paypal/capture", {
                  method: "POST",
                  headers: { "Content-Type": "application/json" },
                  body: JSON.stringify({
                    orderId: data.orderID,
                  }),
                });
                const result = await res.json();
                log("PayPal capture result: " + JSON.stringify(result));
                show("success", "Payment successful!");
                setTimeout(() => {
                   if(window.PaymentChannel) PaymentChannel.postMessage('success');
                }, 1000);
              } catch (e) {
                error("PayPal capture error: " + e.message);
                show("error", "Payment confirmation failed.");
              }
            },
            onError: (err) => {
              error("PayPal SDK error: " + err);
              show("error", "An error occurred during payment.");
              if(window.PaymentChannel) PaymentChannel.postMessage('error:PayPal SDK: ' + err);
            },
          }).render("#paypal-button-container").then(() => {
            log("PayPal buttons rendered");
          }).catch(e => {
            error("PayPal Render Error: " + e.message);
          });
        } catch (e) {
          if(window.PaymentChannel) PaymentChannel.postMessage('error:PayPal Script Error: ' + e.message);
        }
      })();
    </script>
  </body>
</html>
""";
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFFBF4E9),
      appBar: AppBar(
        title: Text(
          widget.paymentMethod == 'stripe'
              ? l10n.paymentStripeCreditCardTitle
              : l10n.paymentPaypalTitle,
        ),
        backgroundColor: const Color(0xFFBA4A22),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: WebViewWidget(controller: _controller),
    );
  }
}
