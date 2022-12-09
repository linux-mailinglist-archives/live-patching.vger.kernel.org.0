Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 748E0648268
	for <lists+live-patching@lfdr.de>; Fri,  9 Dec 2022 13:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbiLIMgX (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Dec 2022 07:36:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiLIMgX (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Dec 2022 07:36:23 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763D4663F6;
        Fri,  9 Dec 2022 04:36:22 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 3304B1FDD3;
        Fri,  9 Dec 2022 12:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1670589381; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XhaJ4AMLCZEgETruIyMo/c72wUMpujHKYsj5J9PetEI=;
        b=lj1aIbaOrUSW/4IH3P9xvkmt4sS+Vua3KVOSLWW/4ZaVjpZXUf9PCF+2AwJBYEoH8Ueq+T
        l1+VZhtJg3kaqSfdImLzMaVFZi0C0SAPfITWqkfevOBbkkFhYn9WKW6g/6rao/X8/xjDI9
        bRjyq6IBZlNlaPWlMUzXxToftLaK8Og=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 0EA7A2C141;
        Fri,  9 Dec 2022 12:36:21 +0000 (UTC)
Date:   Fri, 9 Dec 2022 13:36:17 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <song@kernel.org>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
        x86@kernel.org, joe.lawrence@redhat.com,
        linuxppc-dev@lists.ozlabs.org, Josh Poimboeuf <jpoimboe@redhat.com>
Subject: x86 part: was: Re: [PATCH v6] livepatch: Clear relocation targets on
 a module removal
Message-ID: <Y5MrwePZoa5tYlQP@alley>
References: <20220901171252.2148348-1-song@kernel.org>
 <Y3expGRt4cPoZgHL@alley>
 <CAPhsuW4qYpX7wzHn5J5Hn9cnOFSZwwQPCjTM_HPTt_zbBS03ww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW4qYpX7wzHn5J5Hn9cnOFSZwwQPCjTM_HPTt_zbBS03ww@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2022-11-28 17:57:06, Song Liu wrote:
> On Fri, Nov 18, 2022 at 8:24 AM Petr Mladek <pmladek@suse.com> wrote:
> --- a/arch/x86/kernel/module.c
> +++ b/arch/x86/kernel/module.c
> > This duplicates a lot of code. Please, rename apply_relocate_add() the
> > same way as __apply_clear_relocate_add() and add the "apply" parameter.
> > Then add the wrappers for this:
> >
> > int write_relocate_add(Elf64_Shdr *sechdrs,
> >                        const char *strtab,
> >                        unsigned int symindex,
> >                        unsigned int relsec,
> >                        struct module *me,
> >                        bool apply)
> > {
> >         int ret;
> >         bool early = me->state == MODULE_STATE_UNFORMED;
> >         void *(*write)(void *, const void *, size_t) = memcpy;
> >
> >         if (!early) {
> >                 write = text_poke;
> >                 mutex_lock(&text_mutex);
> >         }
> 
> How about we move the "early" logic into __write_relocate_add()?

If I get it correctly then __write_relocate_add() has three different
return paths. I am not sure if this could be moved there a reasonable
way.

Anyway, I do not resist on the above proposal. Feel free to find
another solution that reduces the duplicated code and looks
reasonable. I am sure that there are more possibilities.

Best Regards,
Petr
