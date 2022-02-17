Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF984BA50F
	for <lists+live-patching@lfdr.de>; Thu, 17 Feb 2022 16:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbiBQPvi (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 17 Feb 2022 10:51:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242620AbiBQPvg (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 17 Feb 2022 10:51:36 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DE52B31BE;
        Thu, 17 Feb 2022 07:51:06 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id EF95C210E3;
        Thu, 17 Feb 2022 15:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1645113064; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LKo/E9dyb7NvEEgMEIwh2cqUg6haJPksCBJCLqhDMjU=;
        b=ouf+0/gMjnsv+G2TpNUu6NnOIcZYJuLjYA0H9ZFhuPjY66j1QWkTaRJpH5G1keqmO+9fzO
        E9lzwz4lAHn5f5DGNHBMW/lQX1jO0VLkkfd0NBhvPktDEyxkEh0HplQrqhVqfPb53gANvY
        qpZ47QsnmDeclIGjIetSU3j6z+Io2Jk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1645113064;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LKo/E9dyb7NvEEgMEIwh2cqUg6haJPksCBJCLqhDMjU=;
        b=AZY+n4sYyu3MEaw+aR/zNxThVPo665c7de5umURlu3dqC622zsI1ArRdJL+PJQ17Ii+LET
        nOY6/dyN1LebGwDA==
Received: from pobox.suse.cz (pobox.suse.cz [10.100.2.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 82D05A3B84;
        Thu, 17 Feb 2022 15:51:04 +0000 (UTC)
Date:   Thu, 17 Feb 2022 16:51:04 +0100 (CET)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Aaron Tomlin <atomlin@redhat.com>
cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
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
Subject: Re: [PATCH v5 13/13] module: Move version support into a separate
 file
In-Reply-To: <CANfR36gVY+1k7YJy0fn1z+mGv-LqEmZJSvSHXn_BFR4WC+oJrQ@mail.gmail.com>
Message-ID: <alpine.LSU.2.21.2202171648590.29121@pobox.suse.cz>
References: <20220209171118.3269581-1-atomlin@redhat.com> <20220209171118.3269581-3-atomlin@redhat.com> <14a1678f-0c56-1237-c5c7-4ca1bac4b42a@csgroup.eu> <CANfR36gVY+1k7YJy0fn1z+mGv-LqEmZJSvSHXn_BFR4WC+oJrQ@mail.gmail.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

> > > +struct symsearch {
> > > +    const struct kernel_symbol *start, *stop;
> > > +    const s32 *crcs;
> > > +    enum mod_license {
> > > +        NOT_GPL_ONLY,
> > > +        GPL_ONLY,
> > > +    } license;
> > > +};
> >
> > Why don't leave this in main.c ?
> 
> Yes, struct 'symsearch' is not used outside of kernel/module/main.c.

It is not, but "struct find_symbol_arg", which you moved, uses "enum 
mod_license" defined above, so you can either leave it as it is, or carve 
"enum mod_license" definition out.

Miroslav
