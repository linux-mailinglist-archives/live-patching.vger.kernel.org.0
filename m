Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7E24BF547
	for <lists+live-patching@lfdr.de>; Tue, 22 Feb 2022 10:59:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbiBVJ6k (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 22 Feb 2022 04:58:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbiBVJ6k (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 22 Feb 2022 04:58:40 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EACCD2259;
        Tue, 22 Feb 2022 01:58:15 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 4564C1F399;
        Tue, 22 Feb 2022 09:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1645523894; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y5GiOCWyeRNu4Zx3wuj0p1rRKzfkl//8M11MTJzWbPg=;
        b=04SsNXRuqTQ59cl74SWmtJZRgch/xzB3XgDzOibkkOQm6joOonjthNxieEOWcl+PvMnBya
        vY17fywk0ZWPMGfy/LE/0aDLzBPJzn1RnRPgDw6i5exW7ZWlvQoRPPLF6oiowYuP8KFjzp
        xnMml9FUs+j2HmVhgi4DD804ERfYogw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1645523894;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=y5GiOCWyeRNu4Zx3wuj0p1rRKzfkl//8M11MTJzWbPg=;
        b=P2gGhuZ/H+IDwA+9ZlGybz3E+8W0g2+ia41BqcPMh/kxhmLnvi2Zr7UOrB0x9WvP2QnviA
        Tw0iW7zdCTPosZCA==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id E01D2A3B81;
        Tue, 22 Feb 2022 09:58:13 +0000 (UTC)
Date:   Tue, 22 Feb 2022 10:58:13 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Aaron Tomlin <atomlin@redhat.com>
cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        "Lameter, Christoph" <cl@linux.com>,
        Petr Mladek <pmladek@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>, jeyu@kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-modules@vger.kernel.org, live-patching@vger.kernel.org,
        Aaron Tomlin <atomlin@atomlin.com>,
        Grzegorz Halat <ghalat@redhat.com>,
        Allen <allen.lkml@gmail.com>, Joe Perches <joe@perches.com>,
        Michal Suchanek <msuchanek@suse.de>, oleksandr@natalenko.name
Subject: Re: [PATCH v6 09/13] module: Move kallsyms support into a separate
 file
In-Reply-To: <CANfR36iGqX93rvv1M6AwGdR=C-Ev314iKCMpEzHOO0-LXAzJig@mail.gmail.com>
Message-ID: <alpine.LSU.2.21.2202221055470.15071@pobox.suse.cz>
References: <20220218212511.887059-1-atomlin@redhat.com> <20220218212511.887059-10-atomlin@redhat.com> <98cff67e-d2ca-705b-7c83-bd3f41df98d9@csgroup.eu> <0ea89614-9bab-99f5-47a8-2a2996c38966@csgroup.eu>
 <CANfR36iGqX93rvv1M6AwGdR=C-Ev314iKCMpEzHOO0-LXAzJig@mail.gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon, 21 Feb 2022, Aaron Tomlin wrote:

> On Mon 2022-02-21 09:35 +0100, Christophe Leroy wrote:
> > Fixup:
> >
> > diff --git a/kernel/module/kallsyms.c b/kernel/module/kallsyms.c
> > index 6c8f1f390cf5..2ee8d2e67068 100644
> > --- a/kernel/module/kallsyms.c
> > +++ b/kernel/module/kallsyms.c
> > @@ -171,8 +171,7 @@ void add_kallsyms(struct module *mod, const struct
> > load_info *info)
> >      Elf_Shdr *symsec = &info->sechdrs[info->index.sym];
> >
> >      /* Set up to point into init section. */
> > -    mod->kallsyms = (struct mod_kallsyms __rcu *)mod->init_layout.base +
> > -        info->mod_kallsyms_init_off;
> > +    mod->kallsyms = (void __rcu *)mod->init_layout.base +
> > info->mod_kallsyms_init_off;
> >
> >      /* The following is safe since this pointer cannot change */
> >      rcu_dereference_sched(mod->kallsyms)->symtab = (void *)symsec->sh_addr;
> 
> Agreed.

Could you split all of this to a follow-up patch, please? So that 9/13 is 
really only about moving the code.

Btw, the sparse warnings "dereference of noderef expression" appeared 
after 5/13 of the series which moved latched RB-tree support, so it does 
not belong here anyway.

Miroslav
