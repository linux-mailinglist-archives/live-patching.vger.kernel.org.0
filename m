Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA4A48E732
	for <lists+live-patching@lfdr.de>; Fri, 14 Jan 2022 10:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232131AbiANJOG (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 14 Jan 2022 04:14:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:41389 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234738AbiANJOF (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 14 Jan 2022 04:14:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642151644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+pWvo2OEmMNI1tZRpROSSx7Oe7LhQALrcOqQAzgndTM=;
        b=DNaWPwS8TzD6qkX8AhspsImAC8Q4TCFRI1Hj5L1GAXfO1Aaaa52pxDfM6zxHEYLAJrdwwQ
        0CHGuxJ9Vyi587gY/KrVbBczpJd98Ld8ezOOw2rWSF959uVkrc4KF1TkOn2r3QH2A8iIJg
        6ZJOLuxAx/D1Mx2CcV0ZlnPEmiAgDZI=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-74-ximuVf9iOFiMWp6JsU2NrA-1; Fri, 14 Jan 2022 04:14:03 -0500
X-MC-Unique: ximuVf9iOFiMWp6JsU2NrA-1
Received: by mail-wm1-f69.google.com with SMTP id c5-20020a1c3505000000b00345c92c27c6so7647265wma.2
        for <live-patching@vger.kernel.org>; Fri, 14 Jan 2022 01:14:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+pWvo2OEmMNI1tZRpROSSx7Oe7LhQALrcOqQAzgndTM=;
        b=VRR+nCRgEuqkJzaTFOyCrG7jCmaPy7/F8FJGmR+Q9rrKcn8C7QNX70n1Q9/wnzVYH+
         siKJjJn4v2+eZfl4qReOg4hXCzHRL58xkeK3Y7Krx23SEzE2wwOTuWM1g/kTkbkDg3hx
         jC2vNwDZqyx/pe/F9tYVitlFc2YkqbwAq5XBqntDlQUlM6KUycmttgrcW712FEJZ/uCC
         iEbVKzahn4g0jvCzXn6XxPnDM4rn+tv3wpji/WxYu4m5CFZYk2C0WcgtYqnvNobq4yNN
         C3mczqHfUw6siaDEEd50BGidW6Yyp/pN2J3Q07QHyDXiwK/JutyoPECZ5pOV5eDIcES6
         MfIw==
X-Gm-Message-State: AOAM533K953a/7bqync83aNgCvl+2kFT56GUzwBTcYwZQUBzPodj0Bgp
        ulENCcKU1A4uAInc1hc5LKIMxSwhqgAR/+OA8AJ44wVc0M+dEPw+uDbN1m+2Kq+BKn7fWc5P9LB
        ku/ZsvbPcdrm2t7SGFlR/FH9O
X-Received: by 2002:adf:e2c4:: with SMTP id d4mr7449725wrj.247.1642151642173;
        Fri, 14 Jan 2022 01:14:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyRWSX6LUT9jDBPafrWdsVXhH8natyGtUEoDRAx4Eqym1QjMxZ7ScRzSJ2TMS04IjlUfo2Tyw==
X-Received: by 2002:adf:e2c4:: with SMTP id d4mr7449692wrj.247.1642151641814;
        Fri, 14 Jan 2022 01:14:01 -0800 (PST)
Received: from localhost (cpc111743-lutn13-2-0-cust979.9-3.cable.virginm.net. [82.17.115.212])
        by smtp.gmail.com with ESMTPSA id d16sm5347116wrq.27.2022.01.14.01.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 01:14:01 -0800 (PST)
Date:   Fri, 14 Jan 2022 09:14:00 +0000
From:   Aaron Tomlin <atomlin@redhat.com>
To:     Petr Mladek <pmladek@suse.com>
Cc:     mcgrof@kernel.org, cl@linux.com, mbenes@suse.cz,
        akpm@linux-foundation.org, jeyu@kernel.org,
        linux-kernel@vger.kernel.org, linux-modules@vger.kernel.org,
        atomlin@atomlin.com, ghalat@redhat.com, allen.lkml@gmail.com,
        live-patching@vger.kernel.org
Subject: Re: [RFC PATCH v2 03/13] module: Move livepatch support to a
 separate file
Message-ID: <20220114091400.3jyiohxh26bzjzvi@ava.usersys.com>
X-PGP-Key: http://pgp.mit.edu/pks/lookup?search=atomlin%40redhat.com
X-PGP-Fingerprint: 7906 84EB FA8A 9638 8D1E  6E9B E2DE 9658 19CC 77D6
References: <20220106234319.2067842-1-atomlin@redhat.com>
 <20220106234319.2067842-4-atomlin@redhat.com>
 <Yd8HpK44aWhhNI/Q@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Yd8HpK44aWhhNI/Q@alley>
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Wed 2022-01-12 17:53 +0100, Petr Mladek wrote:
> It would be better to have the two variants close each other. I mean
> to have it somewhere like:
> 
> #ifdef CONFIG_LIVEPATCH
> 
>    variant A
> 
> #else
> 
>    variant B
> 
> #endif

Petr,

I agree. I'll incorporate this approach into RFC PATCH v3.


Kind regards,

-- 
Aaron Tomlin

