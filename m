Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 507594C1929
	for <lists+live-patching@lfdr.de>; Wed, 23 Feb 2022 17:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236079AbiBWQ6G (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Wed, 23 Feb 2022 11:58:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242269AbiBWQ5x (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Wed, 23 Feb 2022 11:57:53 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ECE6B25E5
        for <live-patching@vger.kernel.org>; Wed, 23 Feb 2022 08:57:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645635443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9lYnlwo80ekeXGGRVop7tuYwutJe1OPkYrSCkXet1IY=;
        b=b0zVWW81StNSVD+Tj7iHkrC0lOsRpCC2RSTMlIS1fuc1UrpeXAGkp8iHz4gwvrWCcRqYYB
        krRcA17XmOavg69nYiBiRT5lL2s5AjtOr0DPN8EA6Gcb0pqJRHT0txpVg+VIb4x7hsQ76o
        SA4tsSOCWshA0NHZAnZsaUrWxpcmcsk=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-357-ZF2RtnW3Pk6uf8iIbsyCTQ-1; Wed, 23 Feb 2022 11:57:21 -0500
X-MC-Unique: ZF2RtnW3Pk6uf8iIbsyCTQ-1
Received: by mail-lf1-f72.google.com with SMTP id m18-20020a0565120a9200b004439214844dso3341169lfu.9
        for <live-patching@vger.kernel.org>; Wed, 23 Feb 2022 08:57:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9lYnlwo80ekeXGGRVop7tuYwutJe1OPkYrSCkXet1IY=;
        b=aHyvIn8yDx1x4ji2zag+TXz92PniJFXzFMqjosW4oVL4SqbxFZuFhyUipHJqgoKGYx
         K2EIoOiEuMMr1PAPrGry3E2U8p7id2FQvOy4jqu30BaedwhI2ihrjylc42b/upgIfoI0
         i+eU/bY4Pgu8xwzuKjBsaU3F9apIEly9ZXTpad4hNV9uRDSsbMCEAl6Szvb5AntvniIO
         QfTMiyejQ/jGEegP8dEH+j4XolOMzH2HN/3ShseDaK0+FOH3Ygd2ZAUZm8Lu1wn8WHeh
         prPzbrEsGSzZ+INiqtUyrZIre2P7EqtoqZInhgJK0+Ch15Femw1H9YKJpyQDG9TuC3lj
         yP/A==
X-Gm-Message-State: AOAM533dlma3bkFvBoMYDqeW7tf9z02TZG4LQ9oz+uxK1PwJOVOORDjq
        +SZmZVY886PIHb5WwEcl5JfAx9Gq/x8/65zqn0cfnFAQGImAvflnT6Qy0TJJdL21jT8K1SKH1vB
        AXTXdAbuvcpVWp+6I21D5sMph3lCldJKYrRI/TaCq
X-Received: by 2002:a05:6512:3e14:b0:429:6e79:ca87 with SMTP id i20-20020a0565123e1400b004296e79ca87mr373899lfv.163.1645635440060;
        Wed, 23 Feb 2022 08:57:20 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz8y+omW9xDDExHxhQDd6HLWNp9jDmHi7Vn79thFemSUK3HSORLo1ni7xvXLOo+Lt62XO3uuANFgjglrY2gMK4=
X-Received: by 2002:a05:6512:3e14:b0:429:6e79:ca87 with SMTP id
 i20-20020a0565123e1400b004296e79ca87mr373887lfv.163.1645635439848; Wed, 23
 Feb 2022 08:57:19 -0800 (PST)
MIME-Version: 1.0
References: <20220218212511.887059-1-atomlin@redhat.com> <20220218212511.887059-2-atomlin@redhat.com>
 <69fcaad3-e48c-11ca-ed50-7a18831e3e91@csgroup.eu> <CANfR36js06qG8HkQBPPz8bnYzcBRUtiZJAqhynt4XJcfcFXAQg@mail.gmail.com>
 <YhWK4woM1g2fAq72@bombadil.infradead.org>
In-Reply-To: <YhWK4woM1g2fAq72@bombadil.infradead.org>
From:   Aaron Tomlin <atomlin@redhat.com>
Date:   Wed, 23 Feb 2022 16:57:08 +0000
Message-ID: <CANfR36jtiq86FpONCFPOsh6x=eLnC9js+LewtUTSfZxoHoMb6w@mail.gmail.com>
Subject: Re: [PATCH v6 01/13] module: Move all into module/
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Thiago Jung Bauermann <bauerman@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Philipp Rudo <prudo@linux.ibm.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        "cl@linux.com" <cl@linux.com>,
        "pmladek@suse.com" <pmladek@suse.com>,
        "mbenes@suse.cz" <mbenes@suse.cz>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-modules@vger.kernel.org" <linux-modules@vger.kernel.org>,
        "live-patching@vger.kernel.org" <live-patching@vger.kernel.org>,
        "atomlin@atomlin.com" <atomlin@atomlin.com>,
        "ghalat@redhat.com" <ghalat@redhat.com>,
        "allen.lkml@gmail.com" <allen.lkml@gmail.com>,
        "joe@perches.com" <joe@perches.com>,
        "msuchanek@suse.de" <msuchanek@suse.de>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Tue 2022-02-22 17:16 -0800, Luis Chamberlain wrote:
> How about:
>
> obj-$(CONFIG_MODULE_SIG_FORMAT) += module/module_signature.o
>
>   Luis

Hi Luis,

Please see v8 [1].

[1]: https://lore.kernel.org/all/20220222141303.1392190-1-atomlin@redhat.com/


Kind regards,

-- 
Aaron Tomlin

