# stripe 按量收费

[迁移到支付元素](https:###stripe.com/docs/payments/payment-element/migration?integration-path=future#recurring-add-payment-methods)

[Setup Intents API](https:###stripe.com/docs/payments/setup-intents?locale=zh-CN)

[了解 SetupIntents 如何在支付流程中工作](https:###stripe.com/docs/payments/setupintents/lifecycle?locale=zh-CN)

## webhook 回调

[创建 Webhook 端点，以便在发生异步事件时 Stripe 可通知您的集成](https:###dashboard.stripe.com/test/webhooks)

在 Stripe 中，SetupIntent 的状态主要有以下几种：

`requires_payment_method`：当 SetupIntent 被创建时，它的状态为 requires_payment_method，直到有付款方式被附加。

`requires_confirmation`：在客户提供付款方式信息后，SetupIntent 准备好被确认。在大多数集成中，此状态被跳过，因为在确认 SetupIntent 的同时提交付款方式信息。

`requires_action`：如果设置需要额外的操作，例如进行 3D Secure 认证，SetupIntent 的状态为 requires_action。

`processing`：在处理所有必要的操作后，SetupIntent 转移到 processing 状态。虽然某些付款方式（例如卡）可以快速处理，但其他付款方式可能需要长达几天的时间来处理。

`succeeded`：SetupIntent 的状态为 succeeded 表示设置成功。现在你可以将这种付款方式附加到 Customer 对象上，并将其用于未来的付款。如果设置失败，SetupIntent 的状态将返回到 requires_payment_method。

`canceled`：在 SetupIntent 被 processing 或 succeeded 之前的任何时候都可以取消它。
以上就是 SetupIntent 的所有可能状态 1

使用 iDEAL、Bancontact 或 Sofort 确认 SetupIntent，生成 SEPA 直接借记付款方式。 SEPA 直接借记是一种延迟通知付款方式，会先转换为中间 processing 状态，然后在几天后转换为 succeeded 或 requires_payment_method 状态。

## SetupIntent 成功之后，怎么扣费？

SetupIntent 的主要目的是设置并保存客户的付款方式，以便在未来进行收款。一旦 SetupIntent 的状态变为 succeeded，你就可以将这个付款方式附加到一个 Customer 对象上，并在未来的付款中使用它。

以下是一个示例：

const stripe = require('stripe')('sk_test_4eC39HqLyjWDarjtT1zdp7dc');

### 假设你已经获取到了 SetupIntent 的 ID
let setupIntentId = 'your_setup_intent_id';

### 获取 SetupIntent
let setupIntent = await stripe.setupIntents.retrieve(setupIntentId);

### 获取 PaymentMethod 的 ID
let paymentMethodId = setupIntent.payment_method;

### 获取 Customer 的 ID
let customerId = 'your_customer_id';

### 将 PaymentMethod 附加到 Customer
let paymentMethodAttached = await stripe.paymentMethods.attach(paymentMethodId, {customer: customerId});

### 创建一个 PaymentIntent 来收取费用
let paymentIntent = await stripe.paymentIntents.create({
 amount: 2000,
 currency: 'usd',
 customer: customerId,
 payment_method: paymentMethodId,
 off_session: true,
 confirm: true,
});
在这个示例中，我们首先获取到了 SetupIntent 的 ID，然后使用这个 ID 来获取 SetupIntent。然后，我们获取 SetupIntent 的 payment_method 属性，这个属性是 PaymentMethod 的 ID。然后，我们将 PaymentMethod 附加到 Customer 上。最后，我们创建一个 PaymentIntent 来收取费用。

请注意，你需要将 'sk_test_4eC39HqLyjWDarjtT1zdp7dc' 替换为你的 Stripe 密钥，同时将 'your_setup_intent_id' 和 'your_customer_id' 替换为你的 SetupIntent 的 ID 和 Customer 的 ID。

## 用户已经有了一些绑定的 SetupIntent，我怎么让用户做卡片管理呢？

Stripe 并没有直接提供卡片管理的 API，但是你可以通过一些技巧来实现这个功能。以下是一些可能的步骤：

列出用户的所有付款方式：你可以使用 stripe.paymentMethods.list 方法来列出用户的所有付款方式。这个方法需要一个 Customer 的 ID 作为参数。

```
const stripe = require('stripe')('sk_test_4eC39HqLyjWDarjtT1zdp7dc');
```

### 假设你已经获取到了 Customer 的 ID

```
let customerId = 'your_customer_id';
```

### 列出用户的所有付款方式

```
let paymentMethods = await stripe.paymentMethods.list({customer: customerId});
```

删除用户的付款方式：你可以使用 stripe.paymentMethods.detach 方法来删除用户的一个付款方式。这个方法需要一个 PaymentMethod 的 ID 作为参数。

### 假设你已经获取到了 PaymentMethod 的 ID

```
let paymentMethodId = 'your_payment_method_id';
```

### 删除用户的一个付款方式
```
let detachedPaymentMethod = await stripe.paymentMethods.detach(paymentMethodId);
```
更新用户的默认付款方式：你可以使用 stripe.customers.update 方法来更新用户的默认付款方式。这个方法需要一个 Customer 的 ID 和一个 invoice_settings.default_payment_method 属性作为参数。

### 假设你已经获取到了新的默认付款方式的 ID
```
let newDefaultPaymentMethodId = 'new_default_payment_method_id';
```

### 更新用户的默认付款方式
```
let updatedCustomer = await stripe.customers.update(customerId, {
 invoice_settings: {
  default_payment_method: newDefaultPaymentMethodId,
 },
});
```
以上就是如何实现卡片管理的一些基本步骤。请注意，你需要将 'sk_test_3eC39HqLyjWDarjtT1zdp7dc' 替换为你的 Stripe 密钥，同时将 'your_customer_id' 和 'your_payment_method_id' 替换为你的 Customer 的 ID 和 PaymentMethod 的 ID。
