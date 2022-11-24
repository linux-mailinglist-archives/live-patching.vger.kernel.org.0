Return-Path: <live-patching-owner@vger.kernel.org>
X-Original-To: lists+live-patching@lfdr.de
Delivered-To: lists+live-patching@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9682F6373E0
	for <lists+live-patching@lfdr.de>; Thu, 24 Nov 2022 09:29:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiKXI3Y (ORCPT <rfc822;lists+live-patching@lfdr.de>);
        Thu, 24 Nov 2022 03:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiKXI3X (ORCPT
        <rfc822;live-patching@vger.kernel.org>);
        Thu, 24 Nov 2022 03:29:23 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CB587DEF8;
        Thu, 24 Nov 2022 00:29:22 -0800 (PST)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 2CF3C1F8C0;
        Thu, 24 Nov 2022 08:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1669278561; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=d4emVWBJUhe5u0uHQ5OQewGttkQp0KoCl0jT+rAfSO0=;
        b=Qzx6KpGIfSLmpQsi4jHmXhINPjMrw8ki9woHMvzYWM1HIvJ800Lnk+0LO5CCd9Qvt3zM7X
        bUYsCC7OYJlTVwXo6VhudFlz2l5mMVhlYPyWfVgyaUNhByPNJZYHq8txzwqX4qvl9INksX
        ATLQP8+12tg1YTAv4zdF6z5fJ9Tc94A=
Received: from suse.cz (unknown [10.100.201.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id DD98A2C141;
        Thu, 24 Nov 2022 08:29:20 +0000 (UTC)
Date:   Thu, 24 Nov 2022 09:29:20 +0100
From:   Petr Mladek <pmladek@suse.com>
To:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Cc:     Josh Poimboeuf <jpoimboe@kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-modules@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        David Laight <David.Laight@aculab.com>
Subject: Re: [PATCH v8 6/9] livepatch: Use kallsyms_on_each_match_symbol() to
 improve performance
Message-ID: <Y38rYMTSQLrPxz4u@alley>
References: <20221102084921.1615-1-thunder.leizhen@huawei.com>
 <20221102084921.1615-7-thunder.leizhen@huawei.com>
 <Y34f+IqqSGbtC82V@alley>
 <45a28bcf-c6e1-8d39-613a-d30bd7b685f0@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45a28bcf-c6e1-8d39-613a-d30bd7b685f0@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <live-patching.vger.kernel.org>
X-Mailing-List: live-patching@vger.kernel.org

On Thu 2022-11-24 10:36:23, Leizhen (ThunderTown) wrote:
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

I am fine with it.

Best Regards,
Petr
