Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59186483A6
	for <lists+live-patching@lfdr.de>; Fri,  9 Dec 2022 15:20:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiLIOUc (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Fri, 9 Dec 2022 09:20:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiLIOUQ (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Fri, 9 Dec 2022 09:20:16 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603EA1903E;
        Fri,  9 Dec 2022 06:20:16 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 519BF229E8;
        Fri,  9 Dec 2022 14:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1670595614; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Nzwv4m3Hgg/uWdoPi0O3B5YBmF8eSTJJtprw/dS4JvI=;
        b=S9KPDqoEIBpJEb0CYzWi/31c4xU81n60FczF8mVTo/65TE9V/WYhYGIo+p3iAOaE8yb7LI
        9EFZT/TtHuRtVToHzZ+MvaH+6zE8eDtFeaD+Z0MZ3VH09k+EsrWz6c7g/1dgokCsdBWqI6
        X4Kk0boP5CGTvvybOrWwYtg3WoIsVrI=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 2DABF2C141;
        Fri,  9 Dec 2022 14:20:14 +0000 (UTC)
Date:   Fri, 9 Dec 2022 15:20:13 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     Song Liu <song@kernel.org>
Cc:     live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        jpoimboe@kernel.org, jikos@kernel.org, mbenes@suse.cz,
        x86@kernel.org, joe.lawrence@redhat.com,
        linuxppc-dev@lists.ozlabs.org, Josh Poimboeuf <jpoimboe@redhat.com>
Subject: Re: [PATCH v6] livepatch: Clear relocation targets on a module
 removal
Message-ID: <Y5NEHdSSMSyec6S+@alley>
References: <20220901171252.2148348-1-song@kernel.org>
 <Y3expGRt4cPoZgHL@alley>
 <CAPhsuW4qYpX7wzHn5J5Hn9cnOFSZwwQPCjTM_HPTt_zbBS03ww@mail.gmail.com>
 <Y5M+AoKHDK4rn6/i@alley>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y5M+AoKHDK4rn6/i@alley>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Fri 2022-12-09 14:54:10, Petr Mladek wrote:
> On Mon 2022-11-28 17:57:06, Song Liu wrote:
> > On Fri, Nov 18, 2022 at 8:24 AM Petr Mladek <pmladek@suse.com> wrote:
> > > > --- a/kernel/livepatch/core.c
> > > > +++ b/kernel/livepatch/core.c
> I see that you removed also:
> 
> 	if (strcmp(objname ? objname : "vmlinux", sec_objname))
> 		return 0;
> 
> This is another bug in your "simplification".

This actually is not a bug. It was replaced by the strcmp() check below.

> > > > +
> > > > +             if (strcmp(objname, sec_objname))
> > > > +                     continue;

But this works only because the function is not called for "vmlinux".
It can't be unloaded.

Well, this optimization is not worth it. IMHO, it is better when
the API is able to handle "vmlinux" object a safe way.

We always try to make the livepatch API as error-proof as possible.
It is the main idea of livepatching. It should fix bugs without
breaking the running system.

Best Regards,
Petr
