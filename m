Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7D924BA5B5
	for <lists+live-patching@lfdr.de>; Thu, 17 Feb 2022 17:26:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242935AbiBQQ1F (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 17 Feb 2022 11:27:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242893AbiBQQ1E (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 17 Feb 2022 11:27:04 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 805029BB8A
        for <live-patching@vger.kernel.org>; Thu, 17 Feb 2022 08:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645115208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hCGdZ67U7n7QTxmEpkXTMre/CxFj1dLb8EpsB9Wt9NU=;
        b=GezvIP/FDCuCmOONL2/N+znUrvSlf3Dn1YzdVsR8UGtqHkUlHeHjrzXvZ4uMgpgTxfZdQB
        5Fdi+oNp1g9Pot3OTRH3VRqxQNJxihltcVv0Bw7qEyr0U+qAbCIbXMp9h+usElW1+8fgAH
        yT1qx1qbo0kM/mYTRrQVGvDci7EE68E=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-q2LwCrooOJaUNBhdbbX56w-1; Thu, 17 Feb 2022 11:26:47 -0500
X-MC-Unique: q2LwCrooOJaUNBhdbbX56w-1
Received: by mail-lj1-f197.google.com with SMTP id i8-20020a2ea228000000b002449296c787so43864ljm.18
        for <live-patching@vger.kernel.org>; Thu, 17 Feb 2022 08:26:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hCGdZ67U7n7QTxmEpkXTMre/CxFj1dLb8EpsB9Wt9NU=;
        b=ZlPhms35BhKeREkZNCSy7TqnRo1LeuoimD5fLufm2SeItaLPfU0iVMoj9yEUG9A7iN
         tL1klGGjM1aclGX0HyE+e05BAauyUdMBhF2prQhGz5lK0lzmVWIzcE6GMsR2M4qIb0qa
         /RX9iJy3nTKvZQiDjKltsuVxNIE6dE3Yvx4p2QAcWiE7NdnjgzXdDFzyPeHl36C6grtY
         Of8pWyuiAZPdSEseMi0Ol4uivRkoxGfzJu7amuuoH373YjdF5Mh/6e5qssRs++Z6meax
         NJIBfSIb/5hxX54k3fmLWRFKtTuOU1rqPmwCj1hfGFVQX/ISBDzerNkckvbnrrTiWOJa
         CbDQ==
X-Gm-Message-State: AOAM532OfcdN2ce7rJmYlii1zH6aH79lFCu/yEGskgUcoalHOaSAXS7k
        e6IiIdDlp48FCWfTkwm8MjQ3bEvH8GeT4npn59sXOAgPdhxvRlyylndFXNXKdDz3Z5N0SGOfex8
        6lJdQaKJLjNflblgwsSJdOfNypuxUl3oklP/S9q8u
X-Received: by 2002:a05:6512:150d:b0:442:aad5:2550 with SMTP id bq13-20020a056512150d00b00442aad52550mr2567903lfb.678.1645115205793;
        Thu, 17 Feb 2022 08:26:45 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzLZ9H9RgrFT61tMlkFrlaF/ED3Z9gDTXl+XfGnohcx4TPIGO+mRgxBZFxuaJb0yee8DvwIgmsS16CP6ZukixU=
X-Received: by 2002:a05:6512:150d:b0:442:aad5:2550 with SMTP id
 bq13-20020a056512150d00b00442aad52550mr2567879lfb.678.1645115205613; Thu, 17
 Feb 2022 08:26:45 -0800 (PST)
MIME-Version: 1.0
References: <20220209171118.3269581-1-atomlin@redhat.com> <20220209171118.3269581-3-atomlin@redhat.com>
 <14a1678f-0c56-1237-c5c7-4ca1bac4b42a@csgroup.eu> <CANfR36gVY+1k7YJy0fn1z+mGv-LqEmZJSvSHXn_BFR4WC+oJrQ@mail.gmail.com>
 <alpine.LSU.2.21.2202171648590.29121@pobox.suse.cz>
In-Reply-To: <alpine.LSU.2.21.2202171648590.29121@pobox.suse.cz>
From:   Aaron Tomlin <atomlin@redhat.com>
Date:   Thu, 17 Feb 2022 16:26:33 +0000
Message-ID: <CANfR36hExnjBM1=529Ae6EvETx7XiPFDSmZCTOV2MLS_YEfoCQ@mail.gmail.com>
Subject: Re: [PATCH v5 13/13] module: Move version support into a separate file
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "mcgrof@kernel.org" <mcgrof@kernel.org>,
        "cl@linux.com" <cl@linux.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "atomlin@atomlin.com" <atomlin@atomlin.com>,
        "ghalat@redhat.com" <ghalat@redhat.com>,
        "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
        "void@manifault.com" <void@manifault.com>,
        "joe@perches.com" <joe@perches.com>,
        "msuchanek@suse.de" <msuchanek@suse.de>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2022-02-17 16:51 +0100, Miroslav Benes wrote:
> It is not, but "struct find_symbol_arg", which you moved, uses "enum
> mod_license" defined above, so you can either leave it as it is, or carve
> "enum mod_license" definition out.

Hi Miroslav,

I've done this already for v6. I hope to share the latest version for
review shortly.


Kind regards,

-- 
Aaron Tomlin

