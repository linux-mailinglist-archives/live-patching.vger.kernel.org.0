Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9DD2644E59
	for <lists+live-patching@lfdr.de>; Tue,  6 Dec 2022 23:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiLFWIt (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Tue, 6 Dec 2022 17:08:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbiLFWIs (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Tue, 6 Dec 2022 17:08:48 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD8FF2A413;
        Tue,  6 Dec 2022 14:08:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=jCjmi8ZneEdnXgTJchxomiX/fTGkLt0Zee4oZ7yofqE=; b=D6ukBDyoYS06QTWDRrLaRTlRqT
        XdyToTFp8sItMu/pVXTTic93dBiXRKgDdmlT2+n7j/mwN0GWyKQeekRJnVJaMdZpjUe3PxCpa3avg
        G7seZFcop1r7JsvlwskUzFd5QjfaG3btqgjefLUy13xDlfurEBI4fEqoNyP8QVpa281Iee94S/BE1
        6k7YP/18f/R6dtP42KBkJ4D/L+3XhET+LN6e2arR2JKmvKVFOjcjy7cQlbCODaC+DxW1YqT/TPpS/
        KVEwCyGZUxIDcZem0+OIsoGfsQMDlrJSYCo45Wi1k2zACntrrUzM0UalW9JY8LtT0fGH9YB1lhlu5
        7RRVk8Vw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1p2g7D-003muu-0P; Tue, 06 Dec 2022 22:08:39 +0000
Date:   Tue, 6 Dec 2022 14:08:38 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Cc:     Petr Mladek <pmladek@suse.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-modules@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH v8 6/9] livepatch: Use kallsyms_on_each_match_symbol() to
 improve performance
Message-ID: <Y4+9Zr1BBqsYRxqT@bombadil.infradead.org>
References: <20221102084921.1615-1-thunder.leizhen@huawei.com>
 <20221102084921.1615-7-thunder.leizhen@huawei.com>
 <Y34f+IqqSGbtC82V@alley>
 <45a28bcf-c6e1-8d39-613a-d30bd7b685f0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45a28bcf-c6e1-8d39-613a-d30bd7b685f0@huawei.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu, Nov 24, 2022 at 10:36:23AM +0800, Leizhen (ThunderTown) wrote:
> 
> 
> On 2022/11/23 21:28, Petr Mladek wrote:
> > Hi,
> > 
> > I am sorry for the late review. I have been snowed under another
> > tasks.
> > 
> > On Wed 2022-11-02 16:49:18, Zhen Lei wrote:
> >> Based on the test results of kallsyms_on_each_match_symbol() and
> >> kallsyms_on_each_symbol(), the average performance can be improved by
> >> more than 1500 times.
> > 
> > Sounds great.
> > 
> >> --- a/kernel/livepatch/core.c
> >> +++ b/kernel/livepatch/core.c
> >> @@ -153,6 +153,24 @@ static int klp_find_callback(void *data, const char *name,
> >>  	return 0;
> >>  }
> >>  
> >> +static int klp_match_callback(void *data, unsigned long addr)
> >> +{
> >> +	struct klp_find_arg *args = data;
> >> +
> >> +	args->addr = addr;
> >> +	args->count++;
> >> +
> >> +	/*
> >> +	 * Finish the search when the symbol is found for the desired position
> >> +	 * or the position is not defined for a non-unique symbol.
> >> +	 */
> >> +	if ((args->pos && (args->count == args->pos)) ||
> >> +	    (!args->pos && (args->count > 1)))
> >> +		return 1;
> >> +
> >> +	return 0;
> > 
> > This duplicates most of the klp_find_callback(). Please, call this
> > new function in klp_find_callback() instead of the duplicated code.
> > I mean to do:
> > 
> > static int klp_find_callback(void *data, const char *name, unsigned long addr)
> > {
> > 	struct klp_find_arg *args = data;
> > 
> > 	if (strcmp(args->name, name))
> > 		return 0;
> > 
> > 	return klp_match_callback(data, addr);
> > }
> 
> Good idea. But these patches have been merged into linux-next, how about I post
> a new cleanup patch after v6.2-rc1?

You can send the cleanup now. The code doesn't change drastically, just
base it on modules-next.

  Luis
