Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0248A4B10B8
	for <lists+live-patching@lfdr.de>; Thu, 10 Feb 2022 15:46:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243115AbiBJOp7 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Feb 2022 09:45:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234440AbiBJOp6 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Feb 2022 09:45:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 2C6B8C4C
        for <live-patching@vger.kernel.org>; Thu, 10 Feb 2022 06:45:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644504358;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=M8Xicx5cO6JYsvcdxnszvP7E4kb3rIjZyILIbpstvnc=;
        b=CYrJsiEOXqga3cBQBRFxT2N2Wqqsg5FoD+HC0hAxm0ekLIJjG7pcg/UyImjKXkGgKrrAHp
        Vi+vau1LVwil6L1CQmothOvp6OsPZrce1RkMUvvMAFvguQX75CXbA8tA4r+aamQcLntvtb
        FCpeB8pXWYRz92sWReBCz0h5XJLpa+w=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-591-ODB5ToNpPked6s3F99vB0Q-1; Thu, 10 Feb 2022 09:45:57 -0500
X-MC-Unique: ODB5ToNpPked6s3F99vB0Q-1
Received: by mail-lj1-f199.google.com with SMTP id a13-20020a2eb54d000000b0023f5f64ae4fso2658191ljn.4
        for <live-patching@vger.kernel.org>; Thu, 10 Feb 2022 06:45:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=M8Xicx5cO6JYsvcdxnszvP7E4kb3rIjZyILIbpstvnc=;
        b=m61C+SSvCP8Q0A9skzRhsMFW6pSSut9l5Rqz6ut07/Kri6uNa9fbHXwdayf2s/AtTH
         lQ0+w9hwUvDYrIX49QDapayatTbO2eW/odc13mvZO/SiE79DkAbU/vhn8WKikSdrxKcH
         fzReupYWXsfqDRqXpshqsYA/QsSW0M7j2ARTLcTRDeU6d1sgTwQCvQr5KdyqTqZHc8+7
         cKnOwLbYZy+TTzC8q0eziMLhuzcCddxDLtNNTZ/Wv3kr4WEIEmAVSu4FsCUrOKdhQA0A
         iaEpagGAvWruZt6htJeZIlYX+ZPLQmjWXBKzsAKHt9k+3evrfbYUKryVDTtB9gnmNdZd
         uVKg==
X-Gm-Message-State: AOAM5317s7cMVSr3/rpgVEJZAUNxomrO7a/ipowpPN2xfqEzNZdbdzee
        2h1YO1XOF30FQxLp9n6P2qBPimvwR/71TgOcIBG9RSRd5b0MsWcks2tzXv1KZKXrciet7pQ3S1S
        Pfyj/SYnV4WjXAc/4AemaMEsC7lXhhCFlEvNStJ9l
X-Received: by 2002:a05:6512:3f84:: with SMTP id x4mr4204729lfa.484.1644504355578;
        Thu, 10 Feb 2022 06:45:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwC9RjysectHKxeUKPhvllfxiSlrCWq8mr3WeL2XaNx5vQvpP7mOwVzJtA4X3KJF4uBtDLcN6dn9phCAV4+rt4=
X-Received: by 2002:a05:6512:3f84:: with SMTP id x4mr4204722lfa.484.1644504355403;
 Thu, 10 Feb 2022 06:45:55 -0800 (PST)
MIME-Version: 1.0
References: <20220209170358.3266629-1-atomlin@redhat.com> <20220209170358.3266629-2-atomlin@redhat.com>
 <a22eb1b0-3fb5-a70e-cf6f-022571538efb@csgroup.eu>
In-Reply-To: <a22eb1b0-3fb5-a70e-cf6f-022571538efb@csgroup.eu>
From:   Aaron Tomlin <atomlin@redhat.com>
Date:   Thu, 10 Feb 2022 14:45:44 +0000
Message-ID: <CANfR36jh3yg9nqXkpCUWPeHV+sSD6yne9j1=uA5vyUpYOC8t9g@mail.gmail.com>
Subject: Re: [PATCH v5 01/13] module: Move all into module/
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     "mcgrof@kernel.org" <mcgrof@kernel.org>,
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
        "void@manifault.com" <void@manifault.com>,
        "joe@perches.com" <joe@perches.com>,
        "msuchanek@suse.de" <msuchanek@suse.de>,
        "oleksandr@natalenko.name" <oleksandr@natalenko.name>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2022-02-10 11:11 +0000, Christophe Leroy wrote:
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 3e461db9cd91..7e6232bd15f5 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -13001,7 +13001,7 @@ L:    linux-kernel@vger.kernel.org
> >   S:    Maintained
> >   T:    git git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git modules-next
> >   F:    include/linux/module.h
> > -F:    kernel/module.c
> > +F:    kernel/module/main.c
>
> Shouldn't it be the entire directory ?

Firstly, thank you for your feedback Christophe.

Indeed it should. Moving forward: kernel/module/*

> > @@ -44,6 +44,7 @@ static inline int module_decompress(struct load_info *info,
> >   {
> >       return -EOPNOTSUPP;
> >   }
> > +
>
> This new line should be in patch 3 instead.

Fair enough. Given that the purpose of this particular patch is a simple
migration, style violations e.g. "Please use a blank line after
function/struct/union/enum declarations", can be resolved at a later stage.


Kind regards,

-- 
Aaron Tomlin

