Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A75F4B1409
	for <lists+live-patching@lfdr.de>; Thu, 10 Feb 2022 18:21:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245121AbiBJRUb (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 10 Feb 2022 12:20:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245118AbiBJRUa (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 10 Feb 2022 12:20:30 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id BA8BCE71
        for <live-patching@vger.kernel.org>; Thu, 10 Feb 2022 09:20:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644513630;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SVIUy3YEzbIOwDBGTHyt0++Vn4z6UjSjAvlypOu8m5g=;
        b=eYxI9qfgc4UqvjjNyFWFJynXcojDThIBpd98RFdnEoJrs8KXPnlJ4prmwPWMORdz9p31gQ
        6yK2be6kL0MxBlzYfaDBfTqJ/TaCs3SYnTi5PGTzv8WRFWuIwKUXeLiGiRQULiSC67DPos
        ezZimA7tOPTzmAz23DeTp8JyOOeXqtY=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-Yxp2LPARMgK2ciJ03udjNQ-1; Thu, 10 Feb 2022 12:20:29 -0500
X-MC-Unique: Yxp2LPARMgK2ciJ03udjNQ-1
Received: by mail-lj1-f197.google.com with SMTP id a22-20020a05651c031600b0023d78ecb40cso2864328ljp.8
        for <live-patching@vger.kernel.org>; Thu, 10 Feb 2022 09:20:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SVIUy3YEzbIOwDBGTHyt0++Vn4z6UjSjAvlypOu8m5g=;
        b=x/94V540nFelB9wvSWK7wlBnFtMi/md8IPrnQuLzk5iBmPUGWV6886whtLI5tlC8BP
         MDMaiwu5lBDAK4GVgv44KIBun6UJXUizo13xf4qrI7cLY7oGKwYQxllFg/gMX0enDYMf
         NTpkdVJGI0gobU4Xgq1rjXPiwpbltfQ6LGTB1JgwLubGcfssbG0/2U/dPn5n3+5ATRs5
         tgBhNJUGy+6dyN3wiE1UfQ1FJEDxA+Nk8QDPFHBzbNh6CMOsJwkANxbScLgXfAXEDohq
         sfPA8In37yzq2PsgxkmfXxH6NFj83uUi0UkeXnsfFTeY8XeNjrRl8xzaSaGHDn/MX9VD
         oHGw==
X-Gm-Message-State: AOAM532yYFaEBjL5NAMGOJo32zvsekRgBqmGk88ryi3IL7P+XArr/kQD
        yX5/V0ulmb5Nw6KbohH30dKcDvH/o9nW17fHDMK212VsqHtKboe2vRqpyoQ79SyYWU/3qg91YDq
        NEzyTYRBIoKf6Dt5cgjgDFMPRTPhlsv4jZTB778fx
X-Received: by 2002:a05:6512:10c2:: with SMTP id k2mr2649525lfg.118.1644513628038;
        Thu, 10 Feb 2022 09:20:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzdC2WYF1MjtM0D647lyE/jFUeL6Kz6D4x3PT6XN17z8ru+VP3vWE2qW4glTva4tAxOSkk0lKTWVTsG8aBNdBs=
X-Received: by 2002:a05:6512:10c2:: with SMTP id k2mr2649499lfg.118.1644513627797;
 Thu, 10 Feb 2022 09:20:27 -0800 (PST)
MIME-Version: 1.0
References: <20220209170358.3266629-1-atomlin@redhat.com> <20220209170358.3266629-5-atomlin@redhat.com>
 <c8f97323-fcaa-5316-df79-60fd91c837aa@csgroup.eu>
In-Reply-To: <c8f97323-fcaa-5316-df79-60fd91c837aa@csgroup.eu>
From:   Aaron Tomlin <atomlin@redhat.com>
Date:   Thu, 10 Feb 2022 17:20:16 +0000
Message-ID: <CANfR36gBDrBvCRtxy2Dg+hJaoQDxAfZH1x3_JPHO2UAB-bCi6w@mail.gmail.com>
Subject: Re: [PATCH v5 04/13] module: Move livepatch support to a separate file
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
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2022-02-10 11:44 +0000, Christophe Leroy wrote:
> This change is wrong, build fails with it because is_livepatch_module()
> is nowhere defined.

Yes, sorry about that. This was an omission/or oversight during the rebase
attempt.

> You could move is_livepatch_module() to include/linux/livepatch.h but as
> a separate patch.

Fair enough. Albeit, I'd prefer to revert and keep is_livepatch_module()
in include/linux/module.h - this is likely the best solution.
Note: set_livepatch_module() will remain for internal use only.

> >   #else /* !CONFIG_LIVEPATCH */
> >   static inline bool is_livepatch_module(struct module *mod)
> >   {
> > diff --git a/kernel/module/Makefile b/kernel/module/Makefile
> > index 2902fc7d0ef1..ee20d864ad19 100644
> > --- a/kernel/module/Makefile
> > +++ b/kernel/module/Makefile
> > @@ -7,3 +7,6 @@ obj-$(CONFIG_MODULES) += main.o
> >   obj-$(CONFIG_MODULE_DECOMPRESS) += decompress.o
> >   obj-$(CONFIG_MODULE_SIG) += signing.o
> >   obj-$(CONFIG_MODULE_SIG_FORMAT) += signature.o
> > +ifdef CONFIG_MODULES
>
> CONFIG_LIVEPATCH depends on CONFIG_MODULES so this ifdef is not needed

Agreed.

> Checkpatch reports the following:
>
> WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
> #80:
> new file mode 100644
>
> CHECK: Comparison to NULL could be written "!mod->klp_info"
> #109: FILE: kernel/module/livepatch.c:25:
> +    if (mod->klp_info == NULL)
>
> CHECK: Comparison to NULL could be written "!mod->klp_info->sechdrs"
> #119: FILE: kernel/module/livepatch.c:35:
> +    if (mod->klp_info->sechdrs == NULL) {
>
> CHECK: Comparison to NULL could be written "!mod->klp_info->secstrings"
> #127: FILE: kernel/module/livepatch.c:43:
> +    if (mod->klp_info->secstrings == NULL) {
>
> CHECK: No space is necessary after a cast
> #142: FILE: kernel/module/livepatch.c:58:
> +    mod->klp_info->sechdrs[symndx].sh_addr = (unsigned long)
> mod->core_kallsyms.symtab;

Ok.

> Given how simple this function is, it should be a 'static inline' in
> internal.c

Agreed.

> CHECK: Alignment should match open parenthesis
> #285: FILE: kernel/module/main.c:3033:
> +    pr_err("%s: module is marked as livepatch module, but livepatch
> support is disabled",
> +        mod->name);

Fair enough.


Kind regards,

-- 
Aaron Tomlin

