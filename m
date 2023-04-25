Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DB036EDDF0
	for <lists+live-patching@lfdr.de>; Tue, 25 Apr 2023 10:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233628AbjDYI16 (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 25 Apr 2023 04:27:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233592AbjDYI14 (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 25 Apr 2023 04:27:56 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053FD49C3;
        Tue, 25 Apr 2023 01:27:49 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 187F31FDA6;
        Tue, 25 Apr 2023 08:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1682411267; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JLB7kXBwD6M3L2ptdlJ1RgiEVolFGhSHXNJBDXePmiQ=;
        b=tKqQdtrPgsQzoBCwf1xVC9ezD0o09G725durIPriNpoWDj+KTM+R3Yn6rphCy+nrdhpCmP
        e53k/de1aXflSQalIJ9h0q4ZCkmLRSDLUauYiqngel4Q3qvvj21mZsMo8lIqIxzHGh4pUS
        Gso8q3PreoZelIC87zLP1oo7AeBGD3k=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 616EB2C141;
        Tue, 25 Apr 2023 08:27:45 +0000 (UTC)
Date:   Tue, 25 Apr 2023 10:27:42 +0200
From:   Petr Mladek <pmladek@suse.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Nick Alcock <nick.alcock@oracle.com>, masahiroy@kernel.org,
        linux-modules@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de,
        akpm@linux-foundation.org, eugene.loh@oracle.com,
        kris.van.hees@oracle.com, live-patching@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH modules-next v10 00/13] kallsyms: reliable
 symbol->address lookup with /proc/kallmodsyms
Message-ID: <ZEeO_rWL4bDh5vui@alley>
References: <20221205163157.269335-1-nick.alcock@oracle.com>
 <20230407232118.o2x5lakfgyzy56gz@treble>
 <ZEbc20oRFR0f8Qj6@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZEbc20oRFR0f8Qj6@bombadil.infradead.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Mon 2023-04-24 12:47:39, Luis Chamberlain wrote:
> On Fri, Apr 07, 2023 at 04:21:18PM -0700, Josh Poimboeuf wrote:
> > Anyway, I was nodding along with the above cover letter until I got to
> > the third paragraph.
> > 
> > A "built-in kernel module" is not actually a module, as it's built in to
> > vmlinux.  I suspect the point is that if you rebuild with a different
> > config, it might become a module.  But many other changes could also
> > occur with a changed config, including changed inlining decisions and
> > GCC IPA optimization function renaming, in which case the symbol might
> > no longer exist with the new config.
> 
> Yes it does not matter, for his tooling effort it was just to be able
> to map a possible module to a symbol so tooling can display this to
> disambiguate.

Note that the same symbol name might be used many times even within
one module. The module might be linked from more .o files. And
more .o files might have a local symbol with the same name.

I think that the best solution is to associate the symbol with
the file name and line. These is very useful information in general.

Best Regards,
Petr
