const functions = require("firebase-functions");
const stripe = require('stripe')(functions.config().stripe.testkey);

const calculateOrderAmount = (items) => {
    costs = [];
    catalog = [
        { 'time': '1684767425641', 'cost': 22 },
        { 'time': '1685371351192', 'cost': 11 },
        { 'time': '1685422224484', 'cost': 13 },
    ];

    items.forEach(item => {
        cost = catalog.find(x => x.id == item.id).cost;
        costs.push(cost);
    });

    return parseInt(costs.reduce((a, b) => a + b) * 100);
}

const generateResponse = function (intent) {
    switch (intent.status) {
        case 'requires_actions':
            return {
                clientSecret: intent.clientSecret,
                requiresAction: true,
                status: intent.status,
            };
        case 'requires_payment_method':
            return {
                'error': 'Your card was denied, please provide a new payment method',
            };
        case 'succeeded':
            console.log('Payment succeeded.');
            return {
                clientSecret: intent.clientSecret,
                status: intent.status,
            };
    }
    return { error: 'Failed' };
}

exports.StripePayEndpointMethodId = functions.https.onRequest(async (req, res) => {
    const { paymentMethodId, items, currency, useStripeSdk, } = req.body;

    const orderAmount = calculateOrderAmount(items);

    try {
        if (paymentMethodId) {
            const params = {
                amount: orderAmount,
                confirm: true,
                confirmation_method: 'manual',
                currency: currency,
                payment_method: paymentMethodId,
                use_stripe_sdk: useStripeSdk,
            }
            const intent = await stripe.paymentIntents.create(params);
            console.log(`Intent: ${intent}`);
            return res.send(generateResponse(intent));
        }
        return res.sendStatus(400);
    } catch (e) {
        return res.send({ error: e.message });
    }
});

exports.StripePayEndpointIntentId = functions.https.onRequest(async (req, res) => {
    const { paymentIntentId } = req.body;

    try {
        if (paymentIntentId) {
            const intent = await stripe.paymentIntents.confirm(paymentIntentId);
            return res.send(generateResponse(intent));
        }
        return res.sendStatus(400);
    } catch (e) {
        return res.send({ error: e.message });
    }
});

